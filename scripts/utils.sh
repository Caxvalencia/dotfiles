LOG_FILE=${LOG_FILE:-$HOME/dotfiles.log}

red='\033[0;31m'
green='\033[0;32m'
purple='\033[0;35m'
blue="\033[0;34m"
normal='\033[0m'
yellow="\033[0;33m" 
cyan="\033[0;36m"

utils_log() {
  log_name="$1"
  current_date=$(date "+%Y-%m-%d %H:%M:%S")

  touch "$LOG_FILE"
  echo "----- $current_date - $log_name -----" >>"$LOG_FILE"

  while IFS= read -r log_message; do
    echo "$log_message" >>"$LOG_FILE"
  done

  echo "" >>"$LOG_FILE"
}

echo_normal() {
  local -r text="${1:-}"
  echo -e "$text"
}

echo_custom() { echo_normal " > $1"; }
echo_error() { echo_custom "${red}$1${normal}"; }
echo_info() { echo_custom "${blue}$1${normal}"; }
echo_warn() { echo_custom "${yellow}$1${normal}"; }
echo_success() { echo_custom "${green}$1${normal}"; }

echo_question() {
  echo_normal "$1? "
  read -rp "? " "$2";
}

command_exists() {
  type "$1" >/dev/null 2>&1
}

current_timestamp() {
  date +%s;
}

create_dotfiles_dir() {
  if [ -d "$1" ]; then
    local -r backup_path="$1.$(current_timestamp).back"

    echo_info "The path '$1' already exist"
    echo_success "Creating a backup in '$backup_path'"

    mv "$1" "$backup_path"
  else
    echo_normal "Ok! dotfiles will be located in: ${purple}$DOTFILES_PATH${normal}"
  fi

  mkdir -p "$1"
}

bash_run() {
  /bin/bash -c "$1" 2>&1 | utils_log "Running $1"
}