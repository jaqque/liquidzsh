# Display the return value of the last command, if different from zero
_lp_return_value()
{
    if [[ "$1" -ne "0" ]]
    then
        echo -ne "$LP_COLOR_ERR$1$NO_COL"
    fi
}

