# Come back to the old prompt
prompt_off()
{
    PS1=$LP_OLD_PS1
    if $_LP_SHELL_bash; then
        PROMPT_COMMAND=$LP_OLD_PROMPT_COMMAND
    else # zsh
        precmd=$LP_OLD_PROMPT_COMMAND
    fi
}

