_lp_connection()
{
    if [[ -n "$SSH_CLIENT$SSH2_CLIENT$SSH_TTY" ]] ; then
        echo ssh
    else
        # TODO check on *BSD
        local sess_src=$(who am i | sed -n 's/.*(\(.*\))/\1/p')
        local sess_parent=$(ps -o comm= -p $PPID 2> /dev/null)
        if [[ -z "$sess_src" || "$sess_src" = ":"* ]] ; then
            echo lcl  # Local
        elif [[ "$sess_parent" = "su" || "$sess_parent" = "sudo" ]] ; then
            echo su   # Remote su/sudo
        else
            echo tel  # Telnet
        fi
    fi
}
