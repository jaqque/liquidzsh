# Get the branch name of the current directory
_lp_bzr_branch()
{
    [[ "$LP_ENABLE_BZR" != 1 ]] && return
    local branch
    branch=$(bzr nick 2> /dev/null)
    [[ $? -ne 0 ]] && return
    echo $(_lp_escape "$branch")
}

