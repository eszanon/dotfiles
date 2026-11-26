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
set -euo pipefail

DOTFILES="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." && pwd)"

SOURCES=(
  "$DOTFILES/agents/skills"
  "$DOTFILES/personal/agents/skills"
  "$DOTFILES/work/agents/skills"
)
TARGETS=(
  "$HOME/.claude/skills"
  "$HOME/.agents/skills"
)

declare -A skills=()
for src in "${SOURCES[@]}"; do
  [[ -d "$src" ]] || continue
  for dir in "$src"/*/; do
    [[ -f "$dir/SKILL.md" ]] || continue
    name="$(basename "$dir")"
    [[ -n "${skills[$name]:-}" ]] && echo "aviso: '$name' em ${skills[$name]} sobrescrita por $dir" >&2
    skills[$name]="${dir%/}"
  done
done

for target in "${TARGETS[@]}"; do
  mkdir -p "$target"

  # Remove links do dotfiles que ficaram quebrados ou que não são mais skills.
  for link in "$target"/*; do
    [[ -L "$link" ]] || continue
    dest="$(readlink "$link")"
    [[ "$dest" == "$DOTFILES"/* ]] || continue
    if [[ ! -e "$link" || -z "${skills[$(basename "$link")]:-}" ]]; then
      rm "$link" && echo "removido: $link"
    fi
  done

  for name in "${!skills[@]}"; do
    dest="$target/$name"
    if [[ -e "$dest" && ! -L "$dest" ]]; then
      echo "pulado: $dest é um diretório real (mova-o para o dotfiles ou apague)" >&2
      continue
    fi
    if [[ "$(readlink "$dest" 2>/dev/null)" != "${skills[$name]}" ]]; then
      ln -sfn "${skills[$name]}" "$dest" && echo "linkado: $dest -> ${skills[$name]}"
    fi
  done
done
