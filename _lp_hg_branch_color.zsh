# Set a color depending on the branch state:
# - green if the repository is up to date
# - red if there is changes to commit
# - TODO: yellow if there is some commits not pushed
_lp_hg_branch_color()
{
    [[ "$LP_ENABLE_HG" != 1 ]] && return

    local branch
    local ret
    branch=$(_lp_hg_branch)
    if [[ -n "$branch" ]] ; then

        local has_untracked
        has_untracked=$(hg status 2>/dev/null | grep '\(^\?\)' | wc -l)
        if [[ -z "$has_untracked" ]] ; then
            has_untracked=""
        else
            has_untracked="$LP_COLOR_CHANGES$LP_MARK_UNTRACKED"
        fi

        local has_commit
        has_commit=$(hg outgoing --no-merges ${branch} 2>/dev/null | grep '\(^changeset\:\)' | wc -l)
        if [[ -z "$has_commit" ]] ; then
            has_commit=0
        fi

        if [[ $(( $(hg status --quiet -n | wc -l) )) = 0 ]] ; then
            if [[ "$has_commit" -gt "0" ]] ; then
                # some commit(s) to push
                ret="${LP_COLOR_COMMITS}${branch}${NO_COL}(${LP_COLOR_COMMITS}$has_commit${NO_COL})${has_untracked}${NO_COL}"
            else
                ret="${LP_COLOR_UP}${branch}${has_untracked}${NO_COL}" # nothing to commit or push
            fi
        else
            local has_line
            has_lines=$(hg diff --stat 2>/dev/null | tail -n 1 | awk 'FS=" " {printf("+%s/-%s\n", $4, $6)}')
            if [[ "$has_commit" -gt "0" ]] ; then
                # Changes to commit and commits to push
                ret="${LP_COLOR_CHANGES}${branch}${NO_COL}(${LP_COLOR_DIFF}$has_lines${NO_COL},${LP_COLOR_COMMITS}$has_commit${NO_COL})${has_untracked}${NO_COL}"
            else
                ret="${LP_COLOR_CHANGES}${branch}${NO_COL}(${LP_COLOR_DIFF}$has_lines${NO_COL})${has_untracked}${NO_COL}" # changes to commit
            fi
        fi
        echo -ne "$ret"
    fi
}

