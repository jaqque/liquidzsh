_lp_color_map() {
    if   [[ $1 -ge 0   ]] && [[ $1 -lt 20  ]] ; then
        echo -ne "${LP_COLORMAP_0}"
    elif [[ $1 -ge 20  ]] && [[ $1 -lt 40  ]] ; then
        echo -ne "${LP_COLORMAP_1}"
    elif [[ $1 -ge 40  ]] && [[ $1 -lt 60  ]] ; then
        echo -ne "${LP_COLORMAP_2}"
    elif [[ $1 -ge 60  ]] && [[ $1 -lt 80  ]] ; then
        echo -ne "${LP_COLORMAP_3}"
    elif [[ $1 -ge 80  ]] && [[ $1 -lt 100 ]] ; then
        echo -ne "${LP_COLORMAP_4}"
    elif [[ $1 -ge 100 ]] && [[ $1 -lt 120 ]] ; then
        echo -ne "${LP_COLORMAP_5}"
    elif [[ $1 -ge 120 ]] && [[ $1 -lt 140 ]] ; then
        echo -ne "${LP_COLORMAP_6}"
    elif [[ $1 -ge 140 ]] && [[ $1 -lt 160 ]] ; then
        echo -ne "${LP_COLORMAP_7}"
    elif [[ $1 -ge 160 ]] && [[ $1 -lt 180 ]] ; then
        echo -ne "${LP_COLORMAP_8}"
    elif [[ $1 -ge 180 ]] ; then
        echo -ne "${LP_COLORMAP_9}"
    else
        echo -ne "${LP_COLORMAP_0}"
    fi
}

