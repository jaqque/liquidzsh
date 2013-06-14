# The following code is run just once. But it is encapsulated in a function
# to benefit of 'local' variables.
#
# What we do here:
# 1. Setup variables that can be used by the user: the "API" of liquidprompt
#    for config/theme. Those variables are local to the function.
#    In practice, this is only color variables.
# 2. Setup default values
# 3. Load the configuration
_lq_source_config()
{

    # TermInfo feature detection
    local ti_sgr0="$( { tput sgr0 || tput me ; } 2>/dev/null )"
    local ti_bold="$( { tput bold || tput md ; } 2>/dev/null )"
    local ti_setaf
    if tput setaf >/dev/null 2>&1 ; then
        ti_setaf () { tput setaf "$1" ; }
    elif tput AF >/dev/null 2>&1 ; then
        # *BSD
        ti_setaf () { tput AF "$1" ; }
    else
        echo "liquidprompt: terminal $TERM not supported" >&2
        ti_setaf () { : ; }
    fi

    # Colors: variables are local so they will have a value only
    # during config loading and will not conflict with other values
    # with the same names defined by the user outside the config.
    local BOLD="${_LQ_OPEN_ESC}${ti_bold}${_LQ_CLOSE_ESC}"

    local BLACK="${_LQ_OPEN_ESC}$(ti_setaf 0)${_LQ_CLOSE_ESC}"
    local BOLD_GRAY="${_LQ_OPEN_ESC}${ti_bold}$(ti_setaf 0)${_LQ_CLOSE_ESC}"
    local WHITE="${_LQ_OPEN_ESC}$(ti_setaf 7)${_LQ_CLOSE_ESC}"
    local BOLD_WHITE="${_LQ_OPEN_ESC}${ti_bold}$(ti_setaf 7)${_LQ_CLOSE_ESC}"

    local RED="${_LQ_OPEN_ESC}$(ti_setaf 1)${_LQ_CLOSE_ESC}"
    local BOLD_RED="${_LQ_OPEN_ESC}${ti_bold}$(ti_setaf 1)${_LQ_CLOSE_ESC}"
    local WARN_RED="${_LQ_OPEN_ESC}$(ti_setaf 0 ; tput setab 1)${_LQ_CLOSE_ESC}"
    local CRIT_RED="${_LQ_OPEN_ESC}${ti_bold}$(ti_setaf 7 ; tput setab 1)${_LQ_CLOSE_ESC}"
    local DANGER_RED="${_LQ_OPEN_ESC}${ti_bold}$(ti_setaf 3 ; tput setab 1)${_LQ_CLOSE_ESC}"

    local GREEN="${_LQ_OPEN_ESC}$(ti_setaf 2)${_LQ_CLOSE_ESC}"
    local BOLD_GREEN="${_LQ_OPEN_ESC}${ti_bold}$(ti_setaf 2)${_LQ_CLOSE_ESC}"

    local YELLOW="${_LQ_OPEN_ESC}$(ti_setaf 3)${_LQ_CLOSE_ESC}"
    local BOLD_YELLOW="${_LQ_OPEN_ESC}${ti_bold}$(ti_setaf 3)${_LQ_CLOSE_ESC}"

    local BLUE="${_LQ_OPEN_ESC}$(ti_setaf 4)${_LQ_CLOSE_ESC}"
    local BOLD_BLUE="${_LQ_OPEN_ESC}${ti_bold}$(ti_setaf 4)${_LQ_CLOSE_ESC}"

    local PURPLE="${_LQ_OPEN_ESC}$(ti_setaf 5)${_LQ_CLOSE_ESC}"
    local PINK="${_LQ_OPEN_ESC}${ti_bold}$(ti_setaf 5)${_LQ_CLOSE_ESC}"

    local CYAN="${_LQ_OPEN_ESC}$(ti_setaf 6)${_LQ_CLOSE_ESC}"
    local BOLD_CYAN="${_LQ_OPEN_ESC}${ti_bold}$(ti_setaf 6)${_LQ_CLOSE_ESC}"

    # NO_COL is special: it will be used at runtime, not just during config loading
    NO_COL="${_LQ_OPEN_ESC}${ti_sgr0}${_LQ_CLOSE_ESC}"

    unset ti_sgr0 ti_bold ti_setaf


    # Default values (globals)
    LQ_BATTERY_THRESHOLD=${LQ_BATTERY_THRESHOLD:-75}
    LQ_LOAD_THRESHOLD=${LQ_LOAD_THRESHOLD:-60}
    LQ_TEMP_THRESHOLD=${LQ_TEMP_THRESHOLD:-60}
    LQ_PATH_LENGTH=${LQ_PATH_LENGTH:-35}
    LQ_PATH_KEEP=${LQ_PATH_KEEP:-2}
    LQ_HOSTNAME_ALWAYS=${LQ_HOSTNAME_ALWAYS:-0}
    LQ_USER_ALWAYS=${LQ_USER_ALWAYS:-1}
    LQ_PERCENTS_ALWAYS=${LQ_PERCENTS_ALWAYS:-1}
    LQ_PS1=${LQ_PS1:-""}
    LQ_PS1_PREFIX=${LQ_PS1_PREFIX:-""}
    LQ_PS1_POSTFIX=${LQ_PS1_POSTFIX:-""}
    LQ_TITLE_OPEN=${LQ_TITLE_OPEN:-"\e]0;"}
    LQ_TITLE_CLOSE=${LQ_TITLE_CLOSE:-"\a"}
    LQ_SCREEN_TITLE_OPEN=${LQ_SCREEN_TITLE_OPEN:-"\033k"}
    LQ_SCREEN_TITLE_CLOSE=${LQ_SCREEN_TITLE_CLOSE:-"\033\134"}

    LQ_ENABLE_PERM=${LQ_ENABLE_PERM:-1}
    LQ_ENABLE_SHORTEN_PATH=${LQ_ENABLE_SHORTEN_PATH:-1}
    LQ_ENABLE_PROXY=${LQ_ENABLE_PROXY:-1}
    LQ_ENABLE_TEMP=${LQ_ENABLE_TEMP:-1}
    LQ_ENABLE_JOBS=${LQ_ENABLE_JOBS:-1}
    LQ_ENABLE_LOAD=${LQ_ENABLE_LOAD:-1}
    LQ_ENABLE_BATT=${LQ_ENABLE_BATT:-1}
    LQ_ENABLE_GIT=${LQ_ENABLE_GIT:-1}
    LQ_ENABLE_SVN=${LQ_ENABLE_SVN:-1}
    LQ_ENABLE_FOSSIL=${LQ_ENABLE_FOSSIL:-1}
    LQ_ENABLE_HG=${LQ_ENABLE_HG:-1}
    LQ_ENABLE_BZR=${LQ_ENABLE_BZR:-1}
    LQ_ENABLE_TIME=${LQ_ENABLE_TIME:-0}
    LQ_ENABLE_VIRTUALENV=${LQ_ENABLE_VIRTUALENV:-1}
    LQ_ENABLE_VCS_ROOT=${LQ_ENABLE_VCS_ROOT:-0}
    LQ_ENABLE_TITLE=${LQ_ENABLE_TITLE:-0}
    LQ_ENABLE_SCREEN_TITLE=${LQ_ENABLE_SCREEN_TITLE:-0}
    LQ_ENABLE_SSH_COLORS=${LQ_ENABLE_SSH_COLORS:-0}
    LQ_DISABLED_VCS_PATH=${LQ_DISABLED_VCS_PATH:-""}

    LQ_MARK_DEFAULT=${LQ_MARK_DEFAULT:-""}
    LQ_MARK_BATTERY=${LQ_MARK_BATTERY:-"⌁"}
    LQ_MARK_ADAPTER=${LQ_MARK_ADAPTER:-"⏚"}
    LQ_MARK_LOAD=${LQ_MARK_LOAD:-"⌂"}
    LQ_MARK_TEMP=${LQ_MARK_TEMP:-"θ"}
    LQ_MARK_PROXY=${LQ_MARK_PROXY:-"↥"}
    LQ_MARK_HG=${LQ_MARK_HG:-"☿"}
    LQ_MARK_SVN=${LQ_MARK_SVN:-"‡"}
    LQ_MARK_GIT=${LQ_MARK_GIT:-"±"}
    LQ_MARK_FOSSIL=${LQ_MARK_FOSSIL:-"⌘"}
    LQ_MARK_BZR=${LQ_MARK_BZR:-"⚯"}
    LQ_MARK_DISABLED=${LQ_MARK_DISABLED:-"⌀"}
    LQ_MARK_UNTRACKED=${LQ_MARK_UNTRACKED:-"*"}
    LQ_MARK_STASH=${LQ_MARK_STASH:-"+"}
    LQ_MARK_BRACKET_OPEN=${LQ_MARK_BRACKET_OPEN:-"["}
    LQ_MARK_BRACKET_CLOSE=${LQ_MARK_BRACKET_CLOSE:-"]"}
    LQ_MARK_SHORTEN_PATH=${LQ_MARK_SHORTEN_PATH:-" … "}

    LQ_COLOR_PATH=${LQ_COLOR_PATH:-$BOLD}
    LQ_COLOR_PATH_ROOT=${LQ_COLOR_PATH_ROOT:-$BOLD_YELLOW}
    LQ_COLOR_PROXY=${LQ_COLOR_PROXY:-$BOLD_BLUE}
    LQ_COLOR_JOB_D=${LQ_COLOR_JOB_D:-$YELLOW}
    LQ_COLOR_JOB_R=${LQ_COLOR_JOB_R:-$BOLD_YELLOW}
    LQ_COLOR_JOB_Z=${LQ_COLOR_JOB_Z:-$BOLD_YELLOW}
    LQ_COLOR_ERR=${LQ_COLOR_ERR:-$PURPLE}
    LQ_COLOR_MARK=${LQ_COLOR_MARK:-$BOLD}
    LQ_COLOR_MARK_ROOT=${LQ_COLOR_MARK_ROOT:-$BOLD_RED}
    LQ_COLOR_USER_LOGGED=${LQ_COLOR_USER_LOGGED:-""}
    LQ_COLOR_USER_ALT=${LQ_COLOR_USER_ALT:-$BOLD}
    LQ_COLOR_USER_ROOT=${_ROOT:-$BOLD_YELLOW}
    LQ_COLOR_HOST=${LQ_COLOR_HOST:-""}
    LQ_COLOR_SSH=${LQ_COLOR_SSH:-$BLUE}
    LQ_COLOR_SU=${LQ_COLOR_SU:-$BOLD_YELLOW}
    LQ_COLOR_TELNET=${LQ_COLOR_TELNET:-$WARN_RED}
    LQ_COLOR_X11_ON=${LQ_COLOR_X11:-$GREEN}
    LQ_COLOR_X11_OFF=${LQ_COLOR_X11:-$YELLOW}
    LQ_COLOR_WRITE=${LQ_COLOR_WRITE:-$GREEN}
    LQ_COLOR_NOWRITE=${LQ_COLOR_NOWRITE:-$RED}
    LQ_COLOR_UP=${LQ_COLOR_UP:-$GREEN}
    LQ_COLOR_COMMITS=${LQ_COLOR_COMMITS:-$YELLOW}
    LQ_COLOR_CHANGES=${LQ_COLOR_CHANGES:-$RED}
    LQ_COLOR_DIFF=${LQ_COLOR_DIFF:-$PURPLE}
    LQ_COLOR_CHARGING_ABOVE=${LQ_COLOR_CHARGING_ABOVE:-$GREEN}
    LQ_COLOR_CHARGING_UNDER=${LQ_COLOR_CHARGING_UNDER:-$YELLOW}
    LQ_COLOR_DISCHARGING_ABOVE=${LQ_COLOR_DISCHARGING_ABOVE:-$YELLOW}
    LQ_COLOR_DISCHARGING_UNDER=${LQ_COLOR_DISCHARGING_UNDER:-$RED}
    LQ_COLOR_TIME=${LQ_COLOR_TIME:-$BLUE}
    LQ_COLOR_IN_MULTIPLEXER=${LQ_COLOR_IN_MULTIPLEXER:-$BOLD_BLUE}

    LQ_COLORMAP_0=${LQ_COLORMAP_0:-""}
    LQ_COLORMAP_1=${LQ_COLORMAP_1:-$GREEN}
    LQ_COLORMAP_2=${LQ_COLORMAP_2:-$BOLD_GREEN}
    LQ_COLORMAP_3=${LQ_COLORMAP_3:-$YELLOW}
    LQ_COLORMAP_4=${LQ_COLORMAP_4:-$BOLD_YELLOW}
    LQ_COLORMAP_5=${LQ_COLORMAP_5:-$RED}
    LQ_COLORMAP_6=${LQ_COLORMAP_6:-$BOLD_RED}
    LQ_COLORMAP_7=${LQ_COLORMAP_7:-$WARN_RED}
    LQ_COLORMAP_8=${LQ_COLORMAP_8:-$CRIT_RED}
    LQ_COLORMAP_9=${LQ_COLORMAP_9:-$DANGER_RED}


    # Default config file may be the XDG standard ~/.config/liquidpromptrc,
    # but heirloom dotfile has priority.

    local configfile
    if [[ -f "/etc/liquidpromptrc" ]]
    then
        source "/etc/liquidpromptrc"
    fi
    if [[ -f "$HOME/.liquidpromptrc" ]]
    then
        configfile="$HOME/.liquidpromptrc"
    elif [[ -z "$XDG_HOME_DIR" ]]
    then
        configfile="$HOME/.config/liquidpromptrc"
    else
        configfile="$XDG_HOME_DIR/liquidpromptrc"
    fi
    if [[ -f "$configfile" ]]
    then
        source "$configfile"
    fi
}

