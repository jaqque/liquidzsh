# Activate the liquid prompt
prompt_on()
{
    # if liquidprompt has not been already set
    if [[ -z "$LP_LIQUIDPROMPT" ]] ; then
        LP_OLD_PS1="$PS1"
        if $_LP_SHELL_bash; then
            LP_OLD_PROMPT_COMMAND="$PROMPT_COMMAND"
        else # zsh
            LP_OLD_PROMPT_COMMAND="$precmd"
        fi
    fi
    if $_LP_SHELL_bash; then
        PROMPT_COMMAND=_lq_set_prompt
    else # zsh
        function precmd {
            _lq_set_prompt
        }
    fi

    # Keep in mind that LP has been sourced
    # (to avoid recursive prompt command).
    LP_LIQUIDPROMPT=1
}

