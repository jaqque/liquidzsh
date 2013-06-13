# Set a color depending on the branch state:
# - green if the repository is up to date
# - yellow if there is some commits not pushed
# - red if there is changes to commit
#
# Add the number of pending commits and the impacted lines.
_lp_git_branch_color()
{
    [[ "$LP_ENABLE_GIT" != 1 ]] && return

    local branch
    branch=$(_lp_git_branch)
    if [[ -n "$branch" ]] ; then

        local GD
        git diff --quiet >/dev/null 2>&1
        GD=$?

        local GDC
        git diff --cached --quiet >/dev/null 2>&1
        GDC=$?

        local end="$NO_COL"
        if git status 2>/dev/null | grep -q '\(# Untracked\)'; then
            end="$LP_COLOR_CHANGES$LP_MARK_UNTRACKED$end"
        fi

        if [[ -n "$(git stash list 2>/dev/null)" ]]; then
            end="$LP_COLOR_COMMITS$LP_MARK_STASH$end"
        fi

        local remote
        remote="$(git config --get branch.${branch}.remote 2>/dev/null)"

        local has_commit
        has_commit=0
        if [[ -n "$remote" ]] ; then
            local remote_branch
            remote_branch="$(git config --get branch.${branch}.merge)"
            if [[ -n "$remote_branch" ]] ; then
                has_commit=$(git rev-list --no-merges --count ${remote_branch/refs\/heads/refs\/remotes\/$remote}..HEAD 2>/dev/null)
                if [[ -z "$has_commit" ]] ; then
                    has_commit=0
                fi
            fi
        fi
        if [[ "$GD" -eq 1 || "$GDC" -eq "1" ]] ; then
            local has_line
            has_lines=$(git diff --numstat 2>/dev/null | awk 'NF==3 {plus+=$1; minus+=$2} END {printf("+%d/-%d\n", plus, minus)}')
            if [[ "$has_commit" -gt "0" ]] ; then
                # Changes to commit and commits to push
                ret="${LP_COLOR_CHANGES}${branch}${NO_COL}(${LP_COLOR_DIFF}$has_lines${NO_COL},${LP_COLOR_COMMITS}$has_commit${NO_COL})${end}"
            else
                ret="${LP_COLOR_CHANGES}${branch}${NO_COL}(${LP_COLOR_DIFF}$has_lines${NO_COL})${end}" # changes to commit
            fi
        else
            if [[ "$has_commit" -gt "0" ]] ; then
                # some commit(s) to push
                ret="${LP_COLOR_COMMITS}${branch}${NO_COL}(${LP_COLOR_COMMITS}$has_commit${NO_COL})${end}"
            else
                ret="${LP_COLOR_UP}${branch}${end}" # nothing to commit or push
            fi
        fi
        echo -ne "$ret"
    fi
}

