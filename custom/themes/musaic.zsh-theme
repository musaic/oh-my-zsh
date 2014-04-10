#!/usr/bin/env zsh (Warning: DO NOT EXECUTE)
# -----------------------------------------------------------------------------
#          FILE: dogenpunk.zsh-theme
#   DESCRIPTION: oh-my-zsh theme file.
#        AUTHOR: Matthew Nelson (dogenpunk@gmail.com)
#       VERSION: 0.1
#    SCREENSHOT: coming soon
# -----------------------------------------------------------------------------

MODE_INDICATOR="%{$fg_bold[red]%}❮%{$reset_color%}%{$fg[red]%}❮❮%{$reset_color%}"
local return_status="%{$fg[red]%}%(?..⏎ )%{$reset_color%}"
local user_status="%{$fg[blue]%}%(#.root.%n)%{$reset_color%}"


#ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}git%{$reset_color%}@%{$bg[cyan]%}%{$fg[black]%}"
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[yellow]$bg[black]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""


ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}🄳 "
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%}🄼 "
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[green]%}🄰 "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}🅄🅃 "
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%}🅁 "
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%}🅄🄼 "

function prompt_char() {
  git branch >/dev/null 2>/dev/null && echo "%{$fg[green]%}±%{$reset_color%}" && return
  hg root >/dev/null 2>/dev/null && echo "%{$fg_bold[red]%}☿%{$reset_color%}" && return
  echo "%{$fg[cyan]%}◯%{$reset_color%}"
}

# Colors vary depending on time lapsed.
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[green]%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[yellow]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[red]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$fg[cyan]%}"

# Determine the time since last commit. If branch is clean,
# use a neutral color, otherwise colors will vary according to time.
function git_time_since_commit() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        # Only proceed if there is actually a commit.
        if [[ $(git log 2>&1 > /dev/null | grep -c "^fatal: bad default revision") == 0 ]]; then
            # Get the last commit.
            last_commit=`git log --pretty=format:'%at' -1 2> /dev/null`
            now=`date +%s`
            seconds_since_last_commit=$((now-last_commit))

            # Totals
            MINUTES=$((seconds_since_last_commit / 60))
            HOURS=$((seconds_since_last_commit/3600))

            # Sub-hours and sub-minutes
            DAYS=$((seconds_since_last_commit / 86400))
            SUB_HOURS=$((HOURS % 24))
            SUB_MINUTES=$((MINUTES % 60))

            if [[ -n $(git status -s 2> /dev/null) ]]; then
                if [ "$MINUTES" -gt 30 ]; then
                    COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG"
                elif [ "$MINUTES" -gt 10 ]; then
                    COLOR="$ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM"
                else
                    COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT"
                fi
            else
                COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
            fi

            if [ "$HOURS" -gt 24 ]; then
                echo "($COLOR${DAYS}d${SUB_HOURS}h${SUB_MINUTES}m%{$reset_color%})"
            elif [ "$MINUTES" -gt 60 ]; then
                echo "($COLOR${HOURS}h${SUB_MINUTES}m%{$reset_color%})"
            else
                echo "($COLOR${MINUTES}m%{$reset_color%})"
            fi
        else
            COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
            echo "($COLOR~)"
        fi
    fi
}

PROMPT='%{$fg[yellow]%}%m ($OSTYPE) %{$fg[cyan]%}%3~%{$reset_color%}%(#.%{$fg_bold[yellow]%}.%{$fg_bold[white]%}) ओम् %{$fg_bold[black]%}%D{[%F %X]}%{$reset_color%} %{$reset_color%}
$(git_time_since_commit)[$(git_prompt_info)]$user_status $(prompt_char) '


RPROMPT='${return_status}$(git_prompt_status)%{$reset_color%}'

PS4='%{$reset_color%}+ %F{cyan}%3N%f    %F{yellow}%I:%f %(?.%F{cyan}%_%f.%F{red}%_ %(returned %?%f%) %{$reset_color%}\'
