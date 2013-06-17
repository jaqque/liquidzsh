
################################################################################
# LIQUID
# An intelligent, adaptive and non-intrusive prompt for zsh
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

# See the README.md file for a summary of features and authors

# Where are we?
# Too clever:
#  1) ${_%/*} take the argument (name of this file) and remove the 
#     last / plus anything following it
#  2) ${ #$_} if 1) above matches the last argument, print nothing 
#     (eg: $_ had no / in it)
#  3) ${ :-.} if 2) above is blank, then print .
pushd -q "${${${_%/*}:#$_}:-.}"

_LQ_OPEN_ESC="%{"
_LQ_CLOSE_ESC="%}"
_LQ_USER_SYMBOL="%n"
_LQ_HOST_SYMBOL="%m"
_LQ_TIME_SYMBOL="%*"


###############
# OS specific #
###############

# LQ_OS detection, default to Linux
case $(uname) in
    FreeBSD)   LQ_OS=FreeBSD ;;
    DragonFly) LQ_OS=FreeBSD ;;
    Darwin)    LQ_OS=Darwin  ;;
    SunOS)     LQ_OS=SunOS   ;;
    *)         LQ_OS=Linux   ;;
esac

# Get cpu count
case "$LQ_OS" in
    Linux)   _lq_CPUNUM=$( nproc 2>/dev/null || grep -c '^[Pp]rocessor' /proc/cpuinfo ) ;;
    FreeBSD|Darwin) _lq_CPUNUM=$( sysctl -n hw.ncpu ) ;;
    SunOS)   _lq_CPUNUM=$( kstat -m cpu_info | grep -c "module: cpu_info" ) ;;
esac


# get current load
source functions/$LQ_OS/_lq_cpu_load.zsh


#################
# CONFIGURATION #
#################

autoload -U colors
colors

# define, run, and forget _lq_source_config()
source functions/_lq_source_config.zsh
_lq_source_config
unset _lq_source_config

# Disable features if the tool is not installed
[[ "$LQ_ENABLE_GIT"  = 1 ]] && { command -v git  >/dev/null || LQ_ENABLE_GIT=0  ; }
[[ "$LQ_ENABLE_SVN"  = 1 ]] && { command -v svn  >/dev/null || LQ_ENABLE_SVN=0  ; }
[[ "$LQ_ENABLE_FOSSIL"  = 1 ]] && { command -v fossil  >/dev/null || LQ_ENABLE_FOSSIL=0  ; }
[[ "$LQ_ENABLE_HG"   = 1 ]] && { command -v hg   >/dev/null || LQ_ENABLE_HG=0   ; }
[[ "$LQ_ENABLE_BZR"  = 1 ]] && { command -v bzr > /dev/null || LQ_ENABLE_BZR=0  ; }
[[ "$LQ_ENABLE_BATT" = 1 ]] && { command -v acpi >/dev/null || LQ_ENABLE_BATT=0 ; }

# If we are running in a terminal multiplexer, brackets are colored
if [[ "$TERM" == screen* ]]; then
    LQ_BRACKET_OPEN="${LQ_COLOR_IN_MULTIPLEXER}${LQ_MARK_BRACKET_OPEN}${LQ_RESET}"
    LQ_BRACKET_CLOSE="${LQ_COLOR_IN_MULTIPLEXER}${LQ_MARK_BRACKET_CLOSE}${LQ_RESET}"
else
    LQ_BRACKET_OPEN="${LQ_MARK_BRACKET_OPEN}"
    LQ_BRACKET_CLOSE="${LQ_MARK_BRACKET_CLOSE}"
fi


# Load string escape
source functions/_lq_escape.zsh

###############
# Who are we? #
###############

# Yellow for root, bold if the user is not the login one, else no color.
if [[ "$EUID" -ne "0" ]] ; then  # if user is not root
    # if user is not login user
    if [[ ${USER} != "$(logname 2>/dev/null || echo $LOGNAME)" ]]; then
        LQ_USER="${LQ_COLOR_USER_ALT}${_LQ_USER_SYMBOL}${LQ_RESET}"
    else
        if [[ "${LQ_USER_ALWAYS}" -ne "0" ]] ; then
            LQ_USER="${LQ_COLOR_USER_LOGGED}${_LQ_USER_SYMBOL}${LQ_RESET}"
        else
            LQ_USER=""
        fi
    fi
else
    LQ_USER="${LQ_COLOR_USER_ROOT}${_LQ_USER_SYMBOL}${LQ_RESET}"
fi


#################
# Where are we? #
#################

# Determine ssh/telnet/su/sudo
source functions/_lq_connection.zsh


# Put the hostname if not locally connected
# color it in cyan within SSH, and a warning red if within telnet
# else diplay the host without color
# The connection is not expected to change from inside the shell, so we
# build this just once

# set LQ_HOST to current chroot, if any
source functions/_lq_chroot.zsh

# If we are connected with a X11 support
if [[ -n "$DISPLAY" ]] ; then
    LQ_HOST="${LQ_COLOR_X11_ON}${LQ_HOST}@${LQ_RESET}"
else
    LQ_HOST="${LQ_COLOR_X11_OFF}${LQ_HOST}@${LQ_RESET}"
fi

case "$(_lq_connection)" in
lcl)
    if [[ "${LQ_HOSTNAME_ALWAYS}" -eq "0" ]] ; then
        # FIXME do we want to display the chroot if local?
        LQ_HOST="" # no hostname if local
    else
        LQ_HOST="${LQ_HOST}${LQ_COLOR_HOST}${_LQ_HOST_SYMBOL}${LQ_RESET}"
    fi
    ;;
ssh)
    # If we want a different color for each host
    if [[ "$LQ_ENABLE_SSH_COLORS" -eq "1" ]]; then
        # compute the hash of the hostname
        # and get the corresponding number in [1-6] (red,green,yellow,blue,purple or cyan)
        # FIXME check portability of cksum and add more formats (bold? 256 colors?)
        hash=$(( 1 + $(hostname | cksum | cut -d " " -f 1) % 6 ))
        color=${_LQ_OPEN_ESC}$(ti_setaf $hash)${_LQ_CLOSE_ESC}
        LQ_HOST="${LQ_HOST}${color}${_LQ_HOST_SYMBOL}${LQ_RESET}"
        unset hash
        unset color
    else
        # the same color for all hosts
        LQ_HOST="${LQ_HOST}${LQ_COLOR_SSH}${_LQ_HOST_SYMBOL}${LQ_RESET}"
    fi
    ;;
su)
    LQ_HOST="${LQ_HOST}${LQ_COLOR_SU}${_LQ_HOST_SYMBOL}${LQ_RESET}"
    ;;
tel)
    LQ_HOST="${LQ_HOST}${LQ_COLOR_TELNET}${_LQ_HOST_SYMBOL}${LQ_RESET}"
    ;;
*)
    LQ_HOST="${LQ_HOST}${_LQ_HOST_SYMBOL}" # defaults to no color
    ;;
esac

# Useless now, so undefine
# unset _lq_connection


# put an arrow if an http proxy is set
source functions/_lq_proxy.zsh

# Function that shortens
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
source functions/_lq_shorten_path.zsh

# In bash shell, PROMPT_DIRTRIM is the number of directory to keep at the end
# of the displayed path (if "\w" is present in the PS1 var).
# liquidprompt can calculate this number under two condition, path shortening
# must be activated and PROMPT_DIRTRIM must be already set.
source functions/_lq_get_dirtrim.zsh

# Display a ":"
# colored in green if user have write permission on the current directory
# colored in red if it have not.
source functions/_lq_permissions_color.zsh

# Display the current Python virtual environnement, if available.
source functions/_lq_virtualenv.zsh


################
# Related jobs #
################

# Display the count of each if non-zero:
# - detached screens sessions and/or tmux sessions running on the host
# - attached running jobs (started with $ myjob &)
# - attached stopped jobs (suspended with Ctrl-Z)
source functions/_lq_jobcount_color.zsh


# Display the return value of the last command, if different from zero
source functions/_lq_return_value.zsh


######################
# VCS branch display #
######################

source functions/_lq_are_vcs_disabled.zsh

# GIT #

# Get the branch name of the current directory
source functions/_lq_git_branch.zsh

# Set a color depending on the branch state:
# - green if the repository is up to date
# - yellow if there is some commits not pushed
# - red if there is changes to commit
#
# Add the number of pending commits and the impacted lines.
source functions/_lq_git_branch_color.zsh


# MERCURIAL #

# Get the branch name of the current directory
source functions/_lq_hg_branch.zsh

# Set a color depending on the branch state:
# - green if the repository is up to date
# - red if there is changes to commit
# - TODO: yellow if there is some commits not pushed
source functions/_lq_hg_branch_color.zsh

# SUBVERSION #

# Get the branch name of the current directory
# For the first level of the repository, gives the repository name
source functions/_lq_svn_branch.zsh

# Set a color depending on the branch state:
# - green if the repository is clean
#   (use $LQ_SVN_STATUS_OPTS to define what that means with
#    the --depth option of 'svn status')
# - red if there is changes to commit
# Note that, due to subversion way of managing changes,
# informations are only displayed for the CURRENT directory.
source functions/_lq_svn_branch_color.zsh


# FOSSIL #

# Get the tag name of the current directory
source functions/_lq_fossil_branch.zsh

# Set a color depending on the branch state:
# - green if the repository is clean
# - red if there is changes to commit
# - yellow if the branch has no tag name
#
# Add the number of impacted files with a
# + when files are ADDED or EDITED
# - when files are DELETED
source functions/_lq_fossil_branch_color.zsh

# Bazaar #

# Get the branch name of the current directory
source functions/_lq_bzr_branch.zsh


# Set a color depending on the branch state:
# - green if the repository is up to date
# - red if there is changes to commit
# - TODO: yellow if there is some commits not pushed
#
# Add the number of pending commits and the impacted lines.
source functions/_lq_bzr_branch_color.zsh


##################
# Battery status #
##################

# Get the battery status in percent
# returns 0 (and battery level) if battery is discharging and under threshold
# returns 1 (and battery level) if battery is discharging and above threshold
# returns 2 (and battery level) if battery is charging but under threshold
# returns 3 (and battery level) if battery is charging and above threshold
# returns 4 if no battery support
source functions/_lq_battery.zsh

# Compute a gradient of background/foreground colors depending on the battery status
# Display:
# a  green ⏚ if the battery is charging    and above threshold
# a yellow ⏚ if the battery is charging    and under threshold
# a yellow ⌁ if the battery is discharging but above threshold
# a    red ⌁ if the battery is discharging and above threshold
source functions/_lq_battery_color.zsh

source functions/_lq_color_map.zsh

###############
# System load #
###############

# Compute a gradient of background/forground colors depending on the battery status
source functions/_lq_load_color.zsh

######################
# System temperature #
######################

source functions/_lq_temp_sensors.zsh

# Will set _lq_temp_function so the temperature monitoring feature use an
# available command. _lq_temp_function should return only a numeric value
if [[ "$LQ_ENABLE_TEMP" = 1 ]]; then
    if command -v sensors >/dev/null; then
        _lq_temp_function=_lq_temp_sensors
    # elif command -v the_command_you_want_to_use; then
    #   _lq_temp_function=your_function
    else
        LQ_ENABLE_TEMP=0
    fi
fi

source functions/_lq_temperature.zsh

##########
# DESIGN #
##########

# Remove all colors and escape characters of the given string and return a pure text
source functions/_lq_as_text.zsh

source functions/_lq_title.zsh

# Set the prompt mark to ± if git, to ☿ if mercurial, to ‡ if subversion
# to # if root and else $
source functions/_lq_smart_mark.zsh

# insert a space on the right
source functions/_lq_sr.zsh

# insert a space on the left
source functions/_lq_sl.zsh

# insert two space, before and after
source functions/_lq_sb.zsh

###################
# CURRENT TIME    #
###################
source functions/_lq_time_analog.zsh

source functions/_lq_time.zsh

########################
# Construct the prompt #
########################


source functions/_lq_set_prompt.zsh

source functions/prompt_tag.zsh

# Activate the liquid prompt
source functions/prompt_on.zsh

# Come back to the old prompt
source functions/prompt_off.zsh

# Use an empty prompt: just the \$ mark
source functions/prompt_default.zsh

# By default, sourcing liquid.zsh will activate Liquid
prompt_on

# Cleaning of variable that are not needed at runtime
unset LQ_OS

# Go back where we were
popd -q
#
# vim: set et sts=4 sw=4 tw=120 ft=sh:
