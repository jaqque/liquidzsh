Liquid -- An intelligent, adaptive and non-intrusive prompt for Zsh
================================================================================

Liquid gives you a nicely displayed prompt with useful information when you
need it. It shows you what you need when you need it. You will notice what
changes, when it changes saving time and frustration.

![Screenshot](https://raw.github.com/jaqque/liquidzsh/master/demo.png)


## FEATURES

If there is nothing special in the current context, Liquid's prompt is close
to a default prompt:

`[user:~] % `

If you are running a command in the background that is still running and you
are in a git repository on a server, on branch "myb":

`1r [user@server:~/liquidzsh] myb ± `

Liquid displaying everything (a rare event!) may look like this:

`code 🕤  ⌁24% ⌂42% 3d/2&/1z [user@server:~/ … /code/liquidzsh][pyenv]↥ master(+10/-5,3)*+ 125 ± `

It (may) displays:

* A tag associated to the current shell session (you can easily add any prefix
tag to your prompt, by invoking `prompt_tag MYTAG`)
* The current time, either as numeric values or an analog clock
* a green ⏚ if the battery is charging, above the given threshold, but not
charged, a yellow ⏚ if the battery is charging and under threshold, a yellow ⌁
if the battery is discharging but above threshold, a  red ⌁ if the battery is
discharging and under threshold
* the average of the batteries' remaining power, if it is under the given
threshold, with a colormap, going more and more red with decreasing power
* the average of the processors load, if it is over a given limit, with a
colormap that becomes more and more noticeable with increasing load
* the average temperature of the available sensors in the system (generally
CPU and MB)
* the number of detached sessions (`screen` or `tmux`), if there are any
* the number of attached sleeping jobs (when you interrupt a command with
Ctrl-Z and bring it back with `fg`), if there are any
* the number of attached running jobs (commands started with a `&`), if there
are any
* a pair of square brackets, in blue if your current shell is running in a
terminal multiplexer (`screen` or `tmux`)
* the current user, in bold yellow if it is root, in light white if it is not
the same as the login user
* a green @ if the connection has X11 support, a yellow one if not
* the current host, if you are connected via a telnet connection (in bold red)
or SSH (either a blue hostname or different colors for different hosts)
* a green colon if the user has write permissions on the current directory,
a red one if he has not
* the current directory in bold, shortened if it takes too much space, while
preserving the first two directories
* the current Python virtual environment, if any
* an up arrow if an HTTP proxy is in use
* the name of the current branch if you are in a version control repository
(git, mercurial, subversion, bazaar or fossil), in green if everything is up
to date, in red if there are changes, in yellow if there are pending
commits to push
* the number of added/deleted lines (git) or files (fossil), if
changes have been made and the number of pending commits, if any
* a yellow plus if there is stashed modifications
* a red star if there is some untracked files in the repository
* the error code of the last command, if it has failed in some way
* a smart mark: ± for git directories, ☿ for mercurial, ‡ for svn,
‡± for git-svn, ⌘ for fossil, $ or % for simple user, a red # for root
* if you ask, Liquid will be replicate your prompt to your terminal window's
title (without the colors)

You can temporarily deactivate Liquid and come back to your previous prompt by
typing `prompt_off`. Use `prompt_on` to bring it back. You can deactivate any
prompt and use a single mark sign (`% ` for user and `# ` for root) with the
`prompt_default` command.


## TEST RIDE AND INSTALLATION

Installation is simple. The basic dependencies are standard available on Unix.
Please check if they are met if you experience some problems during the
installation. See the DEPENDENCIES section for what you need.

Follow these steps:

`cd ~`
`git clone https://github.com/jaqque/liquidzsh.git`
`source liquidzsh/liquid.zsh`

To use it everytime you start a shell add the following line to your
`.zshrc`:

`source ~/liquidzsh/liquid.zsh`

Next up is the configuration, you can skip this step if you already like the
defaults:

`cp ~/liquidzsh/sample-liquid.rc ~/.config/liquid.rc`

You can also copy the file to `~/.liquidrc`.

Use your favorite text editor to change the defaults.
The `sample-liquid.rc` file is richly commented and easy to set your own
defaults. You can even theme Liquid and have a custom PS1. This is explained
in the sections below.


## DEPENDENCIES

Apart from obvious ones, some features depends on specific commands. If you
lack them, the corresponding feature will be silently disabled.

* battery status needs `acpi`.
* temperature status needs `lm-sensors`.
* detached sessions is looking for `screen` and/or `tmux`.
* VCS support features needs `bzr`, `fossil`, `git`, `hg` or `svn`.

For other features, the script uses commands that should be available on a
large variety of unixes: `grep`, `awk`, `sed`, `ps`, `who`.


## FEATURES CONFIGURATION

You can configure some variables in the `~/.config/liquid.rc` file:

* `LQ_BATTERY_THRESHOLD`, the maximal value under which the battery level is
displayed
* `LQ_LOAD_THRESHOLD`, the minimal value after which the load average is
displayed
* `LQ_TEMP_THRESHOLD`, the minimal value after which the temperature average
is displayed
* `LQ_PATH_LENGTH`, the maximum percentage of the screen width used to display
the path
* `LQ_PATH_KEEP`, how many directories to keep at the beginning of a shortened
path
* `LQ_HOSTNAME_ALWAYS`, choose between always displaying the hostname or
showing it only when connected with a remote shell
* `LQ_USER_ALWAYS`, choose between always displaying the user or showing
it only when he is different from the logged one

You can also force some features to be disabled, to save some time in the
prompt building:
* `LQ_ENABLE_PERM`, if you want to detect if the directory is writable
* `LQ_ENABLE_SHORTEN_PATH`, if you want to shorten the path display
* `LQ_ENABLE_PROXY`, if you want to detect if a proxy is used
* `LQ_ENABLE_JOBS`, if you want to have jobs informations
* `LQ_ENABLE_LOAD`, if you want to have load informations
* `LQ_ENABLE_BATT`, if you want to have battery informations
* `LQ_ENABLE_GIT`, if you want to have git informations
* `LQ_ENABLE_SVN`, if you want to have subversion informations
* `LQ_ENABLE_HG`, if you want to have mercurial informations
* `LQ_ENABLE_BZR`, if you want to have bazaar informations
* `LQ_ENABLE_FOSSIL`, if you want to have fossil informations
* `LQ_ENABLE_VCS_ROOT`, if you want to show VCS informations with root account
* `LQ_ENABLE_TITLE`, if you want to use the prompt as your terminal window's
title
* `LQ_ENABLE_SCREEN_TITLE`, if you want to use the prompt as your screen
window's title
* `LQ_ENABLE_SSH_COLORS`, if you want different colors for hosts you SSH in
* `LQ_ENABLE_TIME`, if you want to display the time at which the prompt was
shown
* `LQ_TIME_ANALOG`, when showing time, use an analog clock instead of numeric
values

Note that if required dependencies are missing, enabling the
corresponding feature will lack effect.
Note also that all the `LQ_ENABLE_…` variables override the templates,
e.g. if you use `$LQ_BATT` in your template and you set `LQ_ENABLE_BATT=0`
in your config file, Liquid will be devoid of battery information.

You may face performances decrease when using VCS located in remote
directories. To avoid that, you can set the `LQ_DISABLED_VCS_PATH` variable
to a list of absolute and colon (":") separated paths where VCS-related
features will be disabled.


## CUSTOMIZING THE PROMPT

### ADD A PREFIX/POSTFIX

You can prefix the `LQ_PS1` variable with anything you want using the
`LQ_PS1_PREFIX`. The following example activate a custom window's title:

    LQ_PS1_PREFIX="\[\e]0;\u@\h: \w\a\]"

To postfix the prompt, use the `LQ_PS1_POSTFIX` variable. For example, to add
a newline and a single character:

    LQ_PS1_POSTFIX="\n>"

Note: the `prompt_tag` function is convenient way to add a prefix. You can
thus add a keyword to your different terminals:

    [:~/code/liquidprompt] develop ± prompt_tag mycode
    mycode [:~/code/liquidprompt] develop ±

### PUT THE PROMPT IN A DIFFERENT ORDER

You can sort what you want to see by sourcing your favorite template file
(`*.ps1`) in the configuration file.

You can start from the `sample-liquid.ps1` file, which show the default
settings. To use your own configuration, just set `LQ_PS1_FILE` to your own
file path in your `~/.config/liquid.rc` and you're done.

Those scripts basically export the `LQ_PS1` variable, by appending features
and theme colors.

Available features:
* `LQ_BATT` battery
* `LQ_LOAD` load
* `LQ_TEMP` temperature
* `LQ_JOBS` detached screen or tmux sessions/running jobs/suspended jobs
* `LQ_USER` user
* `LQ_HOST` hostname
* `LQ_PERM` a colon ":"
* `LQ_PWD` current working directory
* `LQ_PROXY` HTTP proxy
* `LQ_VCS` informations concerning the current working repository
* `LQ_ERR` last error code
* `LQ_MARK` prompt mark
* `LQ_TITLE` the prompt as a window's title escaped sequences
* `LQ_BRACKET_OPEN` and `LQ_BRACKET_CLOSE`, brackets enclosing the user+path
part

For example, if you just want to have liquid displaying the user and the
host, with a normal full path in blue and only the git support:

    export LQ_PS1=`echo -ne "[\${LQ_USER}\${LQ_HOST}:\${BLUE}\$(pwd)\${LQ_RESET}] \${LQ_GIT} \\\$ "`

Note that you need to properly escape percent signs in a string that will be
interpreted by zsh at each prompt.

To erase your new formatting, just bring the `LQ_PS1` to a null string:

     export LQ_PS1=""


## THEMES

You can change the colors and special characters of some part of liquid by
sourcing your favorite theme file (`*.theme`) in the configuration file.

### COLORS

Available colors are:
* BOLD
* BLACK, GRAY, WHITE, BRIGHT_WHITE
* PINK
* PURPLE,
* BLUE, BRIGHT_BLUE
* CYAN, BRIGHT_CYAN
* GREEN, BRIGHT_GREEN
* YELLOW, BRIGHT_YELLOW
* RED, BRIGHT_RED
* WARNING, DANGER, CRITICAL

You can also use the `$fg[*]`, `$fg_bold[*]`, `$bg[*]`, `$bg_bold[*]` colors
as well, but be certain to wrap them in `%{%}`:

`LQ_COLOR_SSH="%{$bg[blue]$fg_bold[black]%}`

Set to a null string '' if you do not want color.

* Current working directory
    * `LQ_COLOR_PATH` as normal user
    * `LQ_COLOR_PATH_ROOT` as root
* Color of the proxy mark
    * `LQ_COLOR_PROXY`
* Jobs count
    * `LQ_COLOR_JOB_D` Detached (screen/tmux sessions without attached
clients)
    * `LQ_COLOR_JOB_R` Running (xterm &)
    * `LQ_COLOR_JOB_Z` Sleeping (Ctrl-Z)
    * `LQ_COLOR_IN_MULTIPLEXER` currently running in a terminal multiplexer
* Last error code
    * `LQ_COLOR_ERR`
* Prompt mark
    * `LQ_COLOR_MARK` as user
    * `LQ_COLOR_MARK_ROOT` as root
* Current user
    * `LQ_COLOR_USER_LOGGED` user who logged in
    * `LQ_COLOR_USER_ALT` user but not the one who logged in
    * `LQ_COLOR_USER_ROOT` root
* Hostname
    * `LQ_COLOR_HOST` local host
    * `LQ_COLOR_SSH` connected via SSH
    * `LQ_COLOR_TELNET` connected via telnet
    * `LQ_COLOR_X11_ON` connected with X11 support
    * `LQ_COLOR_X11_OFF` connected without X11 support
* Separation mark (by default, the colon before the path)
    * `LQ_COLOR_WRITE` have write permission
    * `LQ_COLOR_NOWRITE` do not have write permission
* VCS
    * `LQ_COLOR_UP` repository is up to date / a push have been made
    * `LQ_COLOR_COMMITS` some commits have not been pushed
    * `LQ_COLOR_CHANGES` there is some changes to commit
    * `LQ_COLOR_DIFF` number of lines or files impacted by current changes
* Battery
    * `LQ_COLOR_CHARGING_ABOVE` charging and above threshold
    * `LQ_COLOR_CHARGING_UNDER` charging but under threshold
    * `LQ_COLOR_DISCHARGING_ABOVE` discharging but above threshold
    * `LQ_COLOR_DISCHARGING_UNDER` discharging and under threshold

### CHARACTERS

Special characters:
* `LQ_MARK_DEFAULT` (default: "") the mark you want at the end of your prompt
(leave to empty for default mark)
* `LQ_MARK_BATTERY` (default: "⌁") in front of the battery charge
* `LQ_MARK_ADAPTER` (default: "⏚") displayed when plugged
* `LQ_MARK_LOAD` (default: "⌂") in front of the load
* `LQ_MARK_PROXY` (default: "↥") indicate a proxy in use
* `LQ_MARK_HG` (default: "☿") prompt mark in hg repositories
* `LQ_MARK_SVN` (default: "‡") prompt mark in svn repositories
* `LQ_MARK_GIT` (default: "±") prompt mark in git repositories
* `LQ_MARK_FOSSIL` (default: "⌘") prompt mark in fossil repositories
* `LQ_MARK_BZR` (default: "⚯") prompt mark in bazaar repositories
* `LQ_MARK_DISABLED` (default: "⌀") prompt mark in disabled repositories (see
`LQ_DISABLED_VCS_PATH`)
* `LQ_MARK_UNTRACKED` (default: "*") if git has untracked files
* `LQ_MARK_STASH` (default: "+") if git has stashed modifications
* `LQ_MARK_BRACKET_OPEN` (default: "[") marks around the main part of the prompt
* `LQ_MARK_BRACKET_CLOSE` (default: "]") marks around the main part of the
prompt
* `LQ_TITLE_OPEN` (default: "\e]0;") escape character opening a window's title
* `LQ_TITLE_CLOSE` (default: "\a") escape character closing a window's title
* `LQ_SCREEN_TITLE_OPEN` (default: "\033k") escape character opening screen
window's title
* `LQ_SCREEN_TITLE_CLOSE` (default: "\033\134") escape character closing
screen window's title


## KNOWN LIMITATIONS AND BUGS

Liquid is distributed under the GNU Affero General Public License version 3.

* Does not display the number of commits to be pushed in Mercurial
repositories.
* Browsing into very large subversion repositories may dramatically slow down
the display of the liquid prompt (use `LQ_DISABLED_VCS_PATH` to avoid that).
* Subversion repository cannot display commits to be pushed, this is a
limitation of the Subversion versionning model.
* The proxy detection only uses the `$http_proxy` environment variable.
* The window's title escape sequence may not work properly on some terminals
(like xterm-256)
* The analog clock necessitate a unicode-aware terminal and a sufficiently
complete font.

## AUTHORS

Liquid is based on nojhan's [Liquid prompt] [LP].

* [Alex Prengère]     (<mailto:alexprengere@gmail.com>      "untracked git files")
* [Aurelien Requiem]  (<mailto:aurelien@requiem.fr>         "Major clean refactoring, variable path length, error codes, several bugfixes.")
* [Brendan Fahy]      (<bmailto:mfahy@gmail.com>            "postfix variable")
* [Clément Mathieu]   (<mailto:clement@unportant.info>      "Bazaar support")
* [David Loureiro]    (<mailto:david.loureiro@sysfera.com>  "small portability fix")
* [Étienne Deparis]   (<mailto:etienne.deparis@umaneti.net> "Fossil support")
* [Florian Le Frioux] (<mailto:florian@lefrioux.fr>         "Use ± mark when root in VCS dir.")
* [François Schmidts] (<mailto:francois.schmidts@gmail.com> "small code fix, _lq_get_dirtrim")
* [Frédéric Lepied]   (<mailto:flepied@gmail.com>           "Python virtual env")
* [Jonas Bengtsson]   (<mailto:jonas.b@gmail.com>           "Git remotes fix")
* [Joris Dedieu]      (<mailto:joris@pontiac3.nfrance.com>  "Portability framework, FreeBSD support, bugfixes.")
* [Joris Vaillant]    (<mailto:joris.vaillant@gmail.com>    "small git fix")
* [Luc Didry]         (<mailto:luc@fiat-tux.fr>             "Zsh port, several fix")
* [Ludovic Rousseau]  (<mailto:ludovic.rousseau@gmail.com>  "Lot of bugfixes.")
* [Nicolas Lacourte]  (<mailto:nicolas@dotinfra.fr>         "screen title")
* [nojhan]            (<mailto:nojhan@gmail.com>            "Main author.")
* [Olivier Mengué]    (<mailto:dolmen@cpan.org>             "Major optimizations and refactorings everywhere.")
* [Poil]              (<mailto:poil@quake.fr>               "speed improvements")
* [Thomas Debesse]    (<mailto:thomas.debesse@gmail.com>    "Fix columns use.")
* [Yann 'Ze' Richard] (<mailto:ze@nbox.org>                 "Do not fail on missing commands.")

[LP]: https://github.com/nojhan/liquidprompt (A full-featured & carefully
designed adaptive prompt for Bash & Zsh)
