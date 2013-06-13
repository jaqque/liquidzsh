_lp_temperature() {
    # Will display the numeric value as we got it through the _lp_temp_function
    # and colorize it through _lp_color_map.
    [[ "$LP_ENABLE_TEMP" != 1 ]] && return

    temperature=$($_lp_temp_function)
    if [[ $temperature -ge $LP_TEMP_THRESHOLD ]]; then
        echo -ne "${LP_MARK_TEMP}$(_lp_color_map $temperature)$temperature°${NO_COL}"
    fi
}

