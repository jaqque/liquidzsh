# put an arrow if an http proxy is set
_lq_proxy()
{
    [[ "$LP_ENABLE_PROXY,$http_proxy" = 1,?* ]] && echo -ne "$LP_COLOR_PROXY$LP_MARK_PROXY$NO_COL"
}

