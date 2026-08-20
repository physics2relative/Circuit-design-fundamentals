#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ANALOG_DIR="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
VIRTUOSO_WORK="$ANALOG_DIR/work/virtuoso"
OUTPUT_DIR="$PROJECT_DIR/figures/schematic"
RUN_DIR="$PROJECT_DIR/work/schematic_export"
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

if [[ ! -f "$VIRTUOSO_WORK/cds.lib" ]]; then
  echo "ERROR: cds.lib was not found at $VIRTUOSO_WORK/cds.lib" >&2
  exit 1
fi

mkdir -p "$OUTPUT_DIR" "$RUN_DIR"
rm -f \
  "$OUTPUT_DIR/01_dut_cs_resistive_load.png" \
  "$OUTPUT_DIR/02_tb_dc_bias.png" \
  "$OUTPUT_DIR/03_tb_ac_response.png" \
  "$OUTPUT_DIR/04_tb_transient.png"

export CDF_SCHEMATIC_OUTPUT_DIR="$OUTPUT_DIR"

(
  cd "$VIRTUOSO_WORK"
  timeout 180 "$VIRTUOSO_BIN" \
    -64 \
    -nocdsinit \
    -nographE \
    -restore "$SKILL_FILE" \
    -log "$RUN_DIR/virtuoso.log" \
    >"$RUN_DIR/stdout.log" 2>&1
)

expected=(
  "$OUTPUT_DIR/01_dut_cs_resistive_load.png"
  "$OUTPUT_DIR/02_tb_dc_bias.png"
  "$OUTPUT_DIR/03_tb_ac_response.png"
  "$OUTPUT_DIR/04_tb_transient.png"
)

for image in "${expected[@]}"; do
  if [[ ! -s "$image" ]]; then
    echo "ERROR: expected image was not generated: $image" >&2
    exit 1
  fi
  file "$image"
done

echo "Generated ${#expected[@]} schematic images in $OUTPUT_DIR"
