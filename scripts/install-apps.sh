echo_question "Do you like install applications? [${purple}Y${normal}es/${purple}N${normal}o]" "INSTALL_APPS"

INSTALL_APPS="${INSTALL_APPS:-"Y"}"
INSTALL_APPS="$(eval echo "$INSTALL_APPS")"

if [[ "$INSTALL_APPS" == "Y" ]] || [[ "$INSTALL_APPS" == "y" ]]; then
  echo_info "Installing applications (${cyan}Dependencies, Google Chrome, VScode...${normal}) via Homebrew"
  brew bundle --file "./Brewfile"

  # CONFIGS
  echo_info "Installing custom configuration for iterm2"
  cp ./iterm2-profile.json "$HOME/Library/Application Support/iTerm2/DynamicProfiles"
  echo_success "Configuration iterm2 files copied to $HOME/Library/Application Support/iTerm2/DynamicProfiles."
fi

# OPTIONALS APPLICATIONS
echo_question "Do you like install android studio and sdk? [${purple}Y${normal}es/${purple}N${normal}o] default (N)" "OPTIONAL_APPS"

OPTIONAL_APPS="${OPTIONAL_APPS:-"N"}"
OPTIONAL_APPS="$(eval echo "$OPTIONAL_APPS")"

if [[ "$OPTIONAL_APPS" == "Y" ]] || [[ "$OPTIONAL_APPS" == "y" ]]; then
  brew install cask "android-studio"
  brew install cask "android-sdk"
fi

echo_success "Applications installed!"
