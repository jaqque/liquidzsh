_lq_cpu_load () {
    local load
    load=$(LANG=C sysctl -n vm.loadavg | awk '{print $2}')
    echo "$load"
}

