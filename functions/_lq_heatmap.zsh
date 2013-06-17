_lq_heatmap() {
# It is faster to do the math in the caller
# _lq_heatmap $(( (value - LOWER_BOUND) / ( (UPPER_BOUND - LOWER-BOUND) / 10) ))
# Range of 20 to 80: $(( (value - 20) / 6 ))
    case $1 in
        -*) print -n $LQ_HEATMAP[0] ;;
         0) print -n $LQ_HEATMAP[0] ;;
         1) print -n $LQ_HEATMAP[1] ;;
         2) print -n $LQ_HEATMAP[2] ;;
         3) print -n $LQ_HEATMAP[3] ;;
         4) print -n $LQ_HEATMAP[4] ;;
         5) print -n $LQ_HEATMAP[5] ;;
         6) print -n $LQ_HEATMAP[6] ;;
         7) print -n $LQ_HEATMAP[7] ;;
         8) print -n $LQ_HEATMAP[8] ;;
         *) print -n $LQ_HEATMAP[9] ;;
     esac
}

