#' Binary Segmentation
#'
#' Binary segmentation for changepoint detection on a sequential data set up to K segments
#'
#' @param data.vec input data vector, [number of data points]
#' @param Kmax max number of segments
#'
#' @return Vector of square loss values, [number of segments]
#' @export
#'
#' @importFrom data.table :=
#'
#' @examples
#' data(neuroblastoma, package="neuroblastoma")
#' library(data.table)
#' nb.dt <- data.table(neuroblastoma$profiles)
#' data.dt <- nb.dt[profile.id=="1" & chromosome=="1"]
#' BINSEG(data.dt$logratio,3)
BINSEG <- function(data.vec, Kmax){
  data.dt <- data.table::data.table(logratio = data.vec)
  data.dt[, cum.data := cumsum(logratio)]
  possible.dt <- data.table::data.table(
    first_seg_end = seq(1, nrow(data.dt)-1))
  ## Loss = sum of squares - sum^2/n.
  loss <- function(cum.sum.vec, cum.square.vec, N.data.vec){
    cum.square.vec-cum.sum.vec^2/N.data.vec
  }
  data.dt[, data.i := 1:.N]
  data.dt[, cum.square := cumsum(logratio^2)]
  possible.dt[, first_seg_loss := {
    data.dt[
      first_seg_end,
      loss(cum.data, cum.square, first_seg_end)
    ]  
  }]
  possible.dt[, cum.data.after := {
    data.dt[.N, cum.data]-data.dt[first_seg_end, cum.data]
  }]
  possible.dt[, cum.square.after := {
    data.dt[.N, cum.square]-
      data.dt[first_seg_end, cum.square]
  }]
  possible.dt[, N.data.after := nrow(data.dt)-first_seg_end]
  possible.dt[, second_seg_loss := {
    loss(cum.data.after, cum.square.after, N.data.after)
  }]
  possible.dt[, total_loss := {
    first_seg_loss + second_seg_loss
  }]
  total.loss.list <- list()
  total.loss.list[1] <- sum(data.dt$logratio^2)-sum(data.dt$logratio)^2/nrow(data.dt)
  total.loss.list[2] <- possible.dt[order(total_loss)]$total_loss[1]
  
  new.segs <- possible.dt[which.min(total_loss), rbind(
    data.table::data.table(start=1, end=first_seg_end),
    data.table::data.table(start=first_seg_end+1, end=nrow(data.dt)))]
  
  all.no.split.loss <- list()
  all.no.split.loss[1] <- 0
  split.ends <- list()
  split.ends[1] <-1
  split.ends[2] <- possible.dt[which.min(total_loss)]$first_seg_end
  split.ends[3] <- nrow(data.dt)
  all.new.possible.list <- list()
  for(K in seq(2,Kmax-1)){
    for(seg.i in 1:nrow(new.segs)){
      one.seg <- new.segs[seg.i]
      one.seg$start <- unlist(one.seg$start)
      one.seg$end <- unlist(one.seg$end)
      new.possible.dt <- one.seg[, data.table::data.table(
        first_seg_end=seq(start, end-1))]
      if(K == 2){
        if(seg.i==1){
          new.possible.dt[, no_split_loss := possible.dt[which.min(total_loss)]$first_seg_loss]
        }
        else {
          new.possible.dt[, no_split_loss := possible.dt[which.min(total_loss)]$second_seg_loss]
        }
      } else {
        if(seg.i==1){
          new.possible.dt[, no_split_loss := previous.no.split.loss.before]
          
        }else{
          new.possible.dt[, no_split_loss := previous.no.split.loss.after]
        }
      }
      
      new.possible.dt[, first_cumsum :=cumsum(data.dt$logratio[first_seg_end])]
      new.possible.dt[, first_cumsquare :=cumsum(data.dt$logratio[first_seg_end]^2)]
      new.possible.dt[, first_Ndata := first_seg_end-one.seg$start+1]
      new.possible.dt[, first_seg_loss := loss(first_cumsum,first_cumsquare,first_Ndata)]
      new.possible.dt[, second_cumsum := first_cumsum[one.seg$end-one.seg$start]-
                        first_cumsum+data.dt$logratio[one.seg$end]]
      new.possible.dt[, second_cumsquare :=first_cumsquare[one.seg$end-one.seg$start]-
                        first_cumsquare+data.dt$logratio[one.seg$end]^2]
      new.possible.dt[, second_Ndata := one.seg$end-first_seg_end]
      new.possible.dt[, second_seg_loss := loss(second_cumsum,second_cumsquare,second_Ndata)]
      new.possible.dt[, split_loss := {
        first_seg_loss+second_seg_loss
      }]
      
      new.possible.dt[, loss_decrease := no_split_loss-split_loss]
      all.new.possible.list[[seg.i]] <- new.possible.dt
    }
    
    all.new.possible.dt <- do.call(rbind,all.new.possible.list)
    if(K!=2){
      all.new.possible.dt <- rbind(all.new.possible.dt,all.new.possible.dt.old)
    }
    max.decrease <- all.new.possible.dt[which.max(loss_decrease)]$first_seg_end
    split.before <- split.ends[max(which(split.ends < max.decrease))]
    split.after <- split.ends[min(which(split.ends > max.decrease))]
    all.new.possible.dt.old.before <- all.new.possible.dt[first_seg_end < split.before]
    all.new.possible.dt.old.after <- all.new.possible.dt[first_seg_end > split.after]
    all.new.possible.dt.old <- rbind(all.new.possible.dt.old.before,all.new.possible.dt.old.after)
    if (max.decrease %in% seq(unlist(new.segs$start)[1],unlist(new.segs$end)[1])){
      if(K!=2){
        all.no.split.loss[K]=previous.no.split.loss.after
      } else {
        all.no.split.loss[K]=possible.dt[which.min(total_loss)]$second_seg_loss
      }
    } else {
      if(K!=2){
        all.no.split.loss[K]=previous.no.split.loss.before
      } else {
        all.no.split.loss[K]=possible.dt[which.min(total_loss)]$first_seg_loss
      }
    }
    new.segs <- rbind(data.table::data.table(start = split.before, end = max.decrease),
                      data.table::data.table(start=max.decrease+1, end = split.after))
    total.loss.two.seg <- all.new.possible.dt[which.max(loss_decrease)]$split_loss
    previous.no.split.loss.before <- all.new.possible.dt[which.max(loss_decrease)]$first_seg_loss
    previous.no.split.loss.after <- all.new.possible.dt[which.max(loss_decrease)]$second_seg_loss
    split.ends[K+1] <- all.new.possible.dt[which.max(loss_decrease)]$first_seg_end
    split.ends[K+2] <- nrow(data.dt)
    split.ends <- split.ends[order(unlist(split.ends))]
    total.loss.list[K+1] <- total.loss.two.seg +sum(unlist(all.no.split.loss))
  }
  return <- unlist(total.loss.list)
}
