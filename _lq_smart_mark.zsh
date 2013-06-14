# Set the prompt mark to ± if git, to ☿ if mercurial, to ‡ if subversion
# to # if root and else $
_lq_smart_mark()
{
    local COL
    COL=${LP_COLOR_MARK}
    if [[ "$EUID" -eq "0" ]] ; then
        COL=${LP_COLOR_MARK_ROOT}
    fi

    local mark
    if [[ -n "$LP_MARK_DEFAULT" ]]; then
        mark=$LP_MARK_DEFAULT
    elif $_LP_SHELL_zsh; then
        mark="%(!.#.%%)"
    else
        mark="\\\$"
    fi
    if [[ "$1" == "git" ]]; then
        mark=$LP_MARK_GIT
    elif [[ "$1" == "git-svn" ]]; then
        mark="$LP_MARK_GIT$LP_MARK_SVN"
    elif [[ "$1" == "hg" ]]; then
        mark=$LP_MARK_HG
    elif [[ "$1" == "svn" ]]; then
        mark=$LP_MARK_SVN
    elif [[ "$1" == "fossil" ]]; then
        mark=$LP_MARK_FOSSIL
    elif [[ "$1" == "bzr" ]]; then
        mark=$LP_MARK_BZR
    elif [[ "$1" == "disabled" ]]; then
        mark=$LP_MARK_DISABLED
    fi
    echo -ne "${COL}${mark}${NO_COL}"
}

