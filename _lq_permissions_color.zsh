# Display a ":"
# colored in green if user have write permission on the current directory
# colored in red if it have not.
_lq_permissions_color()
{
    if [[ "$LQ_ENABLE_PERM" != 1 ]]; then
        echo : # without color
    else
        if [[ -w "${PWD}" ]]; then
            echo "${LQ_COLOR_WRITE}:${NO_COL}"
        else
            echo "${LQ_COLOR_NOWRITE}:${NO_COL}"
        fi
    fi
}

