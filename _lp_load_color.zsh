# Compute a gradient of background/forground colors depending on the battery status
_lp_load_color()
{
    # Colour progression is important ...
    #   bold gray -> bold green -> bold yellow -> bold red ->
    #   black on red -> bold white on red
    #
    # Then we have to choose the values at which the colours switch, with
    # anything past yellow being pretty important.

    [[ "$LP_ENABLE_LOAD" != 1 ]] && return

    local load
    load="$(_lp_cpu_load | sed 's/\.//g;s/^0*//g' )"
    let "load=${load:-0}/$_lp_CPUNUM"

    if [[ $load -ge $LP_LOAD_THRESHOLD ]]
    then
        local ret="$(_lp_color_map $load) ${LP_MARK_LOAD}"

        if [[ "$LP_PERCENTS_ALWAYS" -eq "1" ]]; then
            if $_LP_SHELL_bash; then
                ret="${ret}$load%"
            else # zsh
                ret="${ret}$load%%"
            fi
        fi
        echo -ne "${ret}${NO_COL}"
    fi
}

