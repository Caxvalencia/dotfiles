NODE_VERSION=${NODE_VERSION:-14}

if ! command_exists nvm; then
  echo_info "\\nNVM not installed, trying to install"
  bash_run "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh"
  echo_success "NVM installed"
fi

if ! command_exists node; then
  echo_info "\\nnodejs $NODE_VERSION not installed, trying to install"
  nvm use $NODE_VERSION
  echo_success "nodejs $NODE_VERSION installed"
fi