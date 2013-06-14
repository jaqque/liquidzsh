_lq_time()
{
    [[ "$LP_ENABLE_TIME" != 1 ]] && return
    if [[ "$LP_TIME_ANALOG" != 1 ]]; then
        echo -n "${LP_COLOR_TIME}${_LP_TIME_SYMBOL}${NO_COL}"
    else
        echo -n "${LP_COLOR_TIME}"
        _lq_time_analog
        echo -n "${NO_COL}"
    fi
}

