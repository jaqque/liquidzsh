# Activate the liquid prompt
prompt_on()
{
    # if liquidprompt has not been already set
    if [[ -z "$LQ_LIQUIDPROMPT" ]] ; then
        LQ_OLD_PS1="$PS1"
        if $_LQ_SHELL_bash; then
            LQ_OLD_PROMPT_COMMAND="$PROMPT_COMMAND"
        else # zsh
            LQ_OLD_PROMPT_COMMAND="$precmd"
        fi
    fi
    if $_LQ_SHELL_bash; then
        PROMPT_COMMAND=_lq_set_prompt
    else # zsh
        function precmd {
            _lq_set_prompt
        }
    fi

    # Keep in mind that LP has been sourced
    # (to avoid recursive prompt command).
    LQ_LIQUIDPROMPT=1
}

