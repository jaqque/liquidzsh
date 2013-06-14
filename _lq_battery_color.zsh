# Compute a gradient of background/foreground colors depending on the battery status
# Display:
# a  green ⏚ if the battery is charging    and above threshold
# a yellow ⏚ if the battery is charging    and under threshold
# a yellow ⌁ if the battery is discharging but above threshold
# a    red ⌁ if the battery is discharging and above threshold
_lq_battery_color()
{
    [[ "$LQ_ENABLE_BATT" != 1 ]] && return

    local mark=$LQ_MARK_BATTERY
    local chargingmark=$LQ_MARK_ADAPTER
    local bat
    local ret
    bat=$(_lq_battery)
    ret=$?

    if [[ $ret == 4 || $bat == 100 ]] ; then
        # no battery support or battery full: nothing displayed
        return
    elif [[ $ret == 3 && $bat != 100 ]] ; then
        # charging and above threshold and not 100%
        # green ⏚
        echo -ne "${LQ_COLOR_CHARGING_ABOVE}$chargingmark${LQ_RESET}"
        return
    elif [[ $ret == 2 ]] ; then
        # charging but under threshold
        # yellow ⏚
        echo -ne "${LQ_COLOR_CHARGING_UNDER}$chargingmark${LQ_RESET}"
        return
    elif [[ $ret == 1 ]] ; then
        # discharging but above threshold
        # yellow ⌁
        echo -ne "${LQ_COLOR_DISCHARGING_ABOVE}$mark${LQ_RESET}"
        return

    # discharging and under threshold
    elif [[ "$bat" != "" ]] ; then
        ret="${LQ_COLOR_DISCHARGING_UNDER}${mark}${LQ_RESET}"

        if [[ "$LQ_PERCENTS_ALWAYS" -eq "1" ]]; then
            if   [[ ${bat} -le 100 ]] && [[ ${bat} -gt 80 ]] ; then # -20
                ret="${ret}${LQ_COLORMAP_1}"
            elif [[ ${bat} -le 80  ]] && [[ ${bat} -gt 65 ]] ; then # -15
                ret="${ret}${LQ_COLORMAP_2}"
            elif [[ ${bat} -le 65  ]] && [[ ${bat} -gt 50 ]] ; then # -15
                ret="${ret}${LQ_COLORMAP_3}"
            elif [[ ${bat} -le 50  ]] && [[ ${bat} -gt 40 ]] ; then # -10
                ret="${ret}${LQ_COLORMAP_4}"
            elif [[ ${bat} -le 40  ]] && [[ ${bat} -gt 30 ]] ; then # …
                ret="${ret}${LQ_COLORMAP_5}"
            elif [[ ${bat} -le 30  ]] && [[ ${bat} -gt 20 ]] ; then
                ret="${ret}${LQ_COLORMAP_6}"
            elif [[ ${bat} -le 20  ]] && [[ ${bat} -gt 10 ]] ; then
                ret="${ret}${LQ_COLORMAP_7}"
            elif [[ ${bat} -le 10  ]] && [[ ${bat} -gt 5  ]] ; then
                ret="${ret}${LQ_COLORMAP_8}"
            elif [[ ${bat} -le 5   ]] && [[ ${bat} -gt 0  ]] ; then
                ret="${ret}${LQ_COLORMAP_9}"
            else
                # for debugging purpose
                ret="${ret}${LQ_COLORMAP_0}"
            fi

            ret="${ret}${bat}%%"
        fi # LQ_PERCENTS_ALWAYS
        echo -ne "${ret}${LQ_RESET}"
    fi # ret
}

