#
# Sets Prezto options.
#
# Authors:
#   Brett Taylor <brett@webfroot.co.nz>
#   Wade Simmons <wade@wades.im>
#
#
# iTerm2 tab color commands
# http://code.google.com/p/iterm2/wiki/ProprietaryEscapeCodes

if [[ -n "$ITERM_SESSION_ID" ]]; then

  function tab-color() {
    echo -ne "\033]6;1;bg;red;brightness;$1\a"
    echo -ne "\033]6;1;bg;green;brightness;$2\a"
    echo -ne "\033]6;1;bg;blue;brightness;$3\a"
  }

  tab-danger()  { tab-color 255 0 0 } # red
  tab-warning() { tab-color 255 128 0 } # orange
  tab-safe()    { tab-color 128 255 128 } # lime
  tab-info()    { tab-color 135 206 250 } # lightblue
  tab-other()   { tab-color 105 105 105 } # dimgrey
  tab-reset()   { echo -ne "\033]6;1;bg;*;default\a" }

  function iterm2_tabs_precmd() {
    tab-reset
  }

  function iterm2_tabs() {
    if [[ "$1" =~ "$2" ]]; then
      tab-$3
    fi
  }

  function iterm2_tabs_preexec() {
    if zstyle -t ':prezto:module:iterm2' dim-active-tabs; then
      tab-other
    fi

    zstyle -a ':prezto:module:iterm2' info 'info_regexps'
    for info_regexp ("$info_regexps[@]"); do
      iterm2_tabs $1 $info_regexp info
    done
    unset info_regexps{s,}

    zstyle -a ':prezto:module:iterm2' safe 'safe_regexps'
    for safe_regexp ("$safe_regexps[@]"); do
      iterm2_tabs $1 $safe_regexp safe
    done
    unset safe_regexps{s,}

    zstyle -a ':prezto:module:iterm2' warning 'warning_regexps'
    for warning_regexp ("$warning_regexps[@]"); do
      iterm2_tabs $1 $warning_regexp warning
    done
    unset warning_regexps{s,}

    zstyle -a ':prezto:module:iterm2' danger 'danger_regexps'
    for danger_regexp ("$danger_regexps[@]"); do
      iterm2_tabs $1 $danger_regexp danger
    done
    unset danger_regexps{s,}
  }

  autoload -U add-zsh-hook
  add-zsh-hook precmd  iterm2_tabs_precmd
  add-zsh-hook preexec iterm2_tabs_preexec
fi
