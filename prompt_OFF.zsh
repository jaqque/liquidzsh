# Use an empty prompt: just the \$ mark
prompt_OFF()
{
    PS1="\$ "
    if $_LP_SHELL_bash; then
        PROMPT_COMMAND=$LP_OLD_PROMPT_COMMAND
    else # zsh
        precmd=$LP_OLD_PROMPT_COMMAND
    fi
}

