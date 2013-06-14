# Set a color depending on the branch state:
# - green if the repository is up to date
# - red if there is changes to commit
# - TODO: yellow if there is some commits not pushed
_lq_hg_branch_color()
{
    [[ "$LQ_ENABLE_HG" != 1 ]] && return

    local branch
    local ret
    branch=$(_lq_hg_branch)
    if [[ -n "$branch" ]] ; then

        local has_untracked
        has_untracked=$(hg status 2>/dev/null | grep '\(^\?\)' | wc -l)
        if [[ -z "$has_untracked" ]] ; then
            has_untracked=""
        else
            has_untracked="$LQ_COLOR_CHANGES$LQ_MARK_UNTRACKED"
        fi

        local has_commit
        has_commit=$(hg outgoing --no-merges ${branch} 2>/dev/null | grep '\(^changeset\:\)' | wc -l)
        if [[ -z "$has_commit" ]] ; then
            has_commit=0
        fi

        if [[ $(( $(hg status --quiet -n | wc -l) )) = 0 ]] ; then
            if [[ "$has_commit" -gt "0" ]] ; then
                # some commit(s) to push
                ret="${LQ_COLOR_COMMITS}${branch}${LQ_RESET}(${LQ_COLOR_COMMITS}$has_commit${LQ_RESET})${has_untracked}${LQ_RESET}"
            else
                ret="${LQ_COLOR_UP}${branch}${has_untracked}${LQ_RESET}" # nothing to commit or push
            fi
        else
            local has_line
            has_lines=$(hg diff --stat 2>/dev/null | tail -n 1 | awk 'FS=" " {printf("+%s/-%s\n", $4, $6)}')
            if [[ "$has_commit" -gt "0" ]] ; then
                # Changes to commit and commits to push
                ret="${LQ_COLOR_CHANGES}${branch}${LQ_RESET}(${LQ_COLOR_DIFF}$has_lines${LQ_RESET},${LQ_COLOR_COMMITS}$has_commit${LQ_RESET})${has_untracked}${LQ_RESET}"
            else
                ret="${LQ_COLOR_CHANGES}${branch}${LQ_RESET}(${LQ_COLOR_DIFF}$has_lines${LQ_RESET})${has_untracked}${LQ_RESET}" # changes to commit
            fi
        fi
        echo -ne "$ret"
    fi
}

