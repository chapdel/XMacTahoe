#!/bin/bash
# Publish a release: bump VERSION, commit, tag, build the archive, SHA256SUMS (+ optional GPG signature), GitHub release.
# Usage: tools/release.sh X.Y.Z "release notes (markdown)" [--sign]
set -euo pipefail
V="${1:?version}"; NOTES="${2:?notes}"; SIGN=0; [ "${3:-}" = --sign ] && SIGN=1
B="$(cd "$(dirname "$0")/.." && pwd)"; cd "$B"; NAME=$(basename "$B")
# a published version is never rebuilt: its archive and checksum may already be installed somewhere
if git rev-parse -q --verify "refs/tags/v$V" >/dev/null || git ls-remote --exit-code --tags origin "v$V" >/dev/null 2>&1; then
  echo "v$V already exists: publish a new version instead of moving the tag"; exit 1; fi
echo "$V" > VERSION
{ echo "## $V — $(date +%Y-%m-%d)"; echo; echo "$NOTES"; echo; cat CHANGELOG.md 2>/dev/null; } > CHANGELOG.new && mv CHANGELOG.new CHANGELOG.md
python3 tools/check-package.py >/dev/null || { echo "package check failed"; exit 1; }
git add -A; git commit -q -m "Release $V" || true; git push -q origin HEAD; git tag -a "v$V" -m "$NAME v$V"; git push -q origin "v$V"
OUT="$B/../$NAME-v$V.tar.gz"; tar --exclude="$NAME/.git" --exclude="__pycache__" -C "$B/.." -czf "$OUT" "$NAME"
( cd "$B/.." && sha256sum "$NAME-v$V.tar.gz" > "$B/../SHA256SUMS" )
ASSETS=("$OUT" "$B/../SHA256SUMS")
if [ $SIGN = 1 ]; then gpg --armor --detach-sign --output "$OUT.asc" "$OUT" && ASSETS+=("$OUT.asc"); fi
gh release create "v$V" "${ASSETS[@]}" --title "$NAME v$V" --notes "$NOTES

SHA-256: \`$(cut -d' ' -f1 "$B/../SHA256SUMS")\`$( [ $SIGN = 1 ] && echo ' — signed with the maintainer GPG key (.asc)')" >/dev/null 2>&1 || true
n=$(gh release view "v$V" --json assets --jq '.assets|length'); [ "$n" = 0 ] && gh release upload "v$V" "${ASSETS[@]}" --clobber >/dev/null
gh release edit "v$V" --draft=false --tag "v$V" >/dev/null 2>&1 || true
gh release view "v$V" --json url --jq '.url'
