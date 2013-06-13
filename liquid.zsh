
################################################################################
# LIQUID PROMPT
# An intelligent and non intrusive prompt for bash and zsh
################################################################################


# Licensed under the AGPL version 3
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

###########
# AUTHORS #
###########

# Alex Prengère     <alexprengere@gmail.com>      # untracked git files
# Aurelien Requiem  <aurelien@requiem.fr>         # Major clean refactoring, variable path length, error codes, several bugfixes.
# Brendan Fahy      <bmfahy@gmail.com>            # postfix variable
# Clément Mathieu   <clement@unportant.info>      # Bazaar support
# David Loureiro    <david.loureiro@sysfera.com>  # small portability fix
# Étienne Deparis   <etienne.deparis@umaneti.net> # Fossil support
# Florian Le Frioux <florian@lefrioux.fr>         # Use ± mark when root in VCS dir.
# François Schmidts <francois.schmidts@gmail.com> # small code fix, _lp_get_dirtrim
# Frédéric Lepied   <flepied@gmail.com>           # Python virtual env
# Jonas Bengtsson   <jonas.b@gmail.com>           # Git remotes fix
# Joris Dedieu      <joris@pontiac3.nfrance.com>  # Portability framework, FreeBSD support, bugfixes.
# Joris Vaillant    <joris.vaillant@gmail.com>    # small git fix
# Luc Didry         <luc@fiat-tux.fr>             # Zsh port, several fix
# Ludovic Rousseau  <ludovic.rousseau@gmail.com>  # Lot of bugfixes.
# Nicolas Lacourte  <nicolas@dotinfra.fr>         # screen title
# nojhan            <nojhan@gmail.com>            # Main author.
# Olivier Mengué    <dolmen@cpan.org>             # Major optimizations and refactorings everywhere.
# Poil              <poil@quake.fr>               # speed improvements
# Thomas Debesse    <thomas.debesse@gmail.com>    # Fix columns use.
# Yann 'Ze' Richard <ze@nbox.org>                 # Do not fail on missing commands.

# See the README.md file for a summary of features.

# Check for recent enough version of bash.
if test -n "$BASH_VERSION" -a -n "$PS1" -a -n "$TERM" ; then
    bash=${BASH_VERSION%.*}; bmajor=${bash%.*}; bminor=${bash#*.}
    if [[ $bmajor -lt 3 ]] || [[ $bmajor -eq 3 && $bminor -lt 2 ]]; then
        unset bash bmajor bminor
        return
    fi
    unset bash bmajor bminor

    _LP_SHELL_bash=true
    _LP_SHELL_zsh=false
    _LP_OPEN_ESC="\["
    _LP_CLOSE_ESC="\]"
    _LP_USER_SYMBOL="\u"
    _LP_HOST_SYMBOL="\h"
    _LP_TIME_SYMBOL="\t"
elif test -n "$ZSH_VERSION" ; then
    _LP_SHELL_bash=false
    _LP_SHELL_zsh=true
    _LP_OPEN_ESC="%{"
    _LP_CLOSE_ESC="%}"
    _LP_USER_SYMBOL="%n"
    _LP_HOST_SYMBOL="%m"
    _LP_TIME_SYMBOL="%*"
else
    echo "liquidprompt: shell not supported" >&2
    return
fi


###############
# OS specific #
###############

# LP_OS detection, default to Linux
case $(uname) in
    FreeBSD)   LP_OS=FreeBSD ;;
    DragonFly) LP_OS=FreeBSD ;;
    Darwin)    LP_OS=Darwin  ;;
    SunOS)     LP_OS=SunOS   ;;
    *)         LP_OS=Linux   ;;
esac

# Get cpu count
case "$LP_OS" in
    Linux)   _lp_CPUNUM=$( nproc 2>/dev/null || grep -c '^[Pp]rocessor' /proc/cpuinfo ) ;;
    FreeBSD|Darwin) _lp_CPUNUM=$( sysctl -n hw.ncpu ) ;;
    SunOS)   _lp_CPUNUM=$( kstat -m cpu_info | grep -c "module: cpu_info" ) ;;
esac


# get current load
case "$LP_OS" in
    Linux)
        _lp_cpu_load () {
            local load eol
            read load eol < /proc/loadavg
            echo "$load"
        }
        ;;
    FreeBSD)
        _lp_cpu_load () {
            local bol load eol
            read bol load eol < $<( LANG=C sysctl -n vm.loadavg )
            echo "$load"
        }
        ;;
    Darwin)
        _lp_cpu_load () {
            local load
            load=$(LANG=C sysctl -n vm.loadavg | awk '{print $2}')
            echo "$load"
        }
        LP_DWIN_KERNEL_REL_VER=$(uname -r | cut -d . -f 1)
        ;;
    SunOS)
        _lp_cpu_load () {
            LANG=C uptime | awk '{print substr($10,0,length($10))}'
        }
esac


#################
# CONFIGURATION #
#################

# define, run, and forget _lp_source_config()
source _lp_source_config.zsh

# Disable features if the tool is not installed
[[ "$LP_ENABLE_GIT"  = 1 ]] && { command -v git  >/dev/null || LP_ENABLE_GIT=0  ; }
[[ "$LP_ENABLE_SVN"  = 1 ]] && { command -v svn  >/dev/null || LP_ENABLE_SVN=0  ; }
[[ "$LP_ENABLE_FOSSIL"  = 1 ]] && { command -v fossil  >/dev/null || LP_ENABLE_FOSSIL=0  ; }
[[ "$LP_ENABLE_HG"   = 1 ]] && { command -v hg   >/dev/null || LP_ENABLE_HG=0   ; }
[[ "$LP_ENABLE_BZR"  = 1 ]] && { command -v bzr > /dev/null || LP_ENABLE_BZR=0  ; }
[[ "$LP_ENABLE_BATT" = 1 ]] && { command -v acpi >/dev/null || LP_ENABLE_BATT=0 ; }

# If we are running in a terminal multiplexer, brackets are colored
if [[ "$TERM" == screen* ]]; then
    LP_BRACKET_OPEN="${LP_COLOR_IN_MULTIPLEXER}${LP_MARK_BRACKET_OPEN}${NO_COL}"
    LP_BRACKET_CLOSE="${LP_COLOR_IN_MULTIPLEXER}${LP_MARK_BRACKET_CLOSE}${NO_COL}"
else
    LP_BRACKET_OPEN="${LP_MARK_BRACKET_OPEN}"
    LP_BRACKET_CLOSE="${LP_MARK_BRACKET_CLOSE}"
fi


# Load string escape
source _lp_escape.zsh

###############
# Who are we? #
###############

# Yellow for root, bold if the user is not the login one, else no color.
if [[ "$EUID" -ne "0" ]] ; then  # if user is not root
    # if user is not login user
    if [[ ${USER} != "$(logname 2>/dev/null || echo $LOGNAME)" ]]; then
        LP_USER="${LP_COLOR_USER_ALT}${_LP_USER_SYMBOL}${NO_COL}"
    else
        if [[ "${LP_USER_ALWAYS}" -ne "0" ]] ; then
            LP_USER="${LP_COLOR_USER_LOGGED}${_LP_USER_SYMBOL}${NO_COL}"
        else
            LP_USER=""
        fi
    fi
else
    LP_USER="${LP_COLOR_USER_ROOT}${_LP_USER_SYMBOL}${NO_COL}"
fi


#################
# Where are we? #
#################

# Determine ssh/telnet/su/sudo
source _lp_connection.zsh


# Put the hostname if not locally connected
# color it in cyan within SSH, and a warning red if within telnet
# else diplay the host without color
# The connection is not expected to change from inside the shell, so we
# build this just once

# set LP_HOST to current chroot, if any
source _lp_chroot.zsh

# If we are connected with a X11 support
if [[ -n "$DISPLAY" ]] ; then
    LP_HOST="${LP_COLOR_X11_ON}${LP_HOST}@${NO_COL}"
else
    LP_HOST="${LP_COLOR_X11_OFF}${LP_HOST}@${NO_COL}"
fi

case "$(_lp_connection)" in
lcl)
    if [[ "${LP_HOSTNAME_ALWAYS}" -eq "0" ]] ; then
        # FIXME do we want to display the chroot if local?
        LP_HOST="" # no hostname if local
    else
        LP_HOST="${LP_HOST}${LP_COLOR_HOST}${_LP_HOST_SYMBOL}${NO_COL}"
    fi
    ;;
ssh)
    # If we want a different color for each host
    if [[ "$LP_ENABLE_SSH_COLORS" -eq "1" ]]; then
        # compute the hash of the hostname
        # and get the corresponding number in [1-6] (red,green,yellow,blue,purple or cyan)
        # FIXME check portability of cksum and add more formats (bold? 256 colors?)
        hash=$(( 1 + $(hostname | cksum | cut -d " " -f 1) % 6 ))
        color=${_LP_OPEN_ESC}$(ti_setaf $hash)${_LP_CLOSE_ESC}
        LP_HOST="${LP_HOST}${color}${_LP_HOST_SYMBOL}${NO_COL}"
        unset hash
        unset color
    else
        # the same color for all hosts
        LP_HOST="${LP_HOST}${LP_COLOR_SSH}${_LP_HOST_SYMBOL}${NO_COL}"
    fi
    ;;
su)
    LP_HOST="${LP_HOST}${LP_COLOR_SU}${_LP_HOST_SYMBOL}${NO_COL}"
    ;;
tel)
    LP_HOST="${LP_HOST}${LP_COLOR_TELNET}${_LP_HOST_SYMBOL}${NO_COL}"
    ;;
*)
    LP_HOST="${LP_HOST}${_LP_HOST_SYMBOL}" # defaults to no color
    ;;
esac

# Useless now, so undefine
# unset _lp_connection


# put an arrow if an http proxy is set
source _lp_proxy.zsh

# BASH/ZSH function that shortens
# a very long path for display by removing
# the left most parts and replacing them
# with a leading ...
#
# the first argument is the path
#
# the second argument is the maximum allowed
# length including the '/'s and ...
# http://hbfs.wordpress.com/2009/09/01/short-pwd-in-bash-prompts/
#
# + keep some left part of the path if asked
source _lp_shorten_path.zsh

# In bash shell, PROMPT_DIRTRIM is the number of directory to keep at the end
# of the displayed path (if "\w" is present in the PS1 var).
# liquidprompt can calculate this number under two condition, path shortening
# must be activated and PROMPT_DIRTRIM must be already set.
source _lp_get_dirtrim.zsh

# Display a ":"
# colored in green if user have write permission on the current directory
# colored in red if it have not.
source _lp_permissions_color.zsh

# Display the current Python virtual environnement, if available.
source _lp_virtualenv.zsh


################
# Related jobs #
################

# Display the count of each if non-zero:
# - detached screens sessions and/or tmux sessions running on the host
# - attached running jobs (started with $ myjob &)
# - attached stopped jobs (suspended with Ctrl-Z)
source _lp_jobcount_color.zsh


# Display the return value of the last command, if different from zero
source _lp_return_value.zsh


######################
# VCS branch display #
######################

source _lp_are_vcs_disabled.zsh

# GIT #

# Get the branch name of the current directory
source _lp_git_branch.zsh

# Set a color depending on the branch state:
# - green if the repository is up to date
# - yellow if there is some commits not pushed
# - red if there is changes to commit
#
# Add the number of pending commits and the impacted lines.
source _lp_git_branch_color.zsh


# MERCURIAL #

# Get the branch name of the current directory
source _lp_hg_branch.zsh

# Set a color depending on the branch state:
# - green if the repository is up to date
# - red if there is changes to commit
# - TODO: yellow if there is some commits not pushed
source _lp_hg_branch_color.zsh

# SUBVERSION #

# Get the branch name of the current directory
# For the first level of the repository, gives the repository name
source _lp_svn_branch.zsh

# Set a color depending on the branch state:
# - green if the repository is clean
#   (use $LP_SVN_STATUS_OPTS to define what that means with
#    the --depth option of 'svn status')
# - red if there is changes to commit
# Note that, due to subversion way of managing changes,
# informations are only displayed for the CURRENT directory.
source _lp_svn_branch_color.zsh


# FOSSIL #

# Get the tag name of the current directory
source _lp_fossil_branch.zsh

# Set a color depending on the branch state:
# - green if the repository is clean
# - red if there is changes to commit
# - yellow if the branch has no tag name
#
# Add the number of impacted files with a
# + when files are ADDED or EDITED
# - when files are DELETED
source _lp_fossil_branch_color.zsh

# Bazaar #

# Get the branch name of the current directory
source _lp_bzr_branch.zsh


# Set a color depending on the branch state:
# - green if the repository is up to date
# - red if there is changes to commit
# - TODO: yellow if there is some commits not pushed
#
# Add the number of pending commits and the impacted lines.
source _lp_bzr_branch_color.zsh


##################
# Battery status #
##################

# Get the battery status in percent
# returns 0 (and battery level) if battery is discharging and under threshold
# returns 1 (and battery level) if battery is discharging and above threshold
# returns 2 (and battery level) if battery is charging but under threshold
# returns 3 (and battery level) if battery is charging and above threshold
# returns 4 if no battery support
source _lp_battery.zsh

# Compute a gradient of background/foreground colors depending on the battery status
# Display:
# a  green ⏚ if the battery is charging    and above threshold
# a yellow ⏚ if the battery is charging    and under threshold
# a yellow ⌁ if the battery is discharging but above threshold
# a    red ⌁ if the battery is discharging and above threshold
source _lp_battery_color.zsh

source _lp_color_map.zsh

###############
# System load #
###############

# Compute a gradient of background/forground colors depending on the battery status
source _lp_load_color.zsh

######################
# System temperature #
######################

source _lp_temp_sensors.zsh

# Will set _lp_temp_function so the temperature monitoring feature use an
# available command. _lp_temp_function should return only a numeric value
if [[ "$LP_ENABLE_TEMP" = 1 ]]; then
    if command -v sensors >/dev/null; then
        _lp_temp_function=_lp_temp_sensors
    # elif command -v the_command_you_want_to_use; then
    #   _lp_temp_function=your_function
    else
        LP_ENABLE_TEMP=0
    fi
fi

source _lp_temperature.zsh

##########
# DESIGN #
##########

# Remove all colors and escape characters of the given string and return a pure text
source _lp_as_text.zsh

source _lp_title.zsh

# Set the prompt mark to ± if git, to ☿ if mercurial, to ‡ if subversion
# to # if root and else $
source _lp_smart_mark.zsh

# insert a space on the right
source _lp_sr.zsh

# insert a space on the left
source _lp_sl.zsh

# insert two space, before and after
source _lp_sb.zsh

###################
# CURRENT TIME    #
###################
source _lp_time_analog.zsh

source _lp_time.zsh

########################
# Construct the prompt #
########################


source _lp_set_prompt.zsh

source prompt_tag.zsh

# Activate the liquid prompt
source prompt_on.zsh

# Come back to the old prompt
source prompt_off.zsh

# Use an empty prompt: just the \$ mark
source prompt_OFF.zsh

# By default, sourcing liquid.zsh will activate Liquid
prompt_on

# Cleaning of variable that are not needed at runtime
unset LP_OS

# vim: set et sts=4 sw=4 tw=120 ft=sh:
