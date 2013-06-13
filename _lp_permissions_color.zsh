# Display a ":"
# colored in green if user have write permission on the current directory
# colored in red if it have not.
_lp_permissions_color()
{
    if [[ "$LP_ENABLE_PERM" != 1 ]]; then
        echo : # without color
    else
        if [[ -w "${PWD}" ]]; then
            echo "${LP_COLOR_WRITE}:${NO_COL}"
        else
            echo "${LP_COLOR_NOWRITE}:${NO_COL}"
        fi
    fi
}

