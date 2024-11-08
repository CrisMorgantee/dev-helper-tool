# dht.plugin.zsh

# Obter o diretório deste script
PLUGIN_DIR="${0:a:h}"

# Carregar configurações do usuário ou padrão
if [[ -f "$HOME/.dht_config" ]]; then
  source "$HOME/.dht_config"
else
  source "$PLUGIN_DIR/config/dht.conf"
fi

# Carregar aliases conforme configurações
if [[ "$DHT_LOAD_GIT_ALIASES" == "true" ]]; then
  source "$PLUGIN_DIR/aliases/git_aliases.zsh"
fi

if [[ "$DHT_LOAD_LARAVEL_ALIASES" == "true" ]]; then
  source "$PLUGIN_DIR/aliases/laravel_aliases.zsh"
fi

if [[ "$DHT_LOAD_SYSTEM_ALIASES" == "true" ]]; then
  source "$PLUGIN_DIR/aliases/system_aliases.zsh"
fi

# Carregar funções
source "$PLUGIN_DIR/functions/check-dependencies.zsh"

# Definir a função dht
function dht() {
  DHT_PLUGIN_DIR="$PLUGIN_DIR" zsh "$PLUGIN_DIR/bin/dht" "$@"
}