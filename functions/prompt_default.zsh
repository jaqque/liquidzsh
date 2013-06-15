# Use an empty prompt: just the \$ mark
prompt_default()
{
    PS1="%m%# "
    precmd=$LQ_OLD_PROMPT_COMMAND
}

