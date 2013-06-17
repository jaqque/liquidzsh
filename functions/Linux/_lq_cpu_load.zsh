_lq_cpu_load () {
    local load eol
    read load eol < /proc/loadavg
    echo "$load"
}

