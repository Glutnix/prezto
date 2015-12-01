# Usage:
# source iterm2.zsh

# Return if requirements are not found.
if [[ "$OSTYPE" != (darwin)* ]]; then
  return 1
fi

# iTerm2 tab color commands
# http://code.google.com/p/iterm2/wiki/ProprietaryEscapeCodes

if [[ -n "$ITERM_SESSION_ID" ]]; then
    tab-color() {
        echo -ne "\033]6;1;bg;red;brightness;$1\a"
        echo -ne "\033]6;1;bg;green;brightness;$2\a"
        echo -ne "\033]6;1;bg;blue;brightness;$3\a"
    }
    tab-red() { tab-color 255 0 0 }
    tab-green() { tab-color 128 255 128 }
    tab-orange() { tab-color 255 128 0 }
    tab-blue() { tab-color 128 128 255 }
    tab-reset() { echo -ne "\033]6;1;bg;*;default\a" }

    function iterm2_tab_precmd() {
        tab-reset
    }

    function iterm2_tab_preexec() {
        if [[ "$1" =~ "^ssh " ]]; then
            if [[ "$1" =~ "prod" ]]; then
                tab-red
            else
                tab-blue
            fi
        elif [[ "$1" =~ "^sudo " ]] || [[ "$USER" = "root" ]]; then
            tab-red
        elif [[ "$1" =~ "^vagrant ssh" ]]; then
            tab-orange
        else
            tab-color 92 92 92
        fi
    }

    autoload -U add-zsh-hook
    add-zsh-hook precmd  iterm2_tab_precmd
    add-zsh-hook preexec iterm2_tab_preexec
fi
