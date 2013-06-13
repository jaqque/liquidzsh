# Get the branch name of the current directory
_lp_git_branch()
{
    [[ "$LP_ENABLE_GIT" != 1 ]] && return
    local gitdir
    gitdir="$([ $(git ls-files . 2>/dev/null | wc -l) -gt 0 ] && git rev-parse --git-dir 2>/dev/null)"
    [[ $? -ne 0 || ! $gitdir =~ (.*\/)?\.git.* ]] && return
    local branch="$(git symbolic-ref HEAD 2>/dev/null)"
    if [[ $? -ne 0 || -z "$branch" ]] ; then
        # In detached head state, use commit instead
        branch="$(git rev-parse --short HEAD 2>/dev/null)"
    fi
    [[ $? -ne 0 || -z "$branch" ]] && return
    branch="${branch#refs/heads/}"
    echo $(_lp_escape "$branch")
}

