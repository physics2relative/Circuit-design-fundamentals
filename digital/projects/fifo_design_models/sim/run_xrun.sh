#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

XRUN_BIN="${XRUN:-xrun}"
RUN_DIR="$ROOT/sim/xrun_work"
WAVE_TCL="$ROOT/sim/xrun_shm.tcl"
mkdir -p "$RUN_DIR"

if pgrep -u "${USER:-$(id -un)}" -af simvision | grep -E "fifo_design_models|xrun_work|waves\.shm" >/dev/null 2>&1; then
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
  mkdir -p "$tb_dir"
  rm -rf "$tb_dir/xcelium.d" "$tb_dir/waves.shm" "$tb_dir/xrun.log" \
         "$tb_dir/xrun.history" "$tb_dir/xrun.key" "$tb_dir/xrun.diag"

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

run_tb 01_sync_fifo_basic        rtl/sync_fifo.v       tb/01_tb_sync_fifo_basic.v
run_tb 02_sync_fifo_full_empty   rtl/sync_fifo.v       tb/02_tb_sync_fifo_full_empty.v
run_tb 03_sync_fifo_valid_ready  rtl/sync_fifo.v       tb/03_tb_sync_fifo_valid_ready.v
run_tb 04_async_fifo_gray_basic  rtl/async_fifo_gray.v tb/04_tb_async_fifo_gray_basic.v
run_tb 05_async_fifo_clock_ratio rtl/async_fifo_gray.v tb/05_tb_async_fifo_clock_ratio.v

echo "All FIFO simulations completed with xrun."
echo "Logs and SHM waveforms are under sim/xrun_work/<numbered_tb_name>/."
