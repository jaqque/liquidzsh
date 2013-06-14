_lq_set_prompt()
{
    # as this get the last returned code, it should be called first
    LP_ERR="$(_lq_sl $(_lq_return_value $?))"

    # Reset IFS to its default value to avoid strange behaviors
    # (in case the user is playing with the value at the prompt)
    local IFS="$(echo -e ' \t')
"       # space, tab, LF

    # execute the old prompt if not on Mac OS X (Mountain) Lion
    case "$LP_OS" in
        Linux|FreeBSD|SunOS) $LP_OLD_PROMPT_COMMAND ;;
        Darwin)
            case "$(LP_DWIN_KERNEL_REL_VER)" in
                11|12) update_terminal_cwd ;;
                *) $LP_OLD_PROMPT_COMMAND ;;
            esac ;;
    esac

    # left of main prompt: space at right
    LP_JOBS=$(_lq_sr "$(_lq_jobcount_color)")
    LP_TEMP=$(_lq_sr "$(_lq_temperature)")
    LP_LOAD=$(_lq_sr "$(_lq_load_color)")
    LP_BATT=$(_lq_sr "$(_lq_battery_color)")
    LP_TIME=$(_lq_sr "$(_lq_time)")

    # in main prompt: no space
    LP_PROXY="$(_lq_proxy)"

    # right of main prompt: space at left
    LP_VENV=$(_lq_sl "$(_lq_virtualenv)")
    # if change of working directory
    if [[ "$LP_OLD_PWD" != "$PWD" ]]; then
        LP_VCS=""
        LP_VCS_TYPE=""
        # LP_HOST is a global set at load time
        LP_PERM=$(_lq_permissions_color)
        LP_PWD=$(_lq_shorten_path)
        [[ -n "$PROMPT_DIRTRIM" ]] && PROMPT_DIRTRIM=$(_lq_get_dirtrim)

        if [[ "$(_lq_are_vcs_disabled)" -eq "0" ]] ; then
            LP_VCS="$(_lq_git_branch_color)"
            LP_VCS_TYPE="git"
            if [[ -n "$LP_VCS" ]]; then
                # If this is a git-svn repository
                if [[ -d "$(git rev-parse --git-dir 2>/dev/null)/svn" ]]; then
                    LP_VCS_TYPE="git-svn"
                fi
            fi # git-svn
            if [[ -z "$LP_VCS" ]]; then
                LP_VCS="$(_lq_hg_branch_color)"
                LP_VCS_TYPE="hg"
                if [[ -z "$LP_VCS" ]]; then
                    LP_VCS="$(_lq_svn_branch_color)"
                    LP_VCS_TYPE="svn"
                    if [[ -z "$LP_VCS" ]]; then
                        LP_VCS="$(_lq_fossil_branch_color)"
                        LP_VCS_TYPE="fossil"
                        if [[ -z "$LP_VCS" ]]; then
                            LP_VCS="$(_lq_bzr_branch_color)"
                            LP_VCS_TYPE="bzr"
                            if [[ -z "$LP_VCS" ]]; then
                                LP_VCS=""
                                LP_VCS_TYPE=""
                            fi # nothing
                        fi # bzr
                    fi # fossil
                fi # svn
            fi # hg

        else # if this vcs rep is disabled
            LP_VCS="" # not necessary, but more readable
            LP_VCS_TYPE="disabled"
        fi

        if [[ -z "$LP_VCS_TYPE" ]] ; then
            LP_VCS=""
        else
            LP_VCS=$(_lq_sl "${LP_VCS}")
        fi

        # end of the prompt line: double spaces
        LP_MARK=$(_lq_sb "$(_lq_smart_mark $LP_VCS_TYPE)")

        # Different path color if root
        if [[ "$EUID" -ne "0" ]] ; then
            LP_PWD="${LP_COLOR_PATH}${LP_PWD}${NO_COL}"
        else
            LP_PWD="${LP_COLOR_PATH_ROOT}${LP_PWD}${NO_COL}"
        fi
        LP_OLD_PWD="$PWD"

    # if do not change of working directory but...
    elif [[ -n "$LP_VCS_TYPE" ]]; then # we are still in a VCS dir
        case "$LP_VCS_TYPE" in
            git)     LP_VCS=$(_lq_sl "$(_lq_git_branch_color)");;
            git-svn) LP_VCS=$(_lq_sl "$(_lq_git_branch_color)");;
            hg)      LP_VCS=$(_lq_sl "$(_lq_hg_branch_color)");;
            svn)     LP_VCS=$(_lq_sl "$(_lq_svn_branch_color)");;
            fossil)  LP_VCS=$(_lq_sl "$(_lq_fossil_branch_color)");;
            bzr)     LP_VCS=$(_lq_sl "$(_lq_bzr_branch_color)");;
            disabled)LP_VCS="";;
        esac
    fi

    if [[ -f "$LP_PS1_FILE" ]]; then
        source "$LP_PS1_FILE"
    fi

    if [[ -z $LP_PS1 ]] ; then
        # add title escape time, jobs, load and battery
        PS1="${LP_PS1_PREFIX}${LP_TIME}${LP_BATT}${LP_LOAD}${LP_TEMP}${LP_JOBS}"
        # add user, host and permissions colon
        PS1="${PS1}${LP_BRACKET_OPEN}${LP_USER}${LP_HOST}${LP_PERM}"

        # if not root
        if [[ "$EUID" -ne "0" ]]
        then
            # path in foreground color
            PS1="${PS1}${LP_PWD}${LP_BRACKET_CLOSE}${LP_VENV}${LP_PROXY}"
            # add VCS infos
            PS1="${PS1}${LP_VCS}"
        else
            # path in yellow
            PS1="${PS1}${LP_PWD}${LP_BRACKET_CLOSE}${LP_VENV}${LP_PROXY}"
            # do not add VCS infos unless told otherwise (LP_ENABLE_VCS_ROOT)
            [[ "$LP_ENABLE_VCS_ROOT" = "1" ]] && PS1="${PS1}${LP_VCS}"
        fi
        # add return code and prompt mark
        PS1="${PS1}${LP_ERR}${LP_MARK}${LP_PS1_POSTFIX}"

        # "invisible" parts
        # Get the current prompt on the fly and make it a title
        LP_TITLE=$(_lq_title "$PS1")

        # Insert it in the prompt
        PS1="${LP_TITLE}${PS1}"

        # Glue the bash prompt always go to the first column.
        # Avoid glitches after interrupting a command with Ctrl-C
        # Does not seem to be necessary anymore?
        #PS1="\[\033[G\]${PS1}${NO_COL}"
    else
        PS1=$LP_PS1
    fi
}

