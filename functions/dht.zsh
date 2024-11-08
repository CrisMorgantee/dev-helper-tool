# functions/dht.zsh

# Função principal do DHT
dht() {
  case "$1" in
    -h|--help)
      display_help
      ;;
    --alias)
      alias_configuration_menu
      ;;
    -man)
      display_manual
      ;;
    *)
      load_config
      parse_options "$@"

      # Persist alias configuration if options were set
      if [[ "$SAVE_CONFIG" == "true" ]]; then
        persist_alias_configuration
      fi

      # Open interactive menu if the user selected the option
      if [[ "$OPEN_INTERACTIVE" == "true" ]]; then
        alias_configuration_menu
      fi

      # Clear cache if requested
      if $CLEAR_CACHE; then
        clear_cache
        return
      fi

      # Load aliases based on options and configuration
      load_aliases

      # Check and manage Git branches if needed
      check_remote_access
      fetch_updates
      prune_branches
      determine_branch_name
      check_uncommitted_changes
      switch_to_branch
      ;;
  esac
}

# === Funções de Apoio ===

# Função de Ajuda
display_help() {
  echo "Usage: dht [options] [branch_name]"
  echo "Options:"
  echo "  -n                     Do not execute 'git pull' after checkout"
  echo "  -a                     Execute 'git fetch --all'"
  echo "  -c <cache_duration>    Set cache duration in minutes (default $DHT_CACHE_DURATION)"
  echo "  -p                     Remove local branches that no longer exist on the remote"
  echo "  -f                     Force switch branches even if there are uncommitted changes"
  echo "  -cl                    Clear the branch cache file"
  echo "  --alias                Open the interactive alias configuration menu"
  echo "  -h                     Display this help"
  echo "  -man                   Show the complete manual"
}

# Manual Completo
display_manual() {
  man "$ROOT_DIR/man/dht.1"
}

# Carregar Configuração
load_config() {
  local DEFAULT_CONFIG="${0:A:h}/../config/dht.conf"

  # Verificar se existe o arquivo de configuração padrão
  if [ -f "$DEFAULT_CONFIG" ]; then
    # shellcheck disable=SC1090
    source "$DEFAULT_CONFIG"
  else
    echo "Warning: Default configuration file not found at '$DEFAULT_CONFIG'. Using default settings."
  fi

  # Carregar configuração específica do usuário
  local CONFIG_FILE="$HOME/.dht_config"
  if [ -f "$CONFIG_FILE" ]; then
    # shellcheck disable=SC1090
    source "$CONFIG_FILE"
  fi

  # Variáveis padrão
  DHT_REMOTE="${DHT_REMOTE:-origin}"
  DHT_CACHE_DURATION="${DHT_CACHE_DURATION:-30}"
  DHT_EXCLUDE_BRANCHES="${DHT_EXCLUDE_BRANCHES:-main|master|develop}"
  CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/dht"
  mkdir -p "$CACHE_DIR"
  CACHE_FILE="$CACHE_DIR/branch"
}

# Persistir Configuração dos Aliases
persist_alias_configuration() {
  local CONFIG_FILE="$HOME/.dht_config"

  # Garantir que o arquivo de configuração exista
  [ -f "$CONFIG_FILE" ] || touch "$CONFIG_FILE"

  # Atualizar configuração dos aliases de acordo com a escolha do usuário
  [[ "$ENABLE_GIT_ALIASES" == "true" ]] && sed -i'' -e '/^DHT_LOAD_GIT_ALIASES=/d' "$CONFIG_FILE" && echo "DHT_LOAD_GIT_ALIASES=true" >> "$CONFIG_FILE"
  [[ "$ENABLE_LARAVEL_ALIASES" == "true" ]] && sed -i'' -e '/^DHT_LOAD_LARAVEL_ALIASES=/d' "$CONFIG_FILE" && echo "DHT_LOAD_LARAVEL_ALIASES=true" >> "$CONFIG_FILE"
  [[ "$ENABLE_SYSTEM_ALIASES" == "true" ]] && sed -i'' -e '/^DHT_LOAD_SYSTEM_ALIASES=/d' "$CONFIG_FILE" && echo "DHT_LOAD_SYSTEM_ALIASES=true" >> "$CONFIG_FILE"
  [[ "$DISABLE_GIT_ALIASES" == "true" ]] && sed -i'' -e '/^DHT_LOAD_GIT_ALIASES=/d' "$CONFIG_FILE" && echo "DHT_LOAD_GIT_ALIASES=false" >> "$CONFIG_FILE"
  [[ "$DISABLE_LARAVEL_ALIASES" == "true" ]] && sed -i'' -e '/^DHT_LOAD_LARAVEL_ALIASES=/d' "$CONFIG_FILE" && echo "DHT_LOAD_LARAVEL_ALIASES=false" >> "$CONFIG_FILE"
  [[ "$DISABLE_SYSTEM_ALIASES" == "true" ]] && sed -i'' -e '/^DHT_LOAD_SYSTEM_ALIASES=/d' "$CONFIG_FILE" && echo "DHT_LOAD_SYSTEM_ALIASES=false" >> "$CONFIG_FILE"

  echo "Alias configuration persisted to $CONFIG_FILE."
}

# Carregar Aliases
load_aliases() {
  local BASE_DIR="${0:A:h}/.."

  [[ "$DHT_LOAD_GIT_ALIASES" == "true" ]] && [[ -f "$BASE_DIR/aliases/git_aliases.zsh" ]] && source "$BASE_DIR/aliases/git_aliases.zsh" || echo "Warning: Git aliases file not found."
  [[ "$DHT_LOAD_LARAVEL_ALIASES" == "true" ]] && [[ -f "$BASE_DIR/aliases/laravel_aliases.zsh" ]] && source "$BASE_DIR/aliases/laravel_aliases.zsh" || echo "Warning: Laravel aliases file not found."
  [[ "$DHT_LOAD_SYSTEM_ALIASES" == "true" ]] && [[ -f "$BASE_DIR/aliases/system_aliases.zsh" ]] && source "$BASE_DIR/aliases/system_aliases.zsh" || echo "Warning: System aliases file not found."
}

# Limpar Cache
clear_cache() {
  if [ -f "$CACHE_FILE" ]; then
    rm "$CACHE_FILE"
    echo "Branch cache cleared."
  else
    echo "No cache file to clear."
  fi
}

# Verificar Acessibilidade Remota
check_remote_access() {
  if ! git ls-remote &>/dev/null; then
    echo "Error: The remote repository is not accessible. Please check your network connection."
    return 1
  fi
}

# Atualizar Git
fetch_updates() {
  $FETCH_ALL && git fetch --all || git fetch "$DHT_REMOTE"
}

# Remover Branches Prune
prune_branches() {
  $PRUNE && git remote prune "$DHT_REMOTE" && echo "Orphaned local branches removed."
}

# Determinar Nome da Branch
determine_branch_name() {
  if [[ -n "$BRANCH_NAME" ]]; then
    BRANCH="$BRANCH_NAME"
  else
    BRANCH=$(git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/remotes/"$DHT_REMOTE" | grep -Ev "$DHT_REMOTE/($DHT_EXCLUDE_BRANCHES)" | head -n 1)
  fi

  if [[ -z "$BRANCH" ]]; then
    echo "No remote branches found matching the specified criteria."
    git branch -r
    read -rp "Do you want to create a new local branch? (y/n): " CREATE_BRANCH
    if [[ "$CREATE_BRANCH" == "y" ]]; then
      read -rp "Enter the name of the new branch: " NEW_BRANCH
      BRANCH="$NEW_BRANCH"
      echo "Select the base branch to create '$BRANCH' from:"
      echo "1) main"
      echo "2) current branch ($(git rev-parse --abbrev-ref HEAD))"
      read -rp "Enter your choice (1 or 2): " BASE_CHOICE
      BASE_BRANCH="$([[ "$BASE_CHOICE" == "1" ]] && echo "$DHT_REMOTE/main" || git rev-parse --abbrev-ref HEAD)"
    else
      echo "Operation canceled."
      return 1
    fi
  else
    BRANCH="${BRANCH#"$DHT_REMOTE/"}"
  fi
}

# Checar por Mudanças Não Commitadas
check_uncommitted_changes() {
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  if [ "$CURRENT_BRANCH" != "$BRANCH" ] && ! git diff-index --quiet HEAD --; then
    if [ "$FORCE" = true ]; then
      echo "Warning: You have uncommitted changes, but proceeding due to force option."
    else
      read -rp "Switching branches may result in data loss. Do you want to continue? (y/n): " PROCEED
      [[ "$PROCEED" != "y" ]] && echo "Operation canceled." && return 1
    fi
  fi
}

# Trocar para a Branch
switch_to_branch() {
  if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
    git checkout "$BRANCH" && $SYNC && git pull "$DHT_REMOTE" "$BRANCH" && echo "Switched to the local branch '$BRANCH' (updated)."
  elif git ls-remote --exit-code --heads "$DHT_REMOTE" "$BRANCH" &>/dev/null; then
    git checkout -b "$BRANCH" "$DHT_REMOTE/$BRANCH" && echo "Switched to the new branch '$BRANCH' created from remote."
  else
    git checkout -b "$BRANCH" "$BASE_BRANCH" && echo "Branch '$BRANCH' does not exist remotely. Created new local branch '$BRANCH' from '$BASE_BRANCH'."
  fi
}

# Menu de Configuração de Alias
alias_configuration_menu() {
  while true; do
    echo "Alias Configuration Options:"
    echo "1) Enable Git Aliases"
    echo "2) Disable Git Aliases"
    echo "3) Enable Laravel Aliases"
    echo "4) Disable Laravel Aliases"
    echo "5) Enable System Aliases"
    echo "6) Disable System Aliases"
    echo "7) Enable All Aliases"
    echo "8) Disable All Aliases"
    echo "9) Exit Configuration"
    read -rp "Choose an option: " choice

    case "$choice" in
      1) ENABLE_GIT_ALIASES="true"; echo "Git aliases enabled." ;;
      2) DISABLE_GIT_ALIASES="true"; echo "Git aliases disabled." ;;
      3) ENABLE_LARAVEL_ALIASES="true"; echo "Laravel aliases enabled." ;;
      4) DISABLE_LARAVEL_ALIASES="true"; echo "Laravel aliases disabled." ;;
      5) ENABLE_SYSTEM_ALIASES="true"; echo "System aliases enabled." ;;
      6) DISABLE_SYSTEM_ALIASES="true"; echo "System aliases disabled." ;;
      7) ENABLE_GIT_ALIASES="true"; ENABLE_LARAVEL_ALIASES="true"; ENABLE_SYSTEM_ALIASES="true"; echo "All aliases enabled." ;;
      8) DISABLE_GIT_ALIASES="true"; DISABLE_LARAVEL_ALIASES="true"; DISABLE_SYSTEM_ALIASES="true"; echo "All aliases disabled." ;;
      9) echo "Exiting."; break ;;
      *) echo "Invalid option. Try again." ;;
    esac
  done
  persist_alias_configuration
}