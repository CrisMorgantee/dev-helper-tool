# Dev Helper Tools (DHT)

Dev Helper Tools é um conjunto de ferramentas e aliases para auxiliar desenvolvedores em tarefas comuns, como
gerenciamento de branches Git, comandos frequentes de Laravel e atalhos do sistema. O DHT permite que você personalize
quais funcionalidades deseja utilizar e gerencia automaticamente dependências necessárias.

## Funcionalidades

- **Gerenciamento de Branches Git**: Com o comando `dht`, você pode alternar facilmente entre branches, criar novos
  branches, buscar atualizações e limpar branches obsoletos.
- **Aliases Personalizados**: Carregue aliases para Git, Laravel e comandos do sistema, agilizando seu fluxo de
  trabalho.
- **Gerenciamento de Dependências**: O DHT verifica se as dependências necessárias estão instaladas e oferece a opção de
  instalá-las automaticamente.

## Instalação

### Pré-requisitos

- **Zsh**: O DHT é um plugin para o Oh My Zsh, portanto, é necessário ter o Zsh instalado.
- **Oh My Zsh**: Você precisa ter o Oh My Zsh configurado em seu ambiente.

### Instalação Manual

1. **Clone o repositório** no diretório de plugins do Oh My Zsh:

   ```sh
   git clone https://github.com/crismorgantee/dev-helper-tools.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/dev-helper-tools