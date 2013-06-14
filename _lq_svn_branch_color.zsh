# Set a color depending on the branch state:
# - green if the repository is clean
#   (use $LP_SVN_STATUS_OPTS to define what that means with
#    the --depth option of 'svn status')
# - red if there is changes to commit
# Note that, due to subversion way of managing changes,
# informations are only displayed for the CURRENT directory.
_lq_svn_branch_color()
{
    [[ "$LP_ENABLE_SVN" != 1 ]] && return

    local branch
    branch="$(_lq_svn_branch)"
    if [[ -n "$branch" ]] ; then
        local commits
        changes=$(( $(svn status $LP_SVN_STATUS_OPTIONS | grep -c -v "?") ))
        if [[ $changes -eq 0 ]] ; then
            echo "${LP_COLOR_UP}${branch}${NO_COL}"
        else
            echo "${LP_COLOR_CHANGES}${branch}${NO_COL}(${LP_COLOR_DIFF}$changes${NO_COL})" # changes to commit
        fi
    fi
}

