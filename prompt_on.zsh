# Activate the liquid prompt
prompt_on()
{
    # if liquidprompt has not been already set
    if [[ -z "$LQ_LOADED" ]] ; then
        LQ_OLD_PS1="$PS1"
        LQ_OLD_PROMPT_COMMAND="$precmd"
    fi
    function precmd {
        _lq_set_prompt
    }

    # Keep in mind that Liquid has been sourced
    # (to avoid recursive prompt command).
    LQ_LOADED=1
}

