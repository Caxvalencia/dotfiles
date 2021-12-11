#!/usr/bin/env zsh

# ------------------------------------------------------------------------
# SOURCECODE TAKEN FROM:
# https://github.com/romkatv/powerlevel10k/blob/master/internal/wizard.zsh
# ------------------------------------------------------------------------

font_base_url='https://github.com/romkatv/powerlevel10k-media/raw/master'

function prompt_length() {
  local -i COLUMNS=1024
  local -i x y=$#1 m
  if (( y )); then
    while (( ${${(%):-$1%$y(l.1.0)}[-1]} )); do
      x=y
      (( y *= 2 ))
    done
    while (( y > x + 1 )); do
      (( m = x + (y - x) / 2 ))
      (( ${${(%):-$1%$m(l.x.y)}[-1]} = m ))
    done
  fi
  typeset -g REPLY=$x
}

function flowing() {
  (( ${wizard_columns:-0} )) || local -i wizard_columns=COLUMNS
  local opt
  local -i centered indentation
  
  while getopts 'ci:' opt; do
    case $opt in
      i)  indentation=$OPTARG;;
      c)  centered=1;;
      +c) centered=0;;
      \?) exit 1;;
    esac
  done

  shift $((OPTIND-1))
  local line word lines=()

  for word in "$@"; do
    prompt_length ${(g::):-"$line $word"}
    if (( REPLY > wizard_columns )); then
      [[ -z $line ]] || lines+=$line
      line=
    fi

    if [[ -n $line ]]; then
      line+=' '
    elif (( $#lines )); then
      line=${(pl:$indentation:: :)}
    fi

    line+=$word
  done

  [[ -z $line ]] || lines+=$line

  for line in $lines; do
    prompt_length ${(g::)line}
    (( centered && REPLY < wizard_columns )) && print -n -- ${(pl:$(((wizard_columns - REPLY) / 2)):: :)}
    print -P -- $line
  done
}

function hide_cursor() {
  (( $+terminfo[cnorm] )) || return
  echoti civis 2>/dev/null
}

function install_font() {
  clear

  command mkdir -p -- ~/Library/Fonts || quit -c
  local style

  for style in Regular Bold Italic 'Bold Italic'; do
    local file="MesloLGS NF ${style}.ttf"
    run_command "Downloading %B$file%b" \
      curl -fsSL -o ~/Library/Fonts/$file.tmp "$font_base_url/${file// /%20}"
    command mv -f -- ~/Library/Fonts/$file{.tmp,} || quit -c
  done

  print -nP -- "Changing %BiTerm2%b settings ..."
  local size=13

  local k t v settings=(
    '"Normal Font"'                                 string '"MesloLGS-NF-Regular '$size'"'
    '"Terminal Type"'                               string '"xterm-256color"'
    '"Horizontal Spacing"'                          real   1
    '"Vertical Spacing"'                            real   1
    '"Minimum Contrast"'                            real   0
    '"Use Bold Font"'                               bool   1
    '"Use Bright Bold"'                             bool   1
    '"Use Italic Font"'                             bool   1
    '"ASCII Anti Aliased"'                          bool   1
    '"Non-ASCII Anti Aliased"'                      bool   1
    '"Use Non-ASCII Font"'                          bool   0
    '"Ambiguous Double Width"'                      bool   0
    '"Draw Powerline Glyphs"'                       bool   1
    '"Only The Default BG Color Uses Transparency"' bool   1
  )

  for k t v in $settings; do
    /usr/libexec/PlistBuddy -c "Set :\"New Bookmarks\":0:$k $v" \
      ~/Library/Preferences/com.googlecode.iterm2.plist 2>/dev/null && continue

    run_command "" /usr/libexec/PlistBuddy -c \
      "Add :\"New Bookmarks\":0:$k $t $v" ~/Library/Preferences/com.googlecode.iterm2.plist
  done

  print -P " %2FOK%f"
  print -nP "Updating %BiTerm2%b settings cache ..."
  run_command "" /usr/bin/defaults read com.googlecode.iterm2
  sleep 3
  print -P " %2FOK%f"
  sleep 1
  clear
  hide_cursor
  print
  flowing +c "%2FMeslo Nerd Font%f" successfully installed.
  print -P ""

  () {
    local out
    out=$(/usr/bin/defaults read 'Apple Global Domain' NSQuitAlwaysKeepsWindows 2>/dev/null) || return
    [[ $out == 1 ]] || return
    out="$(iterm_get OpenNoWindowsAtStartup 2>/dev/null)" || return
    [[ $out == false ]]
  }
 
  if (( $? )); then
    flowing +c Please "%Brestart iTerm2%b" for the changes to take effect.
    print -P ""
    flowing +c -i 5 "  1. Click" "%BiTerm2 → Quit iTerm2%b" or press "%B⌘ Q%b."
    flowing +c -i 5 "  2. Open %BiTerm2%b."
    print -P ""
    flowing +c "It's" important to "%Brestart iTerm2%b" by following the instructions above.   \
                "It's" "%Bnot enough%b" to close iTerm2 by clicking on the red circle. You must \
                click "%BiTerm2 → Quit iTerm2%b" or press "%B⌘ Q%b."
  else
    flowing +c Please "%Brestart your computer%b" for the changes to take effect.
  fi
   
  return 0
}

function run_command() {
  local msg=$1
  shift
  [[ -n $msg ]] && print -nP -- "$msg ..."
  local err && err="$("$@" 2>&1)" || {
    print -P " %1FERROR%f"
    print -P ""
    print -nP "%BCommand:%b "
    print -r -- "${(@q)*}"
    if [[ -n $err ]]; then
      print -P ""
      print -r -- $err
    fi
    quit -c
  }
  [[ -n $msg ]] && print -P " %2FOK%f"
}

install_font