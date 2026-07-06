#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

XRUN_BIN="${XRUN:-xrun}"
RUN_DIR="$ROOT/sim/xrun_work"
WAVE_TCL="$ROOT/sim/xrun_shm.tcl"
mkdir -p "$RUN_DIR"

run_tb() {
  local name="$1"
  shift
  local tb_dir="$RUN_DIR/$name"
  local files=()

  echo "== $name =="
  rm -rf "$tb_dir"
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

run_tb no_sync_capture rtl/no_sync_capture.v tb/tb_no_sync_capture.v
run_tb two_flop_sync   rtl/two_flop_sync.v  tb/tb_two_flop_sync.v
run_tb pulse_crossing rtl/two_flop_sync.v  tb/tb_pulse_crossing.v
run_tb toggle_sync    rtl/toggle_sync.v    tb/tb_toggle_sync.v
run_tb bad_bus_sync   rtl/bad_bus_sync.v   tb/tb_bad_bus_sync.v

echo "All CDC behavioral simulations completed with xrun."
echo "Logs and SHM waveforms are under sim/xrun_work/<tb_name>/."
