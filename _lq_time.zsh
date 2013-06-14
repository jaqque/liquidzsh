_lq_time()
{
    [[ "$LQ_ENABLE_TIME" != 1 ]] && return
    if [[ "$LQ_TIME_ANALOG" != 1 ]]; then
        echo -n "${LQ_COLOR_TIME}${_LQ_TIME_SYMBOL}${NO_COL}"
    else
        echo -n "${LQ_COLOR_TIME}"
        _lq_time_analog
        echo -n "${NO_COL}"
    fi
}

