#!/usr/bin/env bash
#
# Generate OG images (1200x630 PNG) for every post under content/posts/
# using Typst. Run before `zola build`.
#
# For each post:
#   - skip if `draft = true` in frontmatter
#   - skip if `[extra] og_image = "..."` is set (a colocated image is used instead)
#   - skip if the existing static/og/<slug>.png is newer than the source file
#
# Slug rule: strip a leading `YYYY-MM-DD_` prefix from the filename (for
# `*.md` posts) or from the directory name (for `<slug>/index.md` bundles).
# This mirrors Zola's slug derivation for this repo (slugify.paths = "off").

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
posts_dir="${repo_root}/content/posts"
out_dir="${repo_root}/static/og"
template="${repo_root}/og/template.typ"
fonts_dir="${repo_root}/og/fonts"

mkdir -p "${out_dir}"

# Fonts aren't committed to the repo; fetch them on demand (idempotent) so
# both local runs and CI go through the same entry point.
if [[ ! -f "${fonts_dir}/NotoSansCJKjp-Regular.otf" || ! -f "${fonts_dir}/NotoSansCJKjp-Bold.otf" ]]; then
  "${repo_root}/scripts/fetch-og-fonts.sh"
fi

# Extract the TOML frontmatter block (between the first two `+++` lines).
extract_frontmatter() {
  awk '
    /^\+\+\+[[:space:]]*$/ { n++; next }
    n == 1 { print }
    n >= 2 { exit }
  ' "$1"
}

# Pull the value of `title = "..."` or `title = '...'` (first match) from a
# frontmatter block. Does not support multi-line (triple-quoted) strings;
# those are deliberately left unextracted (empty) so the caller can fail loudly.
extract_title() {
  local line
  line="$(printf '%s\n' "$1" | grep -m1 -E '^title[[:space:]]*=')"
  [[ -z "${line}" ]] && return
  # Triple-quoted (multi-line) strings aren't supported; bail out to empty.
  if [[ "${line}" =~ ^title[[:space:]]*=[[:space:]]*(\"\"\"|\'\'\') ]]; then
    return
  fi
  printf '%s\n' "${line}" | sed -E \
    -e 's/^title[[:space:]]*=[[:space:]]*"(.*)"[[:space:]]*$/\1/' \
    -e "s/^title[[:space:]]*=[[:space:]]*'(.*)'[[:space:]]*\$/\\1/"
}

is_draft() {
  printf '%s\n' "$1" | grep -qE '^draft[[:space:]]*=[[:space:]]*true[[:space:]]*$'
}

has_og_image_override() {
  printf '%s\n' "$1" | grep -qE '^og_image[[:space:]]*='
}

slugify_name() {
  # Strip a leading YYYY-MM-DD_ date prefix.
  printf '%s\n' "$1" | sed -E 's/^[0-9]{4}-[0-9]{2}-[0-9]{2}_//'
}

process_post() {
  local source_file="$1"
  local base_name="$2" # filename (no dir) or dirname, without extension

  local frontmatter title slug out_file
  frontmatter="$(extract_frontmatter "${source_file}")"

  if is_draft "${frontmatter}"; then
    echo "skip (draft): ${source_file}"
    return
  fi

  if has_og_image_override "${frontmatter}"; then
    echo "skip (og_image override): ${source_file}"
    return
  fi

  title="$(extract_title "${frontmatter}")"
  if [[ -z "${title}" ]] || [[ "${title}" =~ ^title[[:space:]]*= ]]; then
    echo "error: failed to extract title (unsupported format?): ${source_file}" >&2
    exit 1
  fi

  slug="$(slugify_name "${base_name}")"
  out_file="${out_dir}/${slug}.png"

  if [[ -f "${out_file}" && "${out_file}" -nt "${source_file}" ]]; then
    echo "skip (up to date): ${out_file}"
    return
  fi

  echo "generating: ${out_file} (title: ${title})"
  typst compile \
    --input "title=${title}" \
    --font-path "${fonts_dir}" \
    --ppi 72 \
    "${template}" \
    "${out_file}"
}

shopt -s nullglob

for entry in "${posts_dir}"/*; do
  name="$(basename "${entry}")"

  if [[ "${name}" == "_index.md" ]]; then
    continue
  fi

  if [[ -d "${entry}" ]]; then
    index_file="${entry}/index.md"
    if [[ -f "${index_file}" ]]; then
      process_post "${index_file}" "${name}"
    fi
  elif [[ "${entry}" == *.md ]]; then
    process_post "${entry}" "${name%.md}"
  fi
done
