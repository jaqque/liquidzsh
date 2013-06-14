# Set a color depending on the branch state:
# - green if the repository is up to date
# - red if there is changes to commit
# - TODO: yellow if there is some commits not pushed
#
# Add the number of pending commits and the impacted lines.
_lq_bzr_branch_color()
{
    [[ "$LQ_ENABLE_BZR" != 1 ]] && return
    local output
    output=$(bzr version-info --check-clean --custom --template='{branch_nick} {revno} {clean}' 2> /dev/null)
    [[ $? -ne 0 ]] && return
    local tuple=($output)
    local branch=${tuple[0]}
    local revno=${tuple[1]}
    local clean=${tuple[2]}

    if [[ -n "$branch" ]] ; then
        if [[ "$clean" -eq 0 ]] ; then
            ret="${LQ_COLOR_CHANGES}${branch}${NO_COL}(${LQ_COLOR_COMMITS}$revno${NO_COL})"
        else
            ret="${LQ_COLOR_UP}${branch}${NO_COL}(${LQ_COLOR_COMMITS}$revno${NO_COL})"
        fi

    fi
    echo -ne "$ret"
}

