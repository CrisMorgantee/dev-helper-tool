# Git Aliases

alias gc='git commit -m'
alias gl='git log --oneline --decorate --color --graph'
alias gkt='git checkout -'
alias nah='git reset --hard && git clean -df'
alias putz='git reset --soft HEAD~1'
alias wip='git add . && git commit -m "wip" >/dev/null'
alias wips='git add . && git commit -m "wip" >/dev/null && git push'

alias gst='git status'
alias gss='git status --short'
alias gsb='git status --short --branch'
alias gca='git commit --verbose --all --message'
alias gcaa='git commit --verbose --all --message --amend'

alias gcb='git checkout -b'
alias gcB='git checkout -B'
alias gcd='git checkout $(git_develop_branch)'
alias gcm='git checkout $(git_main_branch)'
alias gco='git checkout'
alias gb='git branch'
alias gba='git branch --all'
alias gbd='git branch --delete'

alias ga='git add'
alias gaa='git add --all'

# Funções Git personalizadas
function grename() {
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: grename old_branch new_branch"
    return 1
  fi

  # Rename branch locally
  git branch -m "$1" "$2"
  # Rename branch in origin remote
  if git push origin :"$1"; then
    git push --set-upstream origin "$2"
  fi
}

function git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local ref
  for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default,stable,master}; do
    if command git show-ref -q --verify $ref; then
      echo ${ref:t}
      return 0
    fi
  done

  # If no main branch was found, fall back to master but return error
  echo master
  return 1
}

function git_develop_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local branch
  for branch in dev devel develop development; do
    if command git show-ref -q --verify refs/heads/$branch; then
      echo $branch
      return 0
    fi
  done

  echo develop
  return 1
}