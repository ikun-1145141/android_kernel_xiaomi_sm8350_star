#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE_DIR="$ROOT_DIR/anykernel3"
IMAGE="${IMAGE:-$ROOT_DIR/out/arch/arm64/boot/Image}"
OUT_DIR="${OUT_DIR:-$ROOT_DIR/out}"
PACKAGE_NAME="${PACKAGE_NAME:-ikun-NekoMake-Lineage-5.4.302-star-mars-ReSukiSU-4.2.0-rc1}"
PACKAGE="$OUT_DIR/$PACKAGE_NAME.zip"

if [ ! -f "$IMAGE" ]; then
  echo "Kernel image not found: $IMAGE" >&2
  exit 1
fi

command -v zip >/dev/null 2>&1 || {
  echo "The zip utility is required." >&2
  exit 1
}

case "$IMAGE" in
  *.gz) ;;
  *)
    command -v gzip >/dev/null 2>&1 || {
      echo "The gzip utility is required for an uncompressed Image." >&2
      exit 1
    }
    ;;
esac

mkdir -p "$OUT_DIR"
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

cp -a "$TEMPLATE_DIR/anykernel.sh" "$TEMPLATE_DIR/LICENSE" "$TEMPLATE_DIR/tools" "$TEMPLATE_DIR/META-INF" "$STAGE/"
case "$IMAGE" in
  *.gz) cp -f "$IMAGE" "$STAGE/Image.gz" ;;
  *) gzip -n -9 -c "$IMAGE" > "$STAGE/Image.gz" ;;
esac
chmod 755 "$STAGE/META-INF/com/google/android/update-binary" "$STAGE/tools"/*

rm -f "$PACKAGE"
(
  cd "$STAGE"
  zip -qr -9 "$PACKAGE" .
)

echo "Built: $PACKAGE"
sha256sum "$PACKAGE"
