# Come back to the old prompt
prompt_off()
{
    PS1=$LQ_OLD_PS1
    if $_LQ_SHELL_bash; then
        PROMPT_COMMAND=$LQ_OLD_PROMPT_COMMAND
    else # zsh
        precmd=$LQ_OLD_PROMPT_COMMAND
    fi
}

