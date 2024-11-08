# Dev Helper Tools (DHT)

![GitHub](https://img.shields.io/github/license/CrisMorgantee/dev-helper-tool)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/CrisMorgantee/dev-helper-tool)

**Dev Helper Tools (DHT)** é uma coleção de ferramentas e aliases para ajudar no desenvolvimento com Git, Laravel, e
comandos de sistema. Com ele, você pode configurar aliases específicos, automatizar operações do Git, e gerenciar
configurações personalizadas de maneira prática.

## Índice

- [Instalação](#instalação)
    - [Como Plugin do Oh My Zsh](#como-plugin-do-oh-my-zsh)
- [Configuração](#configuração)
    - [Arquivo de Configuração](#arquivo-de-configuração)
- [Uso](#uso)
- [Licença](#licença)

## Instalação

### Como Plugin do Oh My Zsh

1. **Clone o repositório no diretório de plugins do Oh My Zsh:**

   ```sh
   git clone https://github.com/CrisMorgantee/dev-helper-tool ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/dht
   ```

2. **Adicione o plugin ao seu `.zshrc`:**

   Abra o arquivo `.zshrc` no seu editor de texto favorito e adicione `dht` à lista de plugins:

   ```zsh
   plugins=(... dht)
   ```

3. **Recarregue o Zsh:**

   Para aplicar as mudanças, recarregue o Zsh com o comando:

   ```sh
   source ~/.zshrc
   ```

## Configuração

### Arquivo de Configuração

Após a instalação, o DHT utiliza um arquivo de configuração padrão (`dht.conf`) localizado na pasta `config` do projeto.
Você pode personalizar as configurações criando um arquivo `.dht_config` na sua pasta `HOME`.

Exemplo de configurações no `.dht_config`:

```sh
# Habilitar ou desabilitar aliases
DHT_LOAD_GIT_ALIASES="true"
DHT_LOAD_LARAVEL_ALIASES="false"
DHT_LOAD_SYSTEM_ALIASES="false"

# Configurações para o Git
DHT_REMOTE="origin"
DHT_CACHE_DURATION=30
DHT_EXCLUDE_BRANCHES="main|master|develop"
```

Essas configurações permitem que você personalize quais aliases são carregados e como o DHT interage com o Git.

## Uso

O **Dev Helper Tools** oferece diversos comandos e opções para gerenciamento de branches no Git e configuração de
aliases.

### Comando Principal

O comando principal para o DHT é `dht`. Abaixo estão algumas das opções disponíveis:

```sh
dht [options] [branch_name]
```

#### Opções

- `-n` - Não executa `git pull` após o checkout.
- `-a` - Executa `git fetch --all`.
- `-c <cache_duration>` - Define a duração do cache em minutos (padrão: 30).
- `-p` - Remove branches locais que não existem mais no repositório remoto.
- `-f` - Força a troca de branches mesmo com mudanças não comitadas.
- `-cl` - Limpa o arquivo de cache do branch.
- `--alias` - Abre o menu interativo para configuração de aliases.
- `-h` - Exibe a ajuda.
- `-man` - Exibe o manual completo.

### Menu Interativo para Aliases

Para configurar os aliases, execute o comando:

```sh
dht --alias
```

O menu permite ativar ou desativar os seguintes grupos de aliases:

1. **Git Aliases**: Atalhos para comandos comuns do Git.
2. **Laravel Aliases**: Atalhos para comandos do Laravel (exige o Laravel instalado).
3. **System Aliases**: Comandos úteis do sistema, como `ditto` e `bat` (com verificação de dependências).

## Licença

Este projeto está licenciado sob a [Licença MIT](https://github.com/CrisMorgantee/dev-helper-tool/blob/main/LICENSE) -
veja o arquivo LICENSE para mais detalhes.

```