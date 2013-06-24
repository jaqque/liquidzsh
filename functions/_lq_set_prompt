_lq_set_prompt()
{
    # as this get the last returned code, it should be called first
    LQ_ERR="$(_lq_sl $(_lq_return_value $?))"

    # Reset IFS to its default value to avoid strange behaviors
    # (in case the user is playing with the value at the prompt)
    local IFS="$(echo -e ' \t')
"       # space, tab, LF

    # left of main prompt: space at right
    LQ_JOBS=$(_lq_sr "$(_lq_jobcount_color)")
    LQ_TEMP=$(_lq_sr "$(_lq_temperature)")
    LQ_LOAD=$(_lq_sr "$(_lq_load_color)")
    LQ_BATT=$(_lq_sr "$(_lq_battery_color)")
    LQ_TIME=$(_lq_sr "$(_lq_time)")

    # in main prompt: no space
    LQ_PROXY="$(_lq_proxy)"

    # right of main prompt: space at left
    LQ_VENV=$(_lq_sl "$(_lq_virtualenv)")
    # if change of working directory
    if [[ "$LQ_OLD_PWD" != "$PWD" ]]; then
        LQ_VCS=""
        LQ_VCS_TYPE=""
        # LQ_HOST is a global set at load time
        LQ_PERM=$(_lq_permissions_color)
        LQ_PWD=$(_lq_shorten_path)
        [[ -n "$PROMPT_DIRTRIM" ]] && PROMPT_DIRTRIM=$(_lq_get_dirtrim)

        if [[ "$(_lq_are_vcs_disabled)" -eq "0" ]] ; then
            LQ_VCS="$(_lq_git_branch_color)"
            LQ_VCS_TYPE="git"
            if [[ -n "$LQ_VCS" ]]; then
                # If this is a git-svn repository
                if [[ -d "$(git rev-parse --git-dir 2>/dev/null)/svn" ]]; then
                    LQ_VCS_TYPE="git-svn"
                fi
            fi # git-svn
            if [[ -z "$LQ_VCS" ]]; then
                LQ_VCS="$(_lq_hg_branch_color)"
                LQ_VCS_TYPE="hg"
                if [[ -z "$LQ_VCS" ]]; then
                    LQ_VCS="$(_lq_svn_branch_color)"
                    LQ_VCS_TYPE="svn"
                    if [[ -z "$LQ_VCS" ]]; then
                        LQ_VCS="$(_lq_fossil_branch_color)"
                        LQ_VCS_TYPE="fossil"
                        if [[ -z "$LQ_VCS" ]]; then
                            LQ_VCS="$(_lq_bzr_branch_color)"
                            LQ_VCS_TYPE="bzr"
                            if [[ -z "$LQ_VCS" ]]; then
                                LQ_VCS=""
                                LQ_VCS_TYPE=""
                            fi # nothing
                        fi # bzr
                    fi # fossil
                fi # svn
            fi # hg

        else # if this vcs rep is disabled
            LQ_VCS="" # not necessary, but more readable
            LQ_VCS_TYPE="disabled"
        fi

        if [[ -z "$LQ_VCS_TYPE" ]] ; then
            LQ_VCS=""
        else
            LQ_VCS=$(_lq_sl "${LQ_VCS}")
        fi

        # end of the prompt line: double spaces
        LQ_MARK=$(_lq_sb "$(_lq_smart_mark $LQ_VCS_TYPE)")

        # Different path color if root
        if [[ "$EUID" -ne "0" ]] ; then
            LQ_PWD="${LQ_COLOR_PATH}${LQ_PWD}${LQ_RESET}"
        else
            LQ_PWD="${LQ_COLOR_PATH_ROOT}${LQ_PWD}${LQ_RESET}"
        fi
        LQ_OLD_PWD="$PWD"

    # if do not change of working directory but...
    elif [[ -n "$LQ_VCS_TYPE" ]]; then # we are still in a VCS dir
        case "$LQ_VCS_TYPE" in
            git)     LQ_VCS=$(_lq_sl "$(_lq_git_branch_color)");;
            git-svn) LQ_VCS=$(_lq_sl "$(_lq_git_branch_color)");;
            hg)      LQ_VCS=$(_lq_sl "$(_lq_hg_branch_color)");;
            svn)     LQ_VCS=$(_lq_sl "$(_lq_svn_branch_color)");;
            fossil)  LQ_VCS=$(_lq_sl "$(_lq_fossil_branch_color)");;
            bzr)     LQ_VCS=$(_lq_sl "$(_lq_bzr_branch_color)");;
            disabled)LQ_VCS="";;
        esac
    fi

    if [[ -f "$LQ_PS1_FILE" ]]; then
        source "$LQ_PS1_FILE"
    fi

    if [[ -z $LQ_PS1 ]] ; then
        # add title escape time, jobs, load and battery
        PS1="${LQ_PS1_PREFIX}${LQ_TIME}${LQ_BATT}${LQ_LOAD}${LQ_TEMP}${LQ_JOBS}"
        # add user, host and permissions colon
        PS1="${PS1}${LQ_BRACKET_OPEN}${LQ_USER}${LQ_HOST}${LQ_PERM}"

        # if not root
        if [[ "$EUID" -ne "0" ]]
        then
            # path in foreground color
            PS1="${PS1}${LQ_PWD}${LQ_BRACKET_CLOSE}${LQ_VENV}${LQ_PROXY}"
            # add VCS infos
            PS1="${PS1}${LQ_VCS}"
        else
            # path in yellow
            PS1="${PS1}${LQ_PWD}${LQ_BRACKET_CLOSE}${LQ_VENV}${LQ_PROXY}"
            # do not add VCS infos unless told otherwise (LQ_ENABLE_VCS_ROOT)
            [[ "$LQ_ENABLE_VCS_ROOT" = "1" ]] && PS1="${PS1}${LQ_VCS}"
        fi
        # add return code and prompt mark
        PS1="${PS1}${LQ_ERR}${LQ_MARK}${LQ_PS1_POSTFIX}"

        # "invisible" parts
        # Get the current prompt on the fly and make it a title
        LQ_TITLE=$(_lq_title "$PS1")

        # Insert it in the prompt
        PS1="${LQ_TITLE}${PS1}"

    else
        PS1=$LQ_PS1
    fi
}

