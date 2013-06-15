_lq_temperature() {
    # Will display the numeric value as we got it through the _lq_temp_function
    # and colorize it through _lq_color_map.
    [[ "$LQ_ENABLE_TEMP" != 1 ]] && return

    temperature=$($_lq_temp_function)
    if [[ $temperature -ge $LQ_TEMP_THRESHOLD ]]; then
        echo -ne "${LQ_MARK_TEMP}$(_lq_color_map $temperature)$temperature°${LQ_RESET}"
    fi
}

