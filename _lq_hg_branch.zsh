# Get the branch name of the current directory
_lq_hg_branch()
{
    [[ "$LQ_ENABLE_HG" != 1 ]] && return
    local branch
    branch="$(hg branch 2>/dev/null)"
    [[ $? -eq 0 ]] && echo $(_lq_escape "$branch")

}

