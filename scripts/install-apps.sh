echo_question "Do you like install applications? [${purple}Y${normal}es/${purple}N${normal}o]" "INSTALL_APPS"

INSTALL_APPS="${INSTALL_APPS:-"Y"}"
INSTALL_APPS="$(eval echo "$INSTALL_APPS")"

echo_normal $INSTALL_APPS

if [[ "$INSTALL_APPS" == "Y" ]] || [[ "$INSTALL_APPS" == "y" ]]; then
  echo_info "Installing applications (${cyan}Dependencies, Google Chrome, VScode...${normal}) via Homebrew"
  brew bundle --file "./Brewfile"
fi
