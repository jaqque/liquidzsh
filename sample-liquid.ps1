
#######################################
# LIQUID PROMPT DEFAULT TEMPLATE FILE #
#######################################

# Available features:
# LQ_BATT battery
# LQ_LOAD load
# LQ_JOBS screen sessions/running jobs/suspended jobs
# LQ_USER user
# LQ_HOST hostname
# LQ_PERM a colon ":"
# LQ_PWD current working directory
# LQ_PROXY HTTP proxy
# LQ_VCS the content of the current repository
# LQ_ERR last error code
# LQ_MARK prompt mark
# LQ_TIME current time
# LQ_PS1_PREFIX user-defined general-purpose prefix (default set a generic prompt as the window title)

# Remember that most features come with their corresponding colors,
# see the README.

# add time, jobs, load and battery
LQ_PS1="${LQ_PS1_PREFIX}${LQ_TIME}${LQ_BATT}${LQ_LOAD}${LQ_JOBS}"
# add user, host and permissions colon
LQ_PS1="${LQ_PS1}[${LQ_USER}${LQ_HOST}${LQ_PERM}"

# if not root
if [[ "$EUID" -ne "0" ]]
then
    # path in foreground color
    LQ_PS1="${LQ_PS1}${LQ_PWD}]${LQ_VENV}${LQ_PROXY}"
    # add VCS infos
    LQ_PS1="${LQ_PS1}${LQ_VCS}"
else
    # path in yellow
    LQ_PS1="${LQ_PS1}${LQ_PWD}]${LQ_VENV}${LQ_PROXY}"
    # do not add VCS infos unless told otherwise (LQ_ENABLE_VCS_ROOT)
    [[ "$LQ_ENABLE_VCS_ROOT" = "1" ]] && LQ_PS1="${LQ_PS1}${LQ_VCS}"
fi
# add return code and prompt mark
LQ_PS1="${LQ_PS1}${LQ_ERR}${LQ_MARK}"

# "invisible" parts
# Get the current prompt on the fly and make it a title
LQ_TITLE=$(_lq_title $PS1)

# Insert it in the prompt
PS1="${LQ_TITLE}${PS1}"

# vim: set et sts=4 sw=4 tw=120 ft=sh:
