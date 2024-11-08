# functions/check_dependencies.zsh

# Verifica se um comando existe e oferece para instalar
dht_check_and_install_dependency() {
  local cmd=$1
  local pkg=$2

  if ! command -v "$cmd" &> /dev/null; then
    echo "Dependency '$cmd' not found."

    read -rp "Do you want to install '$pkg'? (y/n): " choice
    if [[ "$choice" == "y" ]]; then
      if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install "$pkg"
      elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get install "$pkg"
      fi
    else
      echo "Skipping installation of '$pkg'."
    fi
  fi
}