#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

XRUN_BIN="${XRUN:-xrun}"
RUN_DIR="sim/xrun_work"
mkdir -p "$RUN_DIR"

run_tb() {
  local name="$1"
  shift
  echo "== $name =="
  rm -rf "$RUN_DIR/$name"
  mkdir -p "$RUN_DIR/$name"
  "$XRUN_BIN" \
    -64bit \
    -sv \
    -timescale 1ns/1ps \
    -access +rwc \
    -l "$RUN_DIR/$name/xrun.log" \
    -xmlibdirname "$RUN_DIR/$name/xcelium.d" \
    "$@"
}

run_tb two_flop_sync  rtl/two_flop_sync.v  tb/tb_two_flop_sync.v
run_tb pulse_crossing rtl/two_flop_sync.v  tb/tb_pulse_crossing.v
run_tb toggle_sync    rtl/toggle_sync.v    tb/tb_toggle_sync.v
run_tb bad_bus_sync   rtl/bad_bus_sync.v   tb/tb_bad_bus_sync.v

echo "All CDC behavioral simulations completed with xrun."
echo "Logs are under $RUN_DIR/. VCD files are under sim/."
