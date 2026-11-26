#!/usr/bin/env bash
# Linka as skills versionadas no dotfiles para os diretórios que os agentes leem.
#
# Fontes (em ordem; se dois tiverem a mesma skill, a última vence):
#   agents/skills/          -> skills pessoais genéricas (repo público)
#   personal/agents/skills/ -> submódulo privado pessoal
#   work/agents/skills/     -> submódulo privado da empresa
#
# Destinos:
#   ~/.claude/skills/  -> Claude Code
#   ~/.agents/skills/  -> padrão Agent Skills (Codex, Copilot, Gemini CLI, Cursor, ...)
#
# Cria um symlink por skill (não linka o diretório inteiro, para não engolir
# ~/.claude/skills/synced, que é gerenciado pelo claude.ai). Remove links
# quebrados que apontam para o dotfiles. Nunca sobrescreve diretórios reais.
# É idempotente: rode de novo sempre que adicionar/remover uma skill.
#
# Compatível com o bash 3.2 do macOS: sem arrays associativos nem readlink -f.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

SOURCES=(
  "$DOTFILES/agents/skills"
  "$DOTFILES/personal/agents/skills"
  "$DOTFILES/work/agents/skills"
)
TARGETS=(
  "$HOME/.claude/skills"
  "$HOME/.agents/skills"
)

# names[i] -> paths[i]
names=()
paths=()

# Imprime o índice de uma skill em names[], ou falha se não existir.
index_of() {
  local i
  for ((i = 0; i < ${#names[@]}; i++)); do
    if [[ "${names[i]}" == "$1" ]]; then
      echo "$i"
      return 0
    fi
  done
  return 1
}

for src in "${SOURCES[@]}"; do
  [[ -d "$src" ]] || continue
  for dir in "$src"/*/; do
    [[ -f "$dir/SKILL.md" ]] || continue
    name="$(basename "$dir")"
    if i="$(index_of "$name")"; then
      echo "aviso: '$name' em ${paths[i]} sobrescrita por ${dir%/}" >&2
      paths[i]="${dir%/}"
    else
      names+=("$name")
      paths+=("${dir%/}")
    fi
  done
done

for target in "${TARGETS[@]}"; do
  mkdir -p "$target"

  # Remove links do dotfiles que ficaram quebrados ou que não são mais skills.
  for link in "$target"/*; do
    [[ -L "$link" ]] || continue
    [[ "$(readlink "$link")" == "$DOTFILES"/* ]] || continue
    if [[ ! -e "$link" ]] || ! index_of "$(basename "$link")" >/dev/null; then
      rm "$link" && echo "removido: $link"
    fi
  done

  for ((i = 0; i < ${#names[@]}; i++)); do
    dest="$target/${names[i]}"
    if [[ -e "$dest" && ! -L "$dest" ]]; then
      echo "pulado: $dest é um diretório real (mova-o para o dotfiles ou apague)" >&2
      continue
    fi
    if [[ "$(readlink "$dest" 2>/dev/null || true)" != "${paths[i]}" ]]; then
      ln -sfn "${paths[i]}" "$dest" && echo "linkado: $dest -> ${paths[i]}"
    fi
  done
done
