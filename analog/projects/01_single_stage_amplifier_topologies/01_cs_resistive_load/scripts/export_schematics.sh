#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ANALOG_DIR="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
VIRTUOSO_WORK="$ANALOG_DIR/work/virtuoso"
OUTPUT_DIR="$PROJECT_DIR/figures/schematic"
RUN_DIR="$PROJECT_DIR/work/schematic_vector_export"
EPS_DIR="$RUN_DIR/eps"
SKILL_FILE="$SCRIPT_DIR/export_schematics.il"
VIRTUOSO_BIN="${VIRTUOSO_BIN:-$(command -v virtuoso || true)}"

if [[ -z "$VIRTUOSO_BIN" || ! -x "$VIRTUOSO_BIN" ]]; then
  echo "ERROR: virtuoso executable was not found." >&2
  exit 1
fi

if [[ -z "${DISPLAY:-}" ]]; then
  echo "ERROR: DISPLAY is not set. Run this script from a MobaXterm X11 session." >&2
  exit 1
fi

for command_name in ps2pdf pdftocairo; do
  if ! command -v "$command_name" >/dev/null 2>&1; then
    echo "ERROR: required converter was not found: $command_name" >&2
    exit 1
  fi
done

if [[ ! -f "$VIRTUOSO_WORK/cds.lib" ]]; then
  echo "ERROR: cds.lib was not found at $VIRTUOSO_WORK/cds.lib" >&2
  exit 1
fi

mkdir -p "$OUTPUT_DIR" "$EPS_DIR"
rm -f "$EPS_DIR"/*.eps "$RUN_DIR"/*.pdf

cat > "$RUN_DIR/.cdsplotinit" <<'PLOTINIT'
EPS|Encapsulated Postscript: \
	:manufacturer=Adobe: \
	:type=epsfC: \
	:maximumPages#1: \
	:resolution#300: \
	:paperSize="Unlimited" 72000 72000:
PLOTINIT

ln -sfn "$VIRTUOSO_WORK/cds.lib" "$RUN_DIR/cds.lib"
export CDF_SCHEMATIC_EPS_DIR="$EPS_DIR"

(
  cd "$RUN_DIR"
  timeout 180 "$VIRTUOSO_BIN" \
    -64 \
    -nocdsinit \
    -nographE \
    -restore "$SKILL_FILE" \
    -log "$RUN_DIR/virtuoso.log" \
    >"$RUN_DIR/stdout.log" 2>&1
)

names=(
  01_dut_cs_resistive_load
  02_tb_dc_bias
  03_tb_ac_response
  04_tb_transient
)

for name in "${names[@]}"; do
  eps="$EPS_DIR/$name.eps"
  pdf="$RUN_DIR/$name.pdf"
  svg="$OUTPUT_DIR/$name.svg"

  if [[ ! -s "$eps" ]]; then
    echo "ERROR: expected EPS was not generated: $eps" >&2
    exit 1
  fi

  ps2pdf -dEPSCrop "$eps" "$pdf"
  pdftocairo -svg "$pdf" "$svg"

  # Cadence color EPS is transparent. Add the original editor-style black canvas so
  # the native Virtuoso layer colors retain their expected appearance.
  sed -i '/<g id="surface1">/a <rect width="100%" height="100%" fill="black"/>' "$svg"

  if grep -q '<image' "$svg"; then
    echo "ERROR: raster content was embedded in SVG: $svg" >&2
    exit 1
  fi

  file "$svg"
done

rm -f "$RUN_DIR"/*.pdf

echo "Generated ${#names[@]} vector schematic images in $OUTPUT_DIR"
