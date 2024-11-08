# Função para verificar dependências e sugerir instalação
function dht_check_dependency() {
  local cmd=$1
  local pkg=$2

  if ! command -v "$cmd" &> /dev/null; then
    echo "Aviso: Dependência '$cmd' não encontrada. Algumas funcionalidades podem não funcionar corretamente."
    echo "Para instalar '$pkg', execute o seguinte comando:"

    if [[ "$OSTYPE" == "darwin"* ]]; then
      echo "brew install $pkg"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
      if command -v apt-get &> /dev/null; then
        echo "sudo apt-get install $pkg"
      elif command -v yum &> /dev/null; then
        echo "sudo yum install $pkg"
      else
        echo "Use o gerenciador de pacotes da sua distribuição para instalar '$pkg'."
      fi
    else
      echo "Por favor, instale '$pkg' manualmente."
    fi
  fi
}

# Verificar dependências se os aliases correspondentes forem carregados
if [[ "$DHT_LOAD_SYSTEM_ALIASES" == "true" ]]; then
  dht_check_dependency "ditto" "ditto"
  dht_check_dependency "bat" "bat"
fi