# Use an empty prompt: just the \$ mark
prompt_default()
{
    PS1="\$ "
    if $_LQ_SHELL_bash; then
        PROMPT_COMMAND=$LQ_OLD_PROMPT_COMMAND
    else # zsh
        precmd=$LQ_OLD_PROMPT_COMMAND
    fi
}

