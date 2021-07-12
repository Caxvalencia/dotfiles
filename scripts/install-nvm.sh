if ! command_exists nvm; then
  echo_info "NVM not installed, trying to install"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash 
  echo_success "NVM installed"
fi