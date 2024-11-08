# Função para verificar e instalar dependências
function dht_check_and_install_dependency() {
  local cmd=$1
  local pkg=$2

  if ! command -v "$cmd" &> /dev/null; then
    echo "Dependency '$cmd' not found."

    read -rp "Do you want to install '$pkg'? (y/n): " choice
    if [[ "$choice" == "y" ]]; then
      if [[ "$OSTYPE" == "darwin"* ]]; then
        # MacOS
        if command -v brew &> /dev/null; then
          brew install "$pkg"
        else
          echo "Homebrew is not installed. Please install it first."
          return 1
        fi
      elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        if command -v apt-get &> /dev/null; then
          sudo apt-get install "$pkg"
        elif command -v yum &> /dev/null; then
          sudo yum install "$pkg"
        else
          echo "Package manager not found. Please install '$pkg' manually."
          return 1
        fi
      else
        echo "Unsupported OS. Please install '$pkg' manually."
        return 1
      fi
    else
      echo "Skipping installation of '$pkg'. Some aliases may not work properly."
    fi
  fi
}

# Verificar dependências se os aliases correspondentes forem carregados
if [[ "$DHT_LOAD_SYSTEM_ALIASES" == "true" ]]; then
  dht_check_and_install_dependency "ditto" "ditto"
  dht_check_and_install_dependency "bat" "bat"
fi