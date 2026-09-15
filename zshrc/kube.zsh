# Kubeconfig helpers for CAPI management and tenant clusters.
#
# Layout:
#   ~/.kube/<mgmt>                         one kubeconfig per management cluster (yours)
#   ~/.kube/tenants/<mgmt>--<tenant>--<cluster>   tenant kubeconfigs pulled from the mgmt (cached, not in dotfiles)
#
# Every argument is an fzf query, never an exact name. When a query matches one
# entry the picker is skipped, so `kt ne1prod acme` usually needs no interaction.
#
#   kx [query]                        pick any kubeconfig (mgmt or cached tenant) and export KUBECONFIG
#   kt [-f] [mgmt-query] [cluster-query...]
#                                     pick a mgmt, list its CAPI Clusters, pull the tenant kubeconfig, export
#   kmgmt [query]                     pick a mgmt kubeconfig only
#   kwhich                            show the current KUBECONFIG, context and server
#   kunset                            drop KUBECONFIG from this shell

_KUBE_ZSH_FILE="${(%):-%x}"   # this file, so fzf previews can re-source it in a subshell
export KUBE_DIR="${KUBE_DIR:-$HOME/.kube}"
export KUBE_TENANTS_DIR="${KUBE_TENANTS_DIR:-$KUBE_DIR/tenants}"
export KUBE_TENANT_TTL_MIN="${KUBE_TENANT_TTL_MIN:-720}"   # refresh cached tenant kubeconfig after 12h
# Top-level files in KUBE_DIR that are not management kubeconfigs.
export KUBE_MGMT_EXCLUDE="${KUBE_MGMT_EXCLUDE:-config|hosting-config|cache|tenants}"

# ---------------------------------------------------------------------------
# internals
# ---------------------------------------------------------------------------

# List management kubeconfigs (basenames), one per line.
_kube_mgmt_list() {
  find "$KUBE_DIR" -mindepth 1 -maxdepth 1 -type f ! -name '.*' -printf '%f\n' 2>/dev/null \
    | grep -Ev "^(${KUBE_MGMT_EXCLUDE})$" | sort
}

# List every kubeconfig (mgmt + tenants) relative to KUBE_DIR.
_kube_all_list() {
  { _kube_mgmt_list
    [[ -d "$KUBE_TENANTS_DIR" ]] && find "$KUBE_TENANTS_DIR" -mindepth 1 -maxdepth 1 -type f -printf 'tenants/%f\n'
  } 2>/dev/null | sort
}

# Preview for a kubeconfig path relative to KUBE_DIR.
_kube_preview() {
  local f="$KUBE_DIR/$1"
  echo "context: $(kubectl --kubeconfig "$f" config current-context 2>/dev/null)"
  echo "server:  $(kubectl --kubeconfig "$f" config view --minify -o jsonpath='{.clusters[0].cluster.server}' 2>/dev/null)"
  echo "file:    $f"
}

# fzf wrapper: stdin = candidates, $1 = prompt, $2 = query, $3 = preview cmd (optional).
# Skips the UI when the query matches exactly one candidate.
_kube_pick() {
  local prompt="$1" query="$2" preview="$3"
  local -a opts=(--prompt="$prompt" --query="$query" --select-1 --exit-0 --height=40% --reverse)
  [[ -n "$preview" ]] && opts+=(--preview="$preview" --preview-window=down:4:wrap)
  fzf "${opts[@]}"
}

_kube_export() {
  export KUBECONFIG="$1"
  echo "KUBECONFIG=$KUBECONFIG"
}

# ---------------------------------------------------------------------------
# public
# ---------------------------------------------------------------------------

kmgmt() {
  local m
  m=$(_kube_mgmt_list | _kube_pick 'mgmt> ' "$*" "zsh -c 'source ${(q)_KUBE_ZSH_FILE}; _kube_preview {}'") || return
  _kube_export "$KUBE_DIR/$m"
}

kx() {
  local f
  f=$(_kube_all_list | _kube_pick 'kubeconfig> ' "$*" "zsh -c 'source ${(q)_KUBE_ZSH_FILE}; _kube_preview {}'") || return
  _kube_export "$KUBE_DIR/$f"
}

# kt [-f] [mgmt-query] [cluster-query...]
kt() {
  local force=0
  [[ "$1" == "-f" ]] && { force=1; shift; }
  local mgmt_query="$1"; (( $# )) && shift
  local cluster_query="$*"

  # 1. management cluster
  local mgmt
  mgmt=$(_kube_mgmt_list | _kube_pick 'mgmt> ' "$mgmt_query") || { echo "kt: no management cluster selected" >&2; return 1; }
  local mcfg="$KUBE_DIR/$mgmt"

  # 2. tenant cluster: rows are "<namespace> <name> <phase>", namespace == tenant
  local sel
  sel=$(kubectl --kubeconfig "$mcfg" get clusters.cluster.x-k8s.io -A --no-headers \
          -o custom-columns='NS:.metadata.namespace,NAME:.metadata.name,PHASE:.status.phase' 2>/dev/null \
        | _kube_pick "$mgmt cluster> " "$cluster_query") \
    || { echo "kt: no cluster selected on $mgmt" >&2; return 1; }
  local tenant cluster
  read -r tenant cluster _ <<<"$sel"

  # 3. pull + cache
  mkdir -p "$KUBE_TENANTS_DIR" && chmod 700 "$KUBE_TENANTS_DIR"
  local out="$KUBE_TENANTS_DIR/${mgmt}--${tenant}--${cluster}"
  if (( force )) || [[ ! -s "$out" ]] || [[ -n $(find "$out" -mmin +"$KUBE_TENANT_TTL_MIN" 2>/dev/null) ]]; then
    local tmp="$out.tmp.$$"
    if kubectl --kubeconfig "$mcfg" -n "$tenant" get secret "${cluster}-kubeconfig" \
         -o jsonpath='{.data.value}' 2>/dev/null | base64 -d > "$tmp" && [[ -s "$tmp" ]]; then
      chmod 600 "$tmp" && mv -f "$tmp" "$out"
      echo "kt: refreshed $out"
    else
      rm -f "$tmp"
      echo "kt: failed to read secret ${cluster}-kubeconfig in namespace $tenant on $mgmt" >&2
      return 1
    fi
  fi

  _kube_export "$out"
}

kwhich() {
  if [[ -z "$KUBECONFIG" ]]; then
    echo "KUBECONFIG not set (using ~/.kube/config)"
    return
  fi
  echo "KUBECONFIG=$KUBECONFIG"
  echo "context:  $(kubectl config current-context 2>/dev/null)"
  echo "server:   $(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}' 2>/dev/null)"
}

kunset() { unset KUBECONFIG; echo "KUBECONFIG unset"; }
