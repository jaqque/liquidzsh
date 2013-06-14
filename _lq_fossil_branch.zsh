# Get the tag name of the current directory
_lq_fossil_branch()
{
    [[ "$LP_ENABLE_FOSSIL" != 1 ]] && return
    local branch
    branch=$(fossil status 2>/dev/null | grep tags: | cut -c17-)
    if [[ -n "$branch" ]] ; then
        echo $(_lq_escape "$branch")
    else
        if fossil info &>/dev/null ; then
            echo "no-tag"
        fi
    fi
}

