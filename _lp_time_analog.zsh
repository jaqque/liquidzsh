###################
# CURRENT TIME    #
###################
_lp_time_analog()
{
    # get the date as "hours(12) minutes" in a single call
    # make a bash array with it
    local d=( $(date "+%I %M") )
    # separate hours and minutes
    local -i hour=${d[0]#0} # no leading 0
    local -i min=${d[1]#0}

    # The targeted unicode characters are the "CLOCK FACE" ones
    # They are located in the codepages between:
    #     U+1F550 (ONE OCLOCK) and U+1F55B (TWELVE OCLOCK), for the plain hours
    #     U+1F55C (ONE-THIRTY) and U+1F567 (TWELVE-THIRTY), for the thirties
    #

    local plain=(🕐 🕑 🕒 🕓 🕔 🕕 🕖 🕗 🕘 🕙 🕚 🕛 )
    local half=(🕜 🕝 🕞 🕟 🕠 🕡 🕢 🕣 🕤 🕥 🕦 🕧 )

    # array index starts at 0
    local -i hi=hour-1

    # add a space for correct alignment
    if (( min < 15 )) ; then
        echo -n "${plain[hi]} "
    elif (( min < 45 )) ; then
        echo -n "${half[hi]} "
    else
        echo -n "${plain[hi+1]} "
    fi
}

