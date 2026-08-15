#!/usr/bin/env bash
#
# Download the Noto Sans CJK JP fonts used to render OG images, verifying
# each file against a hardcoded sha256 checksum.
#
# Source: notofonts/noto-cjk (https://github.com/notofonts/noto-cjk),
# licensed under the SIL Open Font License, Version 1.1
# (https://github.com/notofonts/noto-cjk/blob/main/LICENSE). Files are
# fetched from the repository at a specific commit (pinned below, tagged
# "Sans2.004" at the time of pinning) rather than redistributed in this
# repo, per the OFL's permission to bundle/embed the fonts with software.
#
# Idempotent: if a target file already exists and matches its expected
# checksum, it is left untouched and nothing is downloaded.

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fonts_dir="${repo_root}/og/fonts"

# Pinned to a specific commit SHA (not a mutable tag/branch) so the download
# is reproducible. This is the commit tagged "Sans2.004" in notofonts/noto-cjk.
noto_cjk_commit="523d033d6cb47f4a80c58a35753646f5c3608a78"
base_url="https://raw.githubusercontent.com/notofonts/noto-cjk/${noto_cjk_commit}/Sans/OTF/Japanese"

# Expected sha256 checksums. These were recorded from the font files
# previously committed to this repo (verified to be byte-identical to the
# files at the pinned commit above) via `shasum -a 256`.
#
# IMPORTANT: if you ever change `noto_cjk_commit` above, you must also
# recompute and update these checksums, and the cache key in
# .github/workflows/deployment.yml (search for "og-fonts-") must be updated
# to match.
declare -A expected_sha256=(
  ["NotoSansCJKjp-Regular.otf"]="68a3fc98800b2a27b371f2fb79991daf3633bd89309d4ffaa6946fd587f375b5"
  ["NotoSansCJKjp-Bold.otf"]="e53dcb0dcb2922e45d01aae1ebd2f382bb81d4229b18b6b883bd170678af1f76"
)

sha256_of() {
  shasum -a 256 "$1" | awk '{print $1}'
}

verify_or_download() {
  local filename="$1"
  local expected="${expected_sha256[${filename}]}"
  local dest="${fonts_dir}/${filename}"

  if [[ -f "${dest}" ]]; then
    local actual
    actual="$(sha256_of "${dest}")"
    if [[ "${actual}" == "${expected}" ]]; then
      echo "ok (cached): ${filename}"
      return
    fi
    echo "warning: ${dest} exists but checksum does not match expected value; re-downloading" >&2
  fi

  echo "downloading: ${filename}"
  local tmp_file
  tmp_file="$(mktemp "${fonts_dir}/.${filename}.XXXXXX")"
  # Ensure the temp file is cleaned up if curl fails partway through.
  trap 'rm -f "${tmp_file}"' RETURN

  curl -fsSL --retry 3 -o "${tmp_file}" "${base_url}/${filename}"

  local actual
  actual="$(sha256_of "${tmp_file}")"
  if [[ "${actual}" != "${expected}" ]]; then
    echo "error: checksum mismatch for ${filename}" >&2
    echo "  expected: ${expected}" >&2
    echo "  actual:   ${actual}" >&2
    rm -f "${tmp_file}"
    exit 1
  fi

  mv "${tmp_file}" "${dest}"
  trap - RETURN
  echo "ok (downloaded, verified): ${filename}"
}

mkdir -p "${fonts_dir}"

for filename in "${!expected_sha256[@]}"; do
  verify_or_download "${filename}"
done
