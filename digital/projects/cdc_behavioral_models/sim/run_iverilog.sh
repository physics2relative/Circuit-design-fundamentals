#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
mkdir -p sim/build

IVERILOG_BIN="${IVERILOG:-iverilog}"
VVP_BIN="${VVP:-vvp}"

run_tb() {
  local name="$1"
  shift
  echo "== $name =="
  "$IVERILOG_BIN" -g2005-sv -o "sim/build/${name}.vvp" "$@"
  "$VVP_BIN" "sim/build/${name}.vvp"
}

run_tb two_flop_sync     rtl/two_flop_sync.v tb/tb_two_flop_sync.v
run_tb pulse_crossing    rtl/two_flop_sync.v tb/tb_pulse_crossing.v
run_tb toggle_sync       rtl/toggle_sync.v tb/tb_toggle_sync.v
run_tb bad_bus_sync      rtl/bad_bus_sync.v tb/tb_bad_bus_sync.v

echo "All CDC behavioral simulations completed. VCD files are in sim/."
