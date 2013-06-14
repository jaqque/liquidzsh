_lq_title()
{
    [[ "$LQ_ENABLE_TITLE" != "1" ]] && return

    # Get the current computed prompt as pure text
    local txt=$(_lq_as_text "$1")

    # Use it in the window's title
    # Escapes tell zsh to ignore the non-printing control characters when calculating the width of the prompt.
    # Otherwise line editing commands will mess the cursor positionning
    case "$TERM" in
      screen*)
        [[ "$LQ_ENABLE_SCREEN_TITLE" != "1" ]] && return
        local title="${LQ_SCREEN_TITLE_OPEN}${txt}${LQ_SCREEN_TITLE_CLOSE}"
      ;;
      linux*)
        local title=""
      ;;
      *)
        local title="${_LQ_OPEN_ESC}${LQ_TITLE_OPEN}${txt}${LQ_TITLE_CLOSE}${_LQ_CLOSE_ESC}"
      ;;
    esac
    echo -n "${title}"
}

