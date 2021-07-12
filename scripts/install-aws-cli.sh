if ! command_exists aws; then
  echo_info "aws-cli not installed, trying to install"

  curl -fsSL -o awscliv2.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.0.42.zip
  unzip -q "./awscliv2.zip"
  rm "./awscliv2.zip"
  chmod +x ./aws/install
  bash_run "./aws/install -i /usr/local/aws-cli -b /usr/local/bin"
  rm -rf "./aws"

  echo_success "aws-cli v2 installed\\n"
fi