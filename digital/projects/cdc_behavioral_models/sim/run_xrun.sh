#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

XRUN_BIN="${XRUN:-xrun}"
RUN_DIR="$ROOT/sim/xrun_work"
WAVE_TCL="$ROOT/sim/xrun_shm.tcl"
mkdir -p "$RUN_DIR"

if pgrep -u "${USER:-$(id -un)}" -af simvision | grep -E "cdc_behavioral_models|xrun_work|waves\.shm" >/dev/null 2>&1; then
  echo "ERROR: SimVision appears to be viewing this project's SHM output." >&2
  echo "Close the SimVision window first, then rerun this script." >&2
  echo "If you intentionally want to overwrite open SHM files, run:" >&2
  echo "  ALLOW_OPEN_SHM_OVERWRITE=1 bash sim/run_xrun.sh" >&2
  if [ "${ALLOW_OPEN_SHM_OVERWRITE:-0}" != "1" ]; then
    exit 2
  fi
fi

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

run_tb 01_no_sync_capture_xmodel        rtl/x_inject_dff.v rtl/no_sync_capture_xmodel.v tb/01_tb_no_sync_capture_xmodel.v
run_tb 02_two_flop_sync_resolved_xmodel rtl/x_inject_dff.v rtl/two_flop_sync_xmodel.v  tb/02_tb_two_flop_sync_resolved_xmodel.v
run_tb 03_two_flop_sync_unresolved_xmodel rtl/x_inject_dff.v rtl/two_flop_sync_xmodel.v tb/03_tb_two_flop_sync_unresolved_xmodel.v
run_tb 04_pulse_crossing_xmodel         rtl/x_inject_dff.v rtl/two_flop_sync_xmodel.v  tb/04_tb_pulse_crossing_xmodel.v
run_tb 05_toggle_sync_xmodel            rtl/x_inject_dff.v rtl/toggle_sync_xmodel.v    tb/05_tb_toggle_sync_xmodel.v
run_tb 06_bad_bus_sync_xmodel           rtl/x_inject_dff.v rtl/bad_bus_sync_xmodel.v   tb/06_tb_bad_bus_sync_xmodel.v

echo "All CDC xmodel simulations completed with xrun."
echo "Logs and SHM waveforms are under sim/xrun_work/<numbered_tb_name>/."
