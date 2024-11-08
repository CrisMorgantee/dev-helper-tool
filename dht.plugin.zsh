# Carregar funções
fpath+=("${0:A:h}/functions")
autoload -Uz dht

# Carregar configurações
if [[ -f "$HOME/.dht_config" ]]; then
  source "$HOME/.dht_config"
else
  source "${0:A:h}/config/dht.conf"
fi

# Carregar aliases selecionados pelo usuário
if [[ "$DHT_LOAD_GIT_ALIASES" == "true" ]]; then
  source "${0:A:h}/aliases/git_aliases.zsh"
fi

if [[ "$DHT_LOAD_LARAVEL_ALIASES" == "true" ]]; then
  source "${0:A:h}/aliases/laravel_aliases.zsh"
fi

if [[ "$DHT_LOAD_SYSTEM_ALIASES" == "true" ]]; then
  source "${0:A:h}/aliases/system_aliases.zsh"
fi