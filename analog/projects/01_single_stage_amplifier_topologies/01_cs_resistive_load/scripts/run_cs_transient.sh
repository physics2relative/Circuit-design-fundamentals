#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJECT_DIR=$(cd "$SCRIPT_DIR/.." && pwd)
REPO_ROOT=$(cd "$PROJECT_DIR/../../../.." && pwd)
TEMPLATE="$PROJECT_DIR/netlists/tb_p01_cs_transient_template.scs"
SOURCE_DIR="$PROJECT_DIR/work/transient_sources"
RUN_AND_PLOT="$REPO_ROOT/analog/sim/run_and_plot.py"

mkdir -p "$SOURCE_DIR"

prepare_amplitude() {
  local variant=$1
  local amplitude=$2
  cp "$TEMPLATE" "$SOURCE_DIR/$variant.scs"
  sed -i "s/VIN_AMP=10m/VIN_AMP=$amplitude/" "$SOURCE_DIR/$variant.scs"
}

run_case() {
  local variant=$1
  local label=$2
  python3 "$RUN_AND_PLOT" \
    --project "$PROJECT_DIR" \
    --tb tb_p01_cs_transient \
    --netlist "$SOURCE_DIR/$variant.scs" \
    --variant "$variant" \
    --label "$label"
}

prepare_amplitude 01_low_frequency 10m
cp "$TEMPLATE" "$SOURCE_DIR/02_f3db.scs"
sed -i 's/FIN=1M/FIN=365.235M/; s/TSTOP=5u/TSTOP=50n/; s/MAXSTEP=5n/MAXSTEP=20p/' \
  "$SOURCE_DIR/02_f3db.scs"
prepare_amplitude 03_amp_50m 50m
prepare_amplitude 04_amp_100m 100m
prepare_amplitude 05_clip_180m 180m
prepare_amplitude 06_amp_200m 200m
prepare_amplitude 07_clip_220m 220m
prepare_amplitude 08_clip_250m 250m
prepare_amplitude 09_clip_300m 300m
prepare_amplitude 10_clip_350m 350m
prepare_amplitude 11_clip_380m 380m

run_case 01_low_frequency "FIN = 1 MHz, VIN_AMP = 10 mV, CL = 100 fF"
run_case 02_f3db "FIN = 365.235 MHz, VIN_AMP = 10 mV, CL = 100 fF"
run_case 03_amp_50m "FIN = 1 MHz, VIN_AMP = 50 mV, CL = 100 fF"
run_case 04_amp_100m "FIN = 1 MHz, VIN_AMP = 100 mV, CL = 100 fF"
run_case 05_clip_180m "FIN = 1 MHz, VIN_AMP = 180 mV, CL = 100 fF"
run_case 06_amp_200m "FIN = 1 MHz, VIN_AMP = 200 mV, CL = 100 fF"
run_case 07_clip_220m "FIN = 1 MHz, VIN_AMP = 220 mV, CL = 100 fF"
run_case 08_clip_250m "FIN = 1 MHz, VIN_AMP = 250 mV, CL = 100 fF"
run_case 09_clip_300m "FIN = 1 MHz, VIN_AMP = 300 mV, CL = 100 fF"
run_case 10_clip_350m "FIN = 1 MHz, VIN_AMP = 350 mV, CL = 100 fF"
run_case 11_clip_380m "FIN = 1 MHz, VIN_AMP = 380 mV, CL = 100 fF"

python3 "$SCRIPT_DIR/analyze_cs_transient.py"
