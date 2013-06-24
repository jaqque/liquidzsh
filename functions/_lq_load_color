# Compute a gradient of background/forground colors depending on the battery status
_lq_load_color()
{
    # Colour progression is important ...
    #   bold gray -> bold green -> bold yellow -> bold red ->
    #   black on red -> bold white on red
    #
    # Then we have to choose the values at which the colours switch, with
    # anything past yellow being pretty important.

    [[ "$LQ_ENABLE_LOAD" != 1 ]] && return

    local load
    load="$(_lq_cpu_load | sed 's/\.//g;s/^0*//g' )"
    let "load=${load:-0}/$_lq_CPUNUM"

    if [[ $load -ge $LQ_LOAD_THRESHOLD ]]
    then
        local ret="$(_lq_heatmap $((load/20)))${LQ_MARK_LOAD}"

        if [[ "$LQ_PERCENTS_ALWAYS" -eq "1" ]]; then
            ret="${ret}$load%%"
        fi
        echo -ne "${ret}${LQ_RESET}"
    fi
}

