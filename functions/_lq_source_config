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

    # Colors: variables are local so they will have a value only
    # during config loading and will not conflict with other values
    # with the same names defined by the user outside the config.
    local        BOLD="%{$bold_color%}"

    local       BLACK="%{fg[black]%}"
    local        GRAY="%{$fg_bold[black]%}"

    local         RED="%{$fg[red]%}"
    local  BRIGHT_RED="%{$fg_bold[red]%}"

    local        GREEN="%{$fg[green]%}"
    local BRIGHT_GREEN="%{$fg_bold[green]%}"

    local        YELLOW="%{$fg[yellow]%}"
    local BRIGHT_YELLOW="%{$fg_bold[yellow]%}"

    local          BLUE="%{$fg[blue]%}"
    local   BRIGHT_BLUE="%{$fg_bold[blue]%}"

    local        PURPLE="%{$fg[magenta]%}"
    local          PINK="%{$fg_bold[magenta]%}"

    local          CYAN="%{$fg[cyan]%}"
    local   BRIGHT_CYAN="%{$fg_bold[cyan]%}"

    local         WHITE="%{$fg[white]%}"
    local  BRIGHT_WHITE="%{$fg_bold[white]%}"

    local       WARNING="%{$bg[red]$fg[black]%}"
    local        DANGER="%{$bg[red]$fg_bold[white]%}"
    local      CRITICAL="%{$bg[red]$fg_bold[yellow]%}"

    # LQ_RESET is special: it will be used at runtime as well
    LQ_RESET="%{$reset_color%}"


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
    LQ_SCREEN_TITLE_OPEN=${LQ_SCREEN_TITLE_OPEN:-"\ek"}
    LQ_SCREEN_TITLE_CLOSE=${LQ_SCREEN_TITLE_CLOSE:-"\e\\"}

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
    LQ_COLOR_PATH_ROOT=${LQ_COLOR_PATH_ROOT:-$BRIGHT_YELLOW}
    LQ_COLOR_PROXY=${LQ_COLOR_PROXY:-$BRIGHT_BLUE}
    LQ_COLOR_JOB_D=${LQ_COLOR_JOB_D:-$YELLOW}
    LQ_COLOR_JOB_R=${LQ_COLOR_JOB_R:-$BRIGHT_YELLOW}
    LQ_COLOR_JOB_Z=${LQ_COLOR_JOB_Z:-$BRIGHT_YELLOW}
    LQ_COLOR_ERR=${LQ_COLOR_ERR:-$PURPLE}
    LQ_COLOR_MARK=${LQ_COLOR_MARK:-$BOLD}
    LQ_COLOR_MARK_ROOT=${LQ_COLOR_MARK_ROOT:-$BRIGHT_RED}
    LQ_COLOR_USER_LOGGED=${LQ_COLOR_USER_LOGGED:-""}
    LQ_COLOR_USER_ALT=${LQ_COLOR_USER_ALT:-$BOLD}
    LQ_COLOR_USER_ROOT=${_ROOT:-$BRIGHT_YELLOW}
    LQ_COLOR_HOST=${LQ_COLOR_HOST:-""}
    LQ_COLOR_SSH=${LQ_COLOR_SSH:-$BLUE}
    LQ_COLOR_SU=${LQ_COLOR_SU:-$BRIGHT_YELLOW}
    LQ_COLOR_TELNET=${LQ_COLOR_TELNET:-$WARNING}
    LQ_COLOR_X11=${LQ_COLOR_X11:-""}
    LQ_COLOR_NOX11=${LQ_COLOR_X11:-$YELLOW}
    LQ_COLOR_WRITE=${LQ_COLOR_WRITE:-""}
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
    LQ_COLOR_IN_MULTIPLEXER=${LQ_COLOR_IN_MULTIPLEXER:-$BRIGHT_BLUE}

    LQ_HEATMAP[0]=${LQ_HEATMAP[0]:-""}
    LQ_HEATMAP[1]=${LQ_HEATMAP[1]:-$GREEN}
    LQ_HEATMAP[2]=${LQ_HEATMAP[2]:-$BRIGHT_GREEN}
    LQ_HEATMAP[3]=${LQ_HEATMAP[3]:-$YELLOW}
    LQ_HEATMAP[4]=${LQ_HEATMAP[4]:-$BRIGHT_YELLOW}
    LQ_HEATMAP[5]=${LQ_HEATMAP[5]:-$RED}
    LQ_HEATMAP[6]=${LQ_HEATMAP[6]:-$BRIGHT_RED}
    LQ_HEATMAP[7]=${LQ_HEATMAP[7]:-$WARNING}
    LQ_HEATMAP[8]=${LQ_HEATMAP[8]:-$DANGER}
    LQ_HEATMAP[9]=${LQ_HEATMAP[9]:-$CRITICAL}


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

