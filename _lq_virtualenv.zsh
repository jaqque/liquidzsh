# Display the current Python virtual environnement, if available.
_lq_virtualenv()
{
    [[ "$LP_ENABLE_VIRTUALENV" != 1 ]] && return
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "[${LP_COLOR_VIRTUALENV}$(basename $VIRTUAL_ENV)${NO_COL}]"
    fi
}

