# dht.plugin.zsh

# Determina o diretório base do plugin
DHT_PLUGIN_DIR="${0:A:h}"

# Carrega o arquivo de configuração (prioriza o config do usuário)
if [[ -f "$HOME/.dht_config" ]]; then
  source "$HOME/.dht_config"
else
  source "$DHT_PLUGIN_DIR/config/dht.conf"
fi

# Carrega a função principal do Dev Helper Tools (dht)
source "$DHT_PLUGIN_DIR/bin/dht"

# Carrega as funções de verificação de dependências
source "$DHT_PLUGIN_DIR/functions/dht.zsh"

# Carrega aliases com base nas configurações
if [[ "$DHT_LOAD_GIT_ALIASES" == "true" ]]; then
  source "$DHT_PLUGIN_DIR/aliases/git_aliases.zsh"
  echo "Git aliases enabled."
fi

if [[ "$DHT_LOAD_LARAVEL_ALIASES" == "true" ]]; then
  source "$DHT_PLUGIN_DIR/aliases/laravel_aliases.zsh"
  echo "Laravel aliases enabled."
fi

if [[ "$DHT_LOAD_SYSTEM_ALIASES" == "true" ]]; then
  source "$DHT_PLUGIN_DIR/aliases/system_aliases.zsh"
  echo "System aliases enabled."
fi