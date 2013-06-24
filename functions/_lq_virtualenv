# Display the current Python virtual environnement, if available.
_lq_virtualenv()
{
    [[ "$LQ_ENABLE_VIRTUALENV" != 1 ]] && return
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "[${LQ_COLOR_VIRTUALENV}$(basename $VIRTUAL_ENV)${LQ_RESET}]"
    fi
}

