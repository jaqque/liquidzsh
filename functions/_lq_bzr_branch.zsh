# Get the branch name of the current directory
_lq_bzr_branch()
{
    [[ "$LQ_ENABLE_BZR" != 1 ]] && return
    local branch
    branch=$(bzr nick 2> /dev/null)
    [[ $? -ne 0 ]] && return
    echo $(_lq_escape "$branch")
}

