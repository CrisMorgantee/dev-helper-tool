# dht.plugin.zsh

# Carregar funções
if [[ -f "${0:A:h}/functions/dht.zsh" ]]; then
  source "${0:A:h}/functions/dht.zsh"
else
  echo "Warning: dht function file not found at '${0:A:h}/functions/dht.zsh'."
fi

# Carregar configurações
if [[ -f "$HOME/.dht_config" ]]; then
  source "$HOME/.dht_config"
else
  if [[ -f "${0:A:h}/config/dht.conf" ]]; then
    source "${0:A:h}/config/dht.conf"
  else
    echo "Warning: Default configuration file not found."
  fi
fi

# Carregar aliases selecionados pelo usuário
if [[ "$DHT_LOAD_GIT_ALIASES" == "true" ]]; then
  if [[ -f "${0:A:h}/aliases/git_aliases.zsh" ]]; then
    source "${0:A:h}/aliases/git_aliases.zsh"
  else
    echo "Warning: Git aliases file not found."
  fi
fi

if [[ "$DHT_LOAD_LARAVEL_ALIASES" == "true" ]]; then
  if [[ -f "${0:A:h}/aliases/laravel_aliases.zsh" ]]; then
    source "${0:A:h}/aliases/laravel_aliases.zsh"
  else
    echo "Warning: Laravel aliases file not found."
  fi
fi

if [[ "$DHT_LOAD_SYSTEM_ALIASES" == "true" ]]; then
  if [[ -f "${0:A:h}/aliases/system_aliases.zsh" ]]; then
    source "${0:A:h}/aliases/system_aliases.zsh"
  else
    echo "Warning: System aliases file not found."
  fi
fi