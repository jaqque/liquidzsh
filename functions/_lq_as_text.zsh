# Remove all colors and escape characters of the given string and return a pure text
_lq_as_text()
{
    # Remove colors from the computed prompt
    case "$LQ_OS" in
        Linux|FreeBSD|SunOS)  local pst=$(echo $1 | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g") ;;
        Darwin) local pst=$(echo $1 | sed -E "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g") ;;
    esac


    # Remove escape sequences
    # FIXME check the zsh compatibility
    # pst=$(echo $pst | sed "s,\\\\\\[\|\\\\\\],,g")
    local op=$(printf "%q" "$_LQ_OPEN_ESC")
    local cl=$(printf "%q" "$_LQ_CLOSE_ESC")
    pst=$(echo $pst | sed "s,$op\|$cl,,g") # replace all open _or_ close tags with nothing

    echo -n "$pst"
}

