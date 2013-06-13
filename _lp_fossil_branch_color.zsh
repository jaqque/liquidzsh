# Set a color depending on the branch state:
# - green if the repository is clean
# - red if there is changes to commit
# - yellow if the branch has no tag name
#
# Add the number of impacted files with a
# + when files are ADDED or EDITED
# - when files are DELETED
_lp_fossil_branch_color()
{
    [[ "$LP_ENABLE_FOSSIL" != 1 ]] && return

    local branch
    branch=$(_lp_fossil_branch)

    if [[ -n "$branch" ]] ; then
        local C2E # Modified files (added or edited)
        local C2D # Deleted files
        local C2A # Extras files
        local ret
        C2E=$(fossil changes | wc -l)
        C2D=$(fossil changes | grep DELETED | wc -l)
        let "C2E = $C2E - $C2D"
        C2A=$(fossil extras | wc -l)
        ret=""

        if [[ "$C2E" -gt 0 ]] ; then
            ret+="+$C2E"
        fi

        if [[ "$C2D" -gt 0 ]] ; then
            if [[ "$ret" = "" ]] ; then
                ret+="-$C2D"
            else
                ret+="/-$C2D"
            fi
        fi

        if [[ "$C2A" -gt 0 ]] ; then
            C2A="$LP_MARK_UNTRACKED"
        else
            C2A=""
        fi

        if [[ "$ret" != "" ]] ; then
            ret="(${LP_COLOR_DIFF}$ret${NO_COL})"
        fi


        if [[ "$branch" = "no-tag" ]] ; then
            # Warning, your branch has no tag name !
            branch="${LP_COLOR_COMMITS}$branch${NO_COL}$ret${LP_COLOR_COMMITS}$C2A${NO_COL}"
        else
            if [[ "$C2E" -eq 0 && "$C2D" -eq 0 ]] ; then
                # All is up-to-date
                branch="${LP_COLOR_UP}$branch$C2A${NO_COL}"
            else
                # There're some changes to commit
                branch="${LP_COLOR_CHANGES}$branch${NO_COL}$ret${LP_COLOR_CHANGES}$C2A${NO_COL}"
            fi
        fi
        echo -ne $branch # $(_lp_escape "$branch")
    fi
}

