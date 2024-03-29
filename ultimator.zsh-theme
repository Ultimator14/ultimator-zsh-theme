#
# Ultimator ZSH theme
#
#
# Requirements:
# -------------
# 1. A Powerline patched font
# 2. zsh-git prompt
#
# The basic structure is taken from the agnoster theme
# Zsh-git-prompt is required for the git_super_status command
#
#
# License:
# --------
# MIT
#
#
# Links:
# ------
# - https://github.com/powerline/fonts
# - https://github.com/Ultimator14/zsh-git-prompt
# - https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/agnoster.zsh-theme
# - https://github.com/dbestevez/agitnoster-theme
#

# Arrow character from agnoster theme
SEGMENT_SEPARATOR=${SEGMENT_SEPARATOR:-'%{\Ue0b0%G%}'}		# arrow
#SEGMENT_SEPARATOR='%{\Ue0b4%G%}'				# round
#SEGMENT_SEPARATOR='%{\Ue0bc%G%}'				# diagonal
#SEGMENT_SEPARATOR='%{\Ue0b8%G%}'				# diagonal2
#SEGMENT_SEPARATOR='%{\Ue0cc%G%}'				# hectagon
R_SEGMENT_SEPARATOR=${R_SEGMENT_SEPARATOR:-'%{\Ue0b2%G%}'}	# inverse arrow


# Variable holding the current background color to connect segments
CURRENT_BG_COLOR="default"

# Variables customizable by the user
# If null, replace with defaults
COLOR_USER=${COLOR_USER:-'red'}
COLOR_AT=${COLOR_AT:-'green'}
COLOR_COMPUTER=${COLOR_COMPUTER:-'blue'}
COLOR_DIR=${COLOR_DIR:-'blue'}

COLOR_USER_ROOT=${COLOR_USER_ROOT:-'red'}
COLOR_AT_ROOT=${COLOR_AT_ROOT:-'red'}
COLOR_COMPUTER_ROOT=${COLOR_COMPUTER_ROOT:-'red'}
COLOR_DIR_ROOT=${COLOR_DIR_ROOT:-'red'}

#
# Helper functions
#

prompt_start() {
    # start a new prompt with given background
    # $1 = background
    echo -n "%{$bg[$1]%}"
    CURRENT_BG_COLOR="$1"
}

prompt_segment_transition() {
    # segment prompt with new segment being the default color
    # (used at the end of the segments)
    # IMPORTANT: transition to default is not possible between segments
    echo -n "%{$fg_no_bold[${CURRENT_BG_COLOR}]%}%{$bg[$1]%}${SEGMENT_SEPARATOR}"
    CURRENT_BG_COLOR="$1"
}

rprompt_segment_transition() {
    # segment prompt with new segment being the default color
    # (used at the end of the segments)
    # IMPORTANT: transition to default is not possible between segments
    echo -n "%{$fg_no_bold[$1]%}%{$bg[${CURRENT_BG_COLOR}]%}${R_SEGMENT_SEPARATOR}"
    CURRENT_BG_COLOR="$1"
    echo -n "%{$bg[$1]%}"
}

prompt_reset_color() {
    CURRENT_BG_COLOR="default"
    echo -n "%{$reset_color%}"
}

prompt_space() {
    echo -n " "
}

#
# Prompt functions
#

prompt_ret_status() {
    # Last command evaluation
    # $1 = success color
    # $2 = failure color
    # $3 = success char
    # $4 = failure char
    echo -n "%(?:%{$fg_bold[$1]%} $3 :%{$fg_bold[$2]%} $4 %? )"
}

prompt_ret_status2() {
    # Last command evaluation alternative for end of shell
    # $1 = success color
    # $2 = failure color
    echo -n "%(?:%{$fg_bold[$1]%}:%{$fg_bold[$2]%})$"
}

prompt_main() {
    # Main Prompt fg creation (user@computername)
    # $1 = username foreground
    # $2 = at foreground
    # $3 = computername foreground
    echo -n "%{$fg_bold[$1]%}%n%{$fg_bold[$2]%}@%{$fg_bold[$3]%}%m"
}

prompt_dir() {
    # Dir prompt creation
    # $1 = foreground
    echo -n "%{$fg_no_bold[$1]%} %(5~|.../%3~|%~) "
}

prompt_git() {
    # Git color shortcuts
    # $1 = foreground
    # $2 = background
    local git_colors="%{$fg_no_bold[$1]%}%{$bg[$2]%}"

    # Set git variables
    ZSH_THEME_GIT_PROMPT_PREFIX="${git_colors} %{\Uf126%G%} "   # branch (alternative e010 or e0a0)
    ZSH_THEME_GIT_PROMPT_SUFFIX="${git_colors} "
    ZSH_THEME_GIT_PROMPT_DIRTY="${git_colors}%{\Uf00d%G%}"      # x
    ZSH_THEME_GIT_PROMPT_CLEAN="${git_colors}%{\Uf00c%G%}"      # checkmark
    ZSH_THEME_GIT_PROMPT_BRANCH="${git_colors}"
    ZSH_THEME_GIT_PROMPT_SEPARATOR="${git_colors}|"
    ZSH_THEME_GIT_PROMPT_UNTRACKED="${git_colors}%{\Uf01d8%G%}" # dots
    ZSH_THEME_GIT_PROMPT_CHANGED="${git_colors}%{\Uf0766%G%}"   # empty circle
    ZSH_THEME_GIT_PROMPT_STAGED="${git_colors}%{\Uf0765%G%}"    # full circle
    ZSH_THEME_GIT_PROMPT_CONFLICTS="${git_colors}%{\Uf0e7%G%}"  # flash
    ZSH_THEME_GIT_PROMPT_AHEAD="${git_colors}%{\Uf176%G%}"      # arrow up
    ZSH_THEME_GIT_PROMPT_BEHIND="${git_colors}%{\Uf175%G%}"     # arrow down

    git_super_status
}

prompt_virtualenv() {
    # $1 = foreground
    # $2 = symbol
    # from https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/virtualenv/virtualenv.plugin.zsh
    if [[ -n $VIRTUAL_ENV ]]; then
        # https://zsh.sourceforge.io/Doc/Release/Expansion.html#Modifiers
        # same as basename $VIRTUAL_ENV | <replace % with %%>
        echo -n "%{$fg_no_bold[$1]%} %{$2%G%} ${VIRTUAL_ENV:t:gs/%/%%} "
    fi
}

prompt_jobs() {
    # $1 = foreground
    # $2 = running jobs symbol
    # $3 = suspended jobs symbol
    local running_jobs=$(jobs -r | wc -l)
    local suspended_jobs=$(jobs -s | wc -l)
    if [ $running_jobs -gt 0 ] || [ $suspended_jobs -gt 0 ]
    then
        echo -n "%{$fg_no_bold[$1]%} %{$2%G%}$running_jobs %{$3%G%}$suspended_jobs "
    fi
}

#
# Set prompt
#
build_prompt() {
    # change colors if user is root
    if [ $(id -u) -eq 0 ]; then
        # colors for main prompt
        local color_user_fg="$COLOR_USER_ROOT"
        local color_at_fg="$COLOR_AT_ROOT"
        local color_computer_fg="$COLOR_COMPUTER_ROOT"

        # colors for dir prompt
        local color_dir_bg="$COLOR_DIR_ROOT"
    else
        # colors for main prompt
        local color_user_fg="$COLOR_USER"
        local color_at_fg="$COLOR_AT"
        local color_computer_fg="$COLOR_COMPUTER"

        # colors for dir prompt
        local color_dir_bg="$COLOR_DIR"
    fi

    # user@computer
    prompt_start "black"
    prompt_main "${color_user_fg}" "${color_at_fg}" "${color_computer_fg}"
    prompt_space

    # dir
    prompt_segment_transition "${color_dir_bg}"
    prompt_dir "black"

    # jobs
    local jobs_output=$(prompt_jobs "black" "\Uf28d" "\Uf28e")
    if [ ! -z $jobs_output ]
    then
        # jobs has output
        prompt_segment_transition "magenta"
        echo -n "$jobs_output"
    fi

    # virtualenv
    local venv_output=$(prompt_virtualenv "black" "\Ue235")
    if [ ! -z $venv_output ]
    then
        # venv has output
        prompt_segment_transition "green"
        echo -n "$venv_output"
    fi

    # git
    git_output=$(prompt_git "black" "yellow")
    if [ ! -z $git_output ]
    then
        # git has output
        prompt_segment_transition "yellow"
        echo -n "$git_output"
    fi

    # prompt end
    prompt_segment_transition "default"
    prompt_reset_color
    prompt_space

    # ret_status2
    prompt_ret_status2 "green" "red"
    prompt_reset_color
    prompt_space
}

build_prompt2() {
    # change colors if user is root
    if [ $(id -u) -eq 0 ]; then
        # colors for main prompt
        local color_user_fg="$COLOR_USER_ROOT"
        local color_at_fg="$COLOR_AT_ROOT"
        local color_computer_fg="$COLOR_COMPUTER_ROOT"

        # colors for dir prompt
        local color_dir_bg="$COLOR_DIR_ROOT"
    else
        # colors for main prompt
        local color_user_fg="$COLOR_USER"
        local color_at_fg="$COLOR_AT"
        local color_computer_fg="$COLOR_COMPUTER"

        # colors for dir prompt
        local color_dir_bg="$COLOR_DIR"
    fi

    # ret_status
    prompt_start "white"
    prompt_ret_status "green" "red" "\Uf00c" "\Uf00d"

    # user@computer
    prompt_segment_transition "black"
    prompt_space
    prompt_main "${color_user_fg}" "${color_at_fg}" "${color_computer_fg}"
    prompt_space

    # dir
    prompt_segment_transition "${color_dir_bg}"
    prompt_dir "black"

    # jobs
    local jobs_output=$(prompt_jobs "black" "\Uf28d" "\Uf28e")
    if [ ! -z $jobs_output ]
    then
        # jobs has output
        prompt_segment_transition "magenta"
        echo -n "$jobs_output"
    fi

    # virtualenv
    local venv_output=$(prompt_virtualenv "black" "\Ue235")
    if [ ! -z $venv_output ]
    then
        # venv has output
        prompt_segment_transition "green"
        echo -n "$venv_output"
    fi

    # git
    local git_output=$(prompt_git "black" "yellow")
    if [ ! -z $git_output ]
    then
        # git has output
        prompt_segment_transition "yellow"
        echo -n "$git_output"
    fi

    # prompt end
    prompt_segment_transition "default"
    prompt_reset_color
    prompt_space
}

#
# Rprompt functions
#

rprompt_ssh() {
    # $1 = foreground
    echo -n "%{$fg_no_bold[$1]%}ssh"
}

rprompt_sudo() {
    # $1 = foreground
    echo -n "%{$fg_no_bold[$1]%}${SUDO_USER}@%m"
}

#
# Set right prompt
#
build_rprompt() {
	local num_sshd=$(pstree -s -p $$ | grep -c '\-sshd(')

    if [[ $num_sshd > 0 ]] || [[ -n "${SUDO_USER}${SUDO_UID}${SUDO_GID}" ]]
    then
        # sudo is either ssh or sudo. Show rprompt
            if [[ -n "${SUDO_USER}${SUDO_UID}${SUDO_GID}" ]]
            then
                # shell is sudo. Start with sudo prompt
                rprompt_segment_transition "bright-gray"
                prompt_space
                rprompt_sudo "yellow"
                prompt_space
            fi

			if [[ $num_sshd > 0 ]]
            then
                rprompt_segment_transition "cyan"
                prompt_space
                rprompt_ssh "black"
                prompt_space
            fi

        prompt_reset_color
    fi
}

# Set theme
if [ "$ZSH_THEME" = "ultimator" ]
then
    # Default prompt
    PROMPT='$(build_prompt)'

    # Clear rprompt
    RPROMPT=''

    # Disable automatic prompt alteration in virtual envs
    # (venv display is handled by this theme)
    VIRTUAL_ENV_DISABLE_PROMPT="1"
elif [ "$ZSH_THEME" = "ultimator2" ]
then
    # Alternatively with error status at the beginning
    PROMPT='$(build_prompt2)'

    # Clear rprompt
    RPROMPT=''

    # Disable automatic prompt alteration in virtual envs
    # (venv display is handled by this theme)
    VIRTUAL_ENV_DISABLE_PROMPT="1"
elif [ "$ZSH_THEME" = "ultimator3" ]
then
    # Alternatively with error status at the beginning
    PROMPT='$(build_prompt2)'

    # Set rprompt
    RPROMPT='$(build_rprompt)'

    # Disable automatic prompt alteration in virtual envs
    # (venv display is handled by this theme)
    VIRTUAL_ENV_DISABLE_PROMPT="1"
fi
