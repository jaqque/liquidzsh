_lq_cpu_load () {
    local bol load eol
    read bol load eol < $<( LANG=C sysctl -n vm.loadavg )
    echo "$load"
}
