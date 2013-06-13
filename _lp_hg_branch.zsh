# Get the branch name of the current directory
_lp_hg_branch()
{
    [[ "$LP_ENABLE_HG" != 1 ]] && return
    local branch
    branch="$(hg branch 2>/dev/null)"
    [[ $? -eq 0 ]] && echo $(_lp_escape "$branch")

}

