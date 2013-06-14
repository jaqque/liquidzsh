# Display the count of each if non-zero:
# - detached screens sessions and/or tmux sessions running on the host
# - attached running jobs (started with $ myjob &)
# - attached stopped jobs (suspended with Ctrl-Z)
_lq_jobcount_color()
{
    [[ "$LQ_ENABLE_JOBS" != 1 ]] && return

    local running=$(( $(jobs -r | wc -l) ))
    local stopped=$(( $(jobs -s | wc -l) ))
    local n_screen=$(screen -ls 2> /dev/null | grep -c Detach)
    local n_tmux=$(tmux list-sessions 2> /dev/null | grep -cv attached)
    local detached=$(( $n_screen + $n_tmux ))
    local m_detached="d"
    local m_stop="z"
    local m_run="&"
    local ret=""

    if [[ $detached != "0" ]] ; then
        ret="${ret}${LQ_COLOR_JOB_D}${detached}${m_detached}${NO_COL}"
    fi

    if [[ $running != "0" ]] ; then
        if [[ $ret != "" ]] ; then ret="${ret}/"; fi
        ret="${ret}${LQ_COLOR_JOB_R}${running}${m_run}${NO_COL}"
    fi

    if [[ $stopped != "0" ]] ; then
        if [[ $ret != "" ]] ; then ret="${ret}/"; fi
        ret="${ret}${LQ_COLOR_JOB_Z}${stopped}${m_stop}${NO_COL}"
    fi

    echo -ne "$ret"
}

