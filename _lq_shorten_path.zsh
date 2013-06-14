# BASH/ZSH function that shortens
# a very long path for display by removing
# the left most parts and replacing them
# with a leading ...
#
# the first argument is the path
#
# the second argument is the maximum allowed
# length including the '/'s and ...
# http://hbfs.wordpress.com/2009/09/01/short-pwd-in-bash-prompts/
#
# + keep some left part of the path if asked
_lq_shorten_path()
{
    if [[ "$LQ_ENABLE_SHORTEN_PATH" != 1 || -n "$PROMPT_DIRTRIM" ]] ; then
        if $_LQ_SHELL_bash; then
            echo "\\w"
        else
            print -P '%~'
        fi
        return
    fi

    local p="${PWD/#$HOME/~}"
    local -i len=${#p}
    local -i max_len=$((${COLUMNS:-80}*$LQ_PATH_LENGTH/100))

    if (( len > max_len )); then
        print -P "%-${LQ_PATH_KEEP}~%${max_len}<${LQ_MARK_SHORTEN_PATH}<%~%<<"
    else
        print -P '%~'
    fi
}

