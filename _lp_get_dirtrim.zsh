# In bash shell, PROMPT_DIRTRIM is the number of directory to keep at the end
# of the displayed path (if "\w" is present in the PS1 var).
# liquidprompt can calculate this number under two condition, path shortening
# must be activated and PROMPT_DIRTRIM must be already set.
_lp_get_dirtrim() {
    [[ "$LP_ENABLE_SHORTEN_PATH" != 1 ]] && echo 0 && return

    local p="${PWD/$HOME/~}"
    local len=${#p}
    local max_len=$((${COLUMNS:-80}*$LP_PATH_LENGTH/100))
    local PROMPT_DIRTRIM=0

    if [[ "$((len))" -gt "$((max_len))" ]]; then
        local i

        for ((i=$len;i>=0;i--))
        do
            [[ $(($len-$i)) -gt $max_len ]] && break
            [[ "${p:i:1}" == "/" ]] && PROMPT_DIRTRIM=$((PROMPT_DIRTRIM+1))
        done
        [[ "$((PROMPT_DIRTRIM))" -eq 0 ]] && PROMPT_DIRTRIM=1
    fi
    echo "$PROMPT_DIRTRIM"
}

