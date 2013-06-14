# Set the prompt mark to ± if git, to ☿ if mercurial, to ‡ if subversion
# to # if root and else $
_lq_smart_mark()
{
    local COL
    COL=${LQ_COLOR_MARK}
    if [[ "$EUID" -eq "0" ]] ; then
        COL=${LQ_COLOR_MARK_ROOT}
    fi

    local mark
    if [[ -n "$LQ_MARK_DEFAULT" ]]; then
        mark=$LQ_MARK_DEFAULT
    elif $_LQ_SHELL_zsh; then
        mark="%(!.#.%%)"
    else
        mark="\\\$"
    fi
    if [[ "$1" == "git" ]]; then
        mark=$LQ_MARK_GIT
    elif [[ "$1" == "git-svn" ]]; then
        mark="$LQ_MARK_GIT$LQ_MARK_SVN"
    elif [[ "$1" == "hg" ]]; then
        mark=$LQ_MARK_HG
    elif [[ "$1" == "svn" ]]; then
        mark=$LQ_MARK_SVN
    elif [[ "$1" == "fossil" ]]; then
        mark=$LQ_MARK_FOSSIL
    elif [[ "$1" == "bzr" ]]; then
        mark=$LQ_MARK_BZR
    elif [[ "$1" == "disabled" ]]; then
        mark=$LQ_MARK_DISABLED
    fi
    echo -ne "${COL}${mark}${NO_COL}"
}

