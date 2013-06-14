_lq_title()
{
    [[ "$LP_ENABLE_TITLE" != "1" ]] && return

    # Get the current computed prompt as pure text
    local txt=$(_lq_as_text "$1")

    # Use it in the window's title
    # Escapes whill tells bash to ignore the non-printing control characters when calculating the width of the prompt.
    # Otherwise line editing commands will mess the cursor positionning
    case "$TERM" in
      screen*)
        [[ "$LP_ENABLE_SCREEN_TITLE" != "1" ]] && return
        local title="${LP_SCREEN_TITLE_OPEN}${txt}${LP_SCREEN_TITLE_CLOSE}"
      ;;
      linux*)
        local title=""
      ;;
      *)
        local title="${_LP_OPEN_ESC}${LP_TITLE_OPEN}${txt}${LP_TITLE_CLOSE}${_LP_CLOSE_ESC}"
      ;;
    esac
    echo -n "${title}"
}

