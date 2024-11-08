# dht.plugin.zsh

# Carregar configurações do usuário ou padrão
if [[ -f "$HOME/.dht_config" ]]; then
  source "$HOME/.dht_config"
else
  source "${0:A:h}/config/dht.conf"
fi

# Carregar a função principal
source "${0:A:h}/bin/dht"

# Carregar funções para verificar dependências de aliases
source "${0:A:h}/functions/dht.zsh"

# Carregar aliases conforme configurações
if [[ "$DHT_LOAD_GIT_ALIASES" == "true" ]]; then
  source "${0:A:h}/aliases/git_aliases.zsh"
fi

if [[ "$DHT_LOAD_LARAVEL_ALIASES" == "true" ]]; then
  source "${0:A:h}/aliases/laravel_aliases.zsh"
fi

if [[ "$DHT_LOAD_SYSTEM_ALIASES" == "true" ]]; then
  source "${0:A:h}/aliases/system_aliases.zsh"
fi