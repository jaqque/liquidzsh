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
_lp_shorten_path()
{
    if [[ "$LP_ENABLE_SHORTEN_PATH" != 1 || -n "$PROMPT_DIRTRIM" ]] ; then
        if $_LP_SHELL_bash; then
            echo "\\w"
        else
            print -P '%~'
        fi
        return
    fi

    local p="${PWD/#$HOME/~}"
    local -i len=${#p}
    local -i max_len=$((${COLUMNS:-80}*$LP_PATH_LENGTH/100))

    if $_LP_SHELL_bash; then
        if (( len > max_len ))
        then
            # index of the directory to keep from the root
            # (starts at 0 whith bash, 1 with zsh)
            local -i keep=LP_PATH_KEEP-1
            # the character that will replace the part of the path that is
            # masked
            local mask="$LP_MARK_SHORTEN_PATH"
            local -i mask_len=${#mask}
            # finds all the '/' in
            # the path and stores their
            # positions
            #
            local pos=()
            local -i slashes=0
            for ((i=0;i<len;i++))
            do
                if [[ "${p:i:1}" == / ]]
                then
                    pos=(${pos[@]} $i)
                    let slashes++
                fi
            done
            pos=(${pos[@]} $len)

            # we have the '/'s, let's find the
            # left-most that doesn't break the
            # length limit
            #
            local -i i=keep
            if (( keep > slashes )) ; then
                i=slashes
            fi
            while (( len-pos[i] > max_len-mask_len ))
            do
                let i++
            done

            # let us check if it's OK to
            # print the whole thing
            #
            if (( pos[i] == 0 ))
            then
                # the path is shorter than
                # the maximum allowed length,
                # so no need for '…'
                #
                echo "$p"

            elif (( pos[i] == len ))
            then
                # constraints are broken because
                # the maximum allowed size is smaller
                # than the last part of the path, plus
                # ' … '
                #
                echo "${p:0:pos[keep]+1}${mask}${p:len-max_len+mask_len}"
            else
                # constraints are satisfied, at least
                # some parts of the path, plus ' … ', are
                # shorter than the maximum allowed size
                #
                echo "${p:0:pos[keep]+1}${mask}${p:pos[i]}"
            fi
        else
            echo "$p"
        fi
    else # zsh
        if (( len > max_len )); then
            print -P "%-${LP_PATH_KEEP}~%${max_len}<${LP_MARK_SHORTEN_PATH}<%~%<<"
        else
            print -P '%~'
        fi
    fi
}

