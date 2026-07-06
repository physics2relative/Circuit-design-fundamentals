#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

XRUN_BIN="${XRUN:-xrun}"
RUN_BASE="$ROOT/sim/xrun_work"
RUN_ID="${XRUN_RUN_ID:-$(date +%Y%m%d_%H%M%S)}"
RUN_DIR="$RUN_BASE/$RUN_ID"
WAVE_TCL="$ROOT/sim/xrun_shm.tcl"
mkdir -p "$RUN_DIR"
ln -sfn "$RUN_DIR" "$RUN_BASE/latest"

run_tb() {
  local name="$1"
  shift
  local tb_dir="$RUN_DIR/$name"
  local files=()

  echo "== $name =="
  mkdir -p "$tb_dir"

  for f in "$@"; do
    files+=("$ROOT/$f")
  done

  (
    cd "$tb_dir"
    "$XRUN_BIN" \
      -64bit \
      -sv \
      -timescale 1ns/1ps \
      -access +rwc \
      -l xrun.log \
      -xmlibdirname xcelium.d \
      -input "$WAVE_TCL" \
      "${files[@]}"
  )
}

run_tb 01_no_sync_capture_xmodel rtl/x_inject_dff.v rtl/no_sync_capture_xmodel.v tb/01_tb_no_sync_capture_xmodel.v
run_tb 02_two_flop_sync_xmodel  rtl/x_inject_dff.v rtl/two_flop_sync_xmodel.v  tb/02_tb_two_flop_sync_xmodel.v
run_tb 03_pulse_crossing_xmodel rtl/x_inject_dff.v rtl/two_flop_sync_xmodel.v  tb/03_tb_pulse_crossing_xmodel.v
run_tb 04_toggle_sync_xmodel    rtl/x_inject_dff.v rtl/toggle_sync_xmodel.v    tb/04_tb_toggle_sync_xmodel.v
run_tb 05_bad_bus_sync_xmodel   rtl/x_inject_dff.v rtl/bad_bus_sync_xmodel.v   tb/05_tb_bad_bus_sync_xmodel.v

echo "All CDC xmodel simulations completed with xrun."
echo "Run output: $RUN_DIR"
echo "Latest run symlink: $RUN_BASE/latest"
echo "SHM waveforms are under $RUN_DIR/<numbered_tb_name>/waves.shm."
