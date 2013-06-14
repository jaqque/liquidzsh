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
    local BOLD="${_LP_OPEN_ESC}${ti_bold}${_LP_CLOSE_ESC}"

    local BLACK="${_LP_OPEN_ESC}$(ti_setaf 0)${_LP_CLOSE_ESC}"
    local BOLD_GRAY="${_LP_OPEN_ESC}${ti_bold}$(ti_setaf 0)${_LP_CLOSE_ESC}"
    local WHITE="${_LP_OPEN_ESC}$(ti_setaf 7)${_LP_CLOSE_ESC}"
    local BOLD_WHITE="${_LP_OPEN_ESC}${ti_bold}$(ti_setaf 7)${_LP_CLOSE_ESC}"

    local RED="${_LP_OPEN_ESC}$(ti_setaf 1)${_LP_CLOSE_ESC}"
    local BOLD_RED="${_LP_OPEN_ESC}${ti_bold}$(ti_setaf 1)${_LP_CLOSE_ESC}"
    local WARN_RED="${_LP_OPEN_ESC}$(ti_setaf 0 ; tput setab 1)${_LP_CLOSE_ESC}"
    local CRIT_RED="${_LP_OPEN_ESC}${ti_bold}$(ti_setaf 7 ; tput setab 1)${_LP_CLOSE_ESC}"
    local DANGER_RED="${_LP_OPEN_ESC}${ti_bold}$(ti_setaf 3 ; tput setab 1)${_LP_CLOSE_ESC}"

    local GREEN="${_LP_OPEN_ESC}$(ti_setaf 2)${_LP_CLOSE_ESC}"
    local BOLD_GREEN="${_LP_OPEN_ESC}${ti_bold}$(ti_setaf 2)${_LP_CLOSE_ESC}"

    local YELLOW="${_LP_OPEN_ESC}$(ti_setaf 3)${_LP_CLOSE_ESC}"
    local BOLD_YELLOW="${_LP_OPEN_ESC}${ti_bold}$(ti_setaf 3)${_LP_CLOSE_ESC}"

    local BLUE="${_LP_OPEN_ESC}$(ti_setaf 4)${_LP_CLOSE_ESC}"
    local BOLD_BLUE="${_LP_OPEN_ESC}${ti_bold}$(ti_setaf 4)${_LP_CLOSE_ESC}"

    local PURPLE="${_LP_OPEN_ESC}$(ti_setaf 5)${_LP_CLOSE_ESC}"
    local PINK="${_LP_OPEN_ESC}${ti_bold}$(ti_setaf 5)${_LP_CLOSE_ESC}"

    local CYAN="${_LP_OPEN_ESC}$(ti_setaf 6)${_LP_CLOSE_ESC}"
    local BOLD_CYAN="${_LP_OPEN_ESC}${ti_bold}$(ti_setaf 6)${_LP_CLOSE_ESC}"

    # NO_COL is special: it will be used at runtime, not just during config loading
    NO_COL="${_LP_OPEN_ESC}${ti_sgr0}${_LP_CLOSE_ESC}"

    unset ti_sgr0 ti_bold ti_setaf


    # Default values (globals)
    LP_BATTERY_THRESHOLD=${LP_BATTERY_THRESHOLD:-75}
    LP_LOAD_THRESHOLD=${LP_LOAD_THRESHOLD:-60}
    LP_TEMP_THRESHOLD=${LP_TEMP_THRESHOLD:-60}
    LP_PATH_LENGTH=${LP_PATH_LENGTH:-35}
    LP_PATH_KEEP=${LP_PATH_KEEP:-2}
    LP_HOSTNAME_ALWAYS=${LP_HOSTNAME_ALWAYS:-0}
    LP_USER_ALWAYS=${LP_USER_ALWAYS:-1}
    LP_PERCENTS_ALWAYS=${LP_PERCENTS_ALWAYS:-1}
    LP_PS1=${LP_PS1:-""}
    LP_PS1_PREFIX=${LP_PS1_PREFIX:-""}
    LP_PS1_POSTFIX=${LP_PS1_POSTFIX:-""}
    LP_TITLE_OPEN=${LP_TITLE_OPEN:-"\e]0;"}
    LP_TITLE_CLOSE=${LP_TITLE_CLOSE:-"\a"}
    LP_SCREEN_TITLE_OPEN=${LP_SCREEN_TITLE_OPEN:-"\033k"}
    LP_SCREEN_TITLE_CLOSE=${LP_SCREEN_TITLE_CLOSE:-"\033\134"}

    LP_ENABLE_PERM=${LP_ENABLE_PERM:-1}
    LP_ENABLE_SHORTEN_PATH=${LP_ENABLE_SHORTEN_PATH:-1}
    LP_ENABLE_PROXY=${LP_ENABLE_PROXY:-1}
    LP_ENABLE_TEMP=${LP_ENABLE_TEMP:-1}
    LP_ENABLE_JOBS=${LP_ENABLE_JOBS:-1}
    LP_ENABLE_LOAD=${LP_ENABLE_LOAD:-1}
    LP_ENABLE_BATT=${LP_ENABLE_BATT:-1}
    LP_ENABLE_GIT=${LP_ENABLE_GIT:-1}
    LP_ENABLE_SVN=${LP_ENABLE_SVN:-1}
    LP_ENABLE_FOSSIL=${LP_ENABLE_FOSSIL:-1}
    LP_ENABLE_HG=${LP_ENABLE_HG:-1}
    LP_ENABLE_BZR=${LP_ENABLE_BZR:-1}
    LP_ENABLE_TIME=${LP_ENABLE_TIME:-0}
    LP_ENABLE_VIRTUALENV=${LP_ENABLE_VIRTUALENV:-1}
    LP_ENABLE_VCS_ROOT=${LP_ENABLE_VCS_ROOT:-0}
    LP_ENABLE_TITLE=${LP_ENABLE_TITLE:-0}
    LP_ENABLE_SCREEN_TITLE=${LP_ENABLE_SCREEN_TITLE:-0}
    LP_ENABLE_SSH_COLORS=${LP_ENABLE_SSH_COLORS:-0}
    LP_DISABLED_VCS_PATH=${LP_DISABLED_VCS_PATH:-""}

    LP_MARK_DEFAULT=${LP_MARK_DEFAULT:-""}
    LP_MARK_BATTERY=${LP_MARK_BATTERY:-"⌁"}
    LP_MARK_ADAPTER=${LP_MARK_ADAPTER:-"⏚"}
    LP_MARK_LOAD=${LP_MARK_LOAD:-"⌂"}
    LP_MARK_TEMP=${LP_MARK_TEMP:-"θ"}
    LP_MARK_PROXY=${LP_MARK_PROXY:-"↥"}
    LP_MARK_HG=${LP_MARK_HG:-"☿"}
    LP_MARK_SVN=${LP_MARK_SVN:-"‡"}
    LP_MARK_GIT=${LP_MARK_GIT:-"±"}
    LP_MARK_FOSSIL=${LP_MARK_FOSSIL:-"⌘"}
    LP_MARK_BZR=${LP_MARK_BZR:-"⚯"}
    LP_MARK_DISABLED=${LP_MARK_DISABLED:-"⌀"}
    LP_MARK_UNTRACKED=${LP_MARK_UNTRACKED:-"*"}
    LP_MARK_STASH=${LP_MARK_STASH:-"+"}
    LP_MARK_BRACKET_OPEN=${LP_MARK_BRACKET_OPEN:-"["}
    LP_MARK_BRACKET_CLOSE=${LP_MARK_BRACKET_CLOSE:-"]"}
    LP_MARK_SHORTEN_PATH=${LP_MARK_SHORTEN_PATH:-" … "}

    LP_COLOR_PATH=${LP_COLOR_PATH:-$BOLD}
    LP_COLOR_PATH_ROOT=${LP_COLOR_PATH_ROOT:-$BOLD_YELLOW}
    LP_COLOR_PROXY=${LP_COLOR_PROXY:-$BOLD_BLUE}
    LP_COLOR_JOB_D=${LP_COLOR_JOB_D:-$YELLOW}
    LP_COLOR_JOB_R=${LP_COLOR_JOB_R:-$BOLD_YELLOW}
    LP_COLOR_JOB_Z=${LP_COLOR_JOB_Z:-$BOLD_YELLOW}
    LP_COLOR_ERR=${LP_COLOR_ERR:-$PURPLE}
    LP_COLOR_MARK=${LP_COLOR_MARK:-$BOLD}
    LP_COLOR_MARK_ROOT=${LP_COLOR_MARK_ROOT:-$BOLD_RED}
    LP_COLOR_USER_LOGGED=${LP_COLOR_USER_LOGGED:-""}
    LP_COLOR_USER_ALT=${LP_COLOR_USER_ALT:-$BOLD}
    LP_COLOR_USER_ROOT=${_ROOT:-$BOLD_YELLOW}
    LP_COLOR_HOST=${LP_COLOR_HOST:-""}
    LP_COLOR_SSH=${LP_COLOR_SSH:-$BLUE}
    LP_COLOR_SU=${LP_COLOR_SU:-$BOLD_YELLOW}
    LP_COLOR_TELNET=${LP_COLOR_TELNET:-$WARN_RED}
    LP_COLOR_X11_ON=${LP_COLOR_X11:-$GREEN}
    LP_COLOR_X11_OFF=${LP_COLOR_X11:-$YELLOW}
    LP_COLOR_WRITE=${LP_COLOR_WRITE:-$GREEN}
    LP_COLOR_NOWRITE=${LP_COLOR_NOWRITE:-$RED}
    LP_COLOR_UP=${LP_COLOR_UP:-$GREEN}
    LP_COLOR_COMMITS=${LP_COLOR_COMMITS:-$YELLOW}
    LP_COLOR_CHANGES=${LP_COLOR_CHANGES:-$RED}
    LP_COLOR_DIFF=${LP_COLOR_DIFF:-$PURPLE}
    LP_COLOR_CHARGING_ABOVE=${LP_COLOR_CHARGING_ABOVE:-$GREEN}
    LP_COLOR_CHARGING_UNDER=${LP_COLOR_CHARGING_UNDER:-$YELLOW}
    LP_COLOR_DISCHARGING_ABOVE=${LP_COLOR_DISCHARGING_ABOVE:-$YELLOW}
    LP_COLOR_DISCHARGING_UNDER=${LP_COLOR_DISCHARGING_UNDER:-$RED}
    LP_COLOR_TIME=${LP_COLOR_TIME:-$BLUE}
    LP_COLOR_IN_MULTIPLEXER=${LP_COLOR_IN_MULTIPLEXER:-$BOLD_BLUE}

    LP_COLORMAP_0=${LP_COLORMAP_0:-""}
    LP_COLORMAP_1=${LP_COLORMAP_1:-$GREEN}
    LP_COLORMAP_2=${LP_COLORMAP_2:-$BOLD_GREEN}
    LP_COLORMAP_3=${LP_COLORMAP_3:-$YELLOW}
    LP_COLORMAP_4=${LP_COLORMAP_4:-$BOLD_YELLOW}
    LP_COLORMAP_5=${LP_COLORMAP_5:-$RED}
    LP_COLORMAP_6=${LP_COLORMAP_6:-$BOLD_RED}
    LP_COLORMAP_7=${LP_COLORMAP_7:-$WARN_RED}
    LP_COLORMAP_8=${LP_COLORMAP_8:-$CRIT_RED}
    LP_COLORMAP_9=${LP_COLORMAP_9:-$DANGER_RED}


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
# do source config files
_lq_source_config
unset _lq_source_config

