#!/usr/bin/env python3
"""Measure and compare CS transient bandwidth, compression, and clipping."""

from __future__ import annotations

import csv
import math
import shutil
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
matplotlib.rcParams["svg.hashsalt"] = "circuit-design-fundamentals"
import matplotlib.pyplot as plt  # noqa: E402
import numpy as np  # noqa: E402


PROJECT = Path(__file__).resolve().parents[1]
RESULT_ROOT = PROJECT / "figures" / "generated" / "tb_p01_cs_transient"
COMPARISON_DIR = RESULT_ROOT / "05_clipping_comparison"
VDD = 1.1
VIN_BIAS = 0.714
VOUT_BIAS = 0.55
HIGH_RAIL_THRESHOLD = 1.09
LOW_RAIL_THRESHOLD = 0.01

CASES = {
    "01_low_frequency": {
        "condition": "1 MHz / 10 mV",
        "frequency": 1.0e6,
        "cycles": 3,
        "input_label": "10 mV",
        "amplitude_mv": 10.0,
    },
    "02_f3db": {
        "condition": "365.235 MHz / 10 mV",
        "frequency": 365.235e6,
        "cycles": 10,
        "input_label": "10 mV",
        "amplitude_mv": 10.0,
    },
    "03_amp_50m": {
        "condition": "1 MHz / 50 mV",
        "frequency": 1.0e6,
        "cycles": 3,
        "input_label": "50 mV",
        "amplitude_mv": 50.0,
    },
    "04_amp_100m": {
        "condition": "1 MHz / 100 mV",
        "frequency": 1.0e6,
        "cycles": 3,
        "input_label": "100 mV",
        "amplitude_mv": 100.0,
    },
    "05_clip_180m": {
        "condition": "1 MHz / 180 mV",
        "frequency": 1.0e6,
        "cycles": 3,
        "input_label": "180 mV",
        "amplitude_mv": 180.0,
    },
    "06_amp_200m": {
        "condition": "1 MHz / 200 mV",
        "frequency": 1.0e6,
        "cycles": 3,
        "input_label": "200 mV",
        "amplitude_mv": 200.0,
    },
    "07_clip_220m": {
        "condition": "1 MHz / 220 mV",
        "frequency": 1.0e6,
        "cycles": 3,
        "input_label": "220 mV",
        "amplitude_mv": 220.0,
    },
    "08_clip_250m": {
        "condition": "1 MHz / 250 mV",
        "frequency": 1.0e6,
        "cycles": 3,
        "input_label": "250 mV",
        "amplitude_mv": 250.0,
    },
    "09_clip_300m": {
        "condition": "1 MHz / 300 mV",
        "frequency": 1.0e6,
        "cycles": 3,
        "input_label": "300 mV",
        "amplitude_mv": 300.0,
    },
    "10_clip_350m": {
        "condition": "1 MHz / 350 mV",
        "frequency": 1.0e6,
        "cycles": 3,
        "input_label": "350 mV",
        "amplitude_mv": 350.0,
    },
    "11_clip_380m": {
        "condition": "1 MHz / 380 mV",
        "frequency": 1.0e6,
        "cycles": 3,
        "input_label": "380 mV",
        "amplitude_mv": 380.0,
    },
}

AMPLITUDE_VARIANTS = (
    "01_low_frequency",
    "03_amp_50m",
    "04_amp_100m",
    "05_clip_180m",
    "06_amp_200m",
    "07_clip_220m",
    "08_clip_250m",
    "09_clip_300m",
    "10_clip_350m",
    "11_clip_380m",
)
CLIPPING_VARIANTS = (
    "05_clip_180m",
    "06_amp_200m",
    "07_clip_220m",
    "08_clip_250m",
    "09_clip_300m",
    "10_clip_350m",
    "11_clip_380m",
)
PUBLIC_CASE_VARIANTS = (
    "01_low_frequency",
    "02_f3db",
    "03_amp_50m",
    "04_amp_100m",
)


def read_waveform(path: Path) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    with path.open(encoding="utf-8", newline="") as handle:
        rows = list(csv.DictReader(handle))
    time = np.asarray([float(row["x"]) for row in rows])
    vin_mv = np.asarray([float(row["VIN - 0.714 V"]) for row in rows])
    vout_mv = np.asarray([float(row["VOUT - 0.55 V"]) for row in rows])
    return time, vin_mv, vout_mv


def read_mos_region(path: Path) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    with path.open(encoding="utf-8", newline="") as handle:
        rows = list(csv.DictReader(handle))
    time = np.asarray([float(row["time"]) for row in rows])
    region = np.asarray([float(row["I0.NM0:region"]) for row in rows])
    margin = np.asarray([float(row["I0.NM0:sat_margin_abs"]) for row in rows])
    return time, region, margin


def fit_harmonics(
    time: np.ndarray,
    values: np.ndarray,
    frequency: float,
    harmonic_count: int = 10,
) -> tuple[float, float, float, float]:
    omega_time = 2.0 * math.pi * frequency * time
    columns: list[np.ndarray] = []
    for harmonic in range(1, harmonic_count + 1):
        columns.extend((np.sin(harmonic * omega_time), np.cos(harmonic * omega_time)))
    columns.append(np.ones_like(time))
    coefficients = np.linalg.lstsq(np.column_stack(columns), values, rcond=None)[0]
    amplitudes = np.asarray(
        [
            math.hypot(coefficients[2 * index], coefficients[2 * index + 1])
            for index in range(harmonic_count)
        ]
    )
    phase_deg = math.degrees(math.atan2(coefficients[1], coefficients[0]))
    thd_percent = 100.0 * float(np.linalg.norm(amplitudes[1:])) / float(amplitudes[0])
    return float(amplitudes[0]), float(phase_deg), float(coefficients[-1]), thd_percent


def time_fraction_percent(time: np.ndarray, condition: np.ndarray) -> float:
    """Return a duration-weighted fraction for adaptively sampled waveforms."""
    if len(time) < 2:
        return 100.0 if bool(condition[0]) else 0.0
    interval_width = np.diff(time)
    endpoint_weight = 0.5 * (
        condition[:-1].astype(float) + condition[1:].astype(float)
    )
    return 100.0 * float(np.sum(endpoint_weight * interval_width)) / float(
        time[-1] - time[0]
    )


def measure_case(directory: str, config: dict[str, object]) -> dict[str, float | str]:
    output_dir = RESULT_ROOT / directory
    frequency = float(config["frequency"])
    cycles = int(config["cycles"])
    time, vin_mv, vout_mv = read_waveform(output_dir / "05_cs_transient_waveform.csv")
    start_time = time[-1] - cycles / frequency
    mask = time >= start_time
    fit_time = time[mask]
    fit_vin = vin_mv[mask]
    fit_vout = vout_mv[mask]
    fit_vin_absolute = VIN_BIAS + fit_vin / 1000.0
    fit_vout_absolute = VOUT_BIAS + fit_vout / 1000.0

    vin_amplitude, vin_phase, vin_offset, vin_thd = fit_harmonics(
        fit_time, fit_vin, frequency
    )
    vout_amplitude, vout_phase, vout_offset, vout_thd = fit_harmonics(
        fit_time, fit_vout, frequency
    )
    gain = vout_amplitude / vin_amplitude
    gain_db = 20.0 * math.log10(gain)
    phase = (vout_phase - vin_phase) % 360.0

    op_time, region, sat_margin = read_mos_region(
        output_dir / "operating_point_tran_tran.csv"
    )
    op_mask = op_time >= start_time
    active_time = op_time[op_mask]
    active_region = region[op_mask]
    region_percentages = {
        code: time_fraction_percent(
            active_time, np.isclose(active_region, float(code))
        )
        for code in range(4)
    }

    return {
        "variant": directory,
        "condition": str(config["condition"]),
        "frequency_hz": frequency,
        "nominal_input_amplitude_mv": float(config["amplitude_mv"]),
        "fit_cycles": cycles,
        "vin_amplitude_mv": vin_amplitude,
        "vout_amplitude_mv": vout_amplitude,
        "vin_pp_mv": float(np.ptp(fit_vin)),
        "vout_pp_mv": float(np.ptp(fit_vout)),
        "gain_v_per_v": gain,
        "gain_db": gain_db,
        "phase_deg": phase,
        "vin_center_v": VIN_BIAS + vin_offset / 1000.0,
        "vout_center_v": VOUT_BIAS + vout_offset / 1000.0,
        "vin_min_v": float(np.min(fit_vin_absolute)),
        "vin_max_v": float(np.max(fit_vin_absolute)),
        "vout_min_v": float(np.min(fit_vout_absolute)),
        "vout_max_v": float(np.max(fit_vout_absolute)),
        "vin_thd_percent": vin_thd,
        "vout_thd_percent": vout_thd,
        "region_0_percent": region_percentages[0],
        "region_1_percent": region_percentages[1],
        "region_2_percent": region_percentages[2],
        "region_3_percent": region_percentages[3],
        "saturation_region_percent": region_percentages[2],
        "high_rail_dwell_percent": time_fraction_percent(
            fit_time, fit_vout_absolute >= HIGH_RAIL_THRESHOLD
        ),
        "low_rail_dwell_percent": time_fraction_percent(
            fit_time, fit_vout_absolute <= LOW_RAIL_THRESHOLD
        ),
        "minimum_sat_margin_v": float(np.min(sat_margin[op_mask])),
    }


def write_case_measurements(result: dict[str, float | str]) -> None:
    output_dir = RESULT_ROOT / str(result["variant"])
    with (output_dir / "measurements.csv").open(
        "w", encoding="utf-8", newline=""
    ) as handle:
        writer = csv.writer(handle)
        writer.writerow(["metric", "value"])
        for key, value in result.items():
            writer.writerow([key, value])

    compression = float(result.get("compression_db", 0.0))
    lines = [
        f"# {result['condition']} Transient Measurements",
        "",
        f"- 입력 fundamental 진폭: `{float(result['vin_amplitude_mv']):.4f} mV`",
        f"- 출력 fundamental 진폭: `{float(result['vout_amplitude_mv']):.4f} mV`",
        f"- 입력 Vpp: `{float(result['vin_pp_mv']):.4f} mV`",
        f"- 출력 Vpp: `{float(result['vout_pp_mv']):.4f} mV`",
        f"- Fundamental gain: `{float(result['gain_v_per_v']):.6f} V/V`, "
        f"`{float(result['gain_db']):.4f} dB`",
        f"- 10 mV 기준 gain 변화: `{compression:.4f} dB`",
        f"- 출력 THD(2~10차): `{float(result['vout_thd_percent']):.4f}%`",
        f"- 입력 범위: `{float(result['vin_min_v']):.6f}~{float(result['vin_max_v']):.6f} V`",
        f"- 출력 범위: `{float(result['vout_min_v']):.6f}~{float(result['vout_max_v']):.6f} V`",
        f"- Region 0/1/2/3 비율: "
        f"`{float(result['region_0_percent']):.2f}% / "
        f"{float(result['region_1_percent']):.2f}% / "
        f"{float(result['region_2_percent']):.2f}% / "
        f"{float(result['region_3_percent']):.2f}%`",
        f"- VOUT >= {HIGH_RAIL_THRESHOLD:.2f} V 체류 비율: "
        f"`{float(result['high_rail_dwell_percent']):.2f}%`",
        f"- VOUT <= {LOW_RAIL_THRESHOLD:.2f} V 체류 비율: "
        f"`{float(result['low_rail_dwell_percent']):.2f}%`",
        f"- 최소 `VDS-VDSAT` margin: `{float(result['minimum_sat_margin_v']):.6f} V`",
        f"- 출력 위상: 입력 기준 `{float(result['phase_deg']):.3f}°`",
        "",
        "마지막 정상상태 구간을 10차 harmonic least-squares fitting하여 "
        "fundamental gain과 THD를 계산하였다.",
        "",
        "현재 PDK 모델의 region 표기는 0=cutoff/off, 1=triode, "
        "2=saturation, 3=weak-conduction/subthreshold로 해석하였다.",
        "",
    ]
    (output_dir / "MEASUREMENTS.md").write_text("\n".join(lines), encoding="utf-8")


def last_cycle(directory: str, frequency: float) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    time, vin_mv, vout_mv = read_waveform(
        RESULT_ROOT / directory / "05_cs_transient_waveform.csv"
    )
    start = time[-1] - 1.0 / frequency
    mask = time >= start
    relative_time_us = (time[mask] - start) * 1.0e6
    return (
        relative_time_us,
        VIN_BIAS + vin_mv[mask] / 1000.0,
        VOUT_BIAS + vout_mv[mask] / 1000.0,
    )


def write_comparison_csv(results: dict[str, dict[str, float | str]]) -> None:
    columns = (
        "nominal_input_amplitude_mv",
        "gain_v_per_v",
        "gain_db",
        "compression_db",
        "vout_thd_percent",
        "vout_min_v",
        "vout_max_v",
        "region_0_percent",
        "region_1_percent",
        "region_2_percent",
        "region_3_percent",
        "high_rail_dwell_percent",
        "low_rail_dwell_percent",
        "minimum_sat_margin_v",
    )
    with (COMPARISON_DIR / "clipping_sweep_measurements.csv").open(
        "w", encoding="utf-8", newline=""
    ) as handle:
        writer = csv.writer(handle)
        writer.writerow(columns)
        for variant in AMPLITUDE_VARIANTS:
            writer.writerow([results[variant][column] for column in columns])


def plot_clipping_comparison(results: dict[str, dict[str, float | str]]) -> None:
    if COMPARISON_DIR.exists():
        shutil.rmtree(COMPARISON_DIR)
    COMPARISON_DIR.mkdir(parents=True, exist_ok=True)
    amplitude_results = [results[name] for name in AMPLITUDE_VARIANTS]
    amplitudes = np.asarray(
        [float(item["nominal_input_amplitude_mv"]) for item in amplitude_results]
    )
    gains = np.asarray([float(item["gain_v_per_v"]) for item in amplitude_results])
    compression = np.asarray([float(item["compression_db"]) for item in amplitude_results])
    thd = np.asarray([float(item["vout_thd_percent"]) for item in amplitude_results])

    figure, axes = plt.subplots(3, 1, figsize=(8.8, 9.0), sharex=True)
    axes[0].plot(amplitudes, gains, marker="o", linewidth=2.0, color="#0072B2")
    axes[0].set_ylabel("Fundamental gain (V/V)")
    axes[0].set_title("CS Gain Compression and Distortion vs. Input Amplitude")
    axes[1].plot(amplitudes, compression, marker="o", linewidth=2.0, color="#D55E00")
    axes[1].axhline(-1.0, color="#666666", linestyle="--", linewidth=1.0, label="-1 dB")
    axes[1].set_ylabel("Gain change (dB)")
    axes[1].legend()
    axes[2].plot(amplitudes, thd, marker="o", linewidth=2.0, color="#009E73")
    axes[2].set_xlabel("Input peak amplitude (mV)")
    axes[2].set_ylabel("Output THD (%)")
    for axis in axes:
        axis.grid(True, alpha=0.3)
    figure.tight_layout()
    figure.savefig(
        COMPARISON_DIR / "01_gain_compression_and_thd.svg",
        format="svg",
        metadata={"Date": None},
    )
    plt.close(figure)

    colors = plt.get_cmap("viridis")(
        np.linspace(0.08, 0.92, len(CLIPPING_VARIANTS))
    )
    figure, axis = plt.subplots(figsize=(9.2, 5.8), constrained_layout=True)
    for variant, color in zip(CLIPPING_VARIANTS, colors):
        result = results[variant]
        time_us, _, vout = last_cycle(variant, float(result["frequency_hz"]))
        axis.plot(
            time_us,
            vout,
            color=color,
            linewidth=1.8,
            label=str(CASES[variant]["input_label"]),
        )
    axis.axhline(VDD, color="#333333", linestyle="--", linewidth=1.0, label="VDD")
    axis.set_title("CS Output Waveforms: 180–380 mV Peak Input")
    axis.set_xlabel("Time within final cycle (µs)")
    axis.set_ylabel("VOUT (V)")
    axis.set_xlim(0.0, 1.0)
    axis.grid(True, alpha=0.3)
    axis.legend(title="VIN peak", ncol=2)
    figure.savefig(
        COMPARISON_DIR / "02_clipped_output_waveforms.svg",
        format="svg",
        metadata={"Date": None},
    )
    plt.close(figure)

    clip_results = [results[name] for name in CLIPPING_VARIANTS]
    clip_amplitudes = np.asarray(
        [float(item["nominal_input_amplitude_mv"]) for item in clip_results]
    )
    vout_minimum = np.asarray([float(item["vout_min_v"]) for item in clip_results])
    vout_maximum = np.asarray([float(item["vout_max_v"]) for item in clip_results])

    figure, axis = plt.subplots(figsize=(8.8, 5.8), constrained_layout=True)
    axis.fill_between(
        clip_amplitudes,
        vout_minimum,
        vout_maximum,
        color="#56B4E9",
        alpha=0.18,
        label="Output swing envelope",
    )
    axis.plot(
        clip_amplitudes,
        vout_minimum,
        marker="o",
        linewidth=2.0,
        color="#D55E00",
        label="VOUT minimum",
    )
    axis.plot(
        clip_amplitudes,
        vout_maximum,
        marker="o",
        linewidth=2.0,
        color="#0072B2",
        label="VOUT maximum",
    )
    axis.axhline(VDD, color="#333333", linestyle="--", linewidth=1.0, label="VDD")
    axis.axhline(
        HIGH_RAIL_THRESHOLD,
        color="#666666",
        linestyle=":",
        linewidth=1.0,
        label="High-rail threshold (1.09 V)",
    )
    axis.axhline(
        VOUT_BIAS,
        color="#009E73",
        linestyle=":",
        linewidth=1.0,
        label="Nominal VOUT bias",
    )
    axis.set_title("CS Output Swing Envelope vs. Input Amplitude")
    axis.set_xlabel("Input peak amplitude (mV)")
    axis.set_ylabel("VOUT extrema (V)")
    axis.set_xlim(170.0, 390.0)
    axis.set_ylim(0.0, 1.15)
    axis.grid(True, alpha=0.3)
    axis.legend(ncol=2)
    figure.savefig(
        COMPARISON_DIR / "03_output_swing_envelope.svg",
        format="svg",
        metadata={"Date": None},
    )
    plt.close(figure)
    figure, axis = plt.subplots(figsize=(9.0, 5.8), constrained_layout=True)
    region_labels = (
        ("region_0_percent", "Region 0: cutoff/off", "#CC79A7"),
        ("region_1_percent", "Region 1: triode", "#D55E00"),
        ("region_2_percent", "Region 2: saturation", "#0072B2"),
        ("region_3_percent", "Region 3: weak conduction", "#009E73"),
    )
    for key, label, color in region_labels:
        axis.plot(
            clip_amplitudes,
            [float(item[key]) for item in clip_results],
            marker="o",
            linewidth=2.0,
            label=label,
            color=color,
        )
    axis.set_title("NMOS Operating-Region Fraction vs. Input Amplitude")
    axis.set_xlabel("Input peak amplitude (mV)")
    axis.set_ylabel("Time fraction (%)")
    axis.set_ylim(-2.0, 102.0)
    axis.grid(True, alpha=0.3)
    axis.legend()
    figure.savefig(
        COMPARISON_DIR / "04_region_fraction_vs_amplitude.svg",
        format="svg",
        metadata={"Date": None},
    )
    plt.close(figure)

    write_comparison_csv(results)
    lines = [
        "# CS Clipping Sweep",
        "",
        "`FIN=1 MHz`, `CL=100 fF`, `VIN_BIAS=0.714 V`에서 입력 peak 진폭을 "
        "10–380 mV로 변경하였다. 클리핑 집중 비교 범위는 180–380 mV이다.",
        "",
        "![Gain compression and THD](./01_gain_compression_and_thd.svg)",
        "",
        "![Clipped output waveforms](./02_clipped_output_waveforms.svg)",
        "",
        "![Output swing envelope](./03_output_swing_envelope.svg)",
        "",
        "![MOS region fractions](./04_region_fraction_vs_amplitude.svg)",
        "",
        "수치 데이터는 [`clipping_sweep_measurements.csv`](./clipping_sweep_measurements.csv)에 있다.",
        "",
    ]
    (COMPARISON_DIR / "README.md").write_text("\n".join(lines), encoding="utf-8")


def write_root_summary(results: dict[str, dict[str, float | str]]) -> None:
    low = results["01_low_frequency"]
    corner = results["02_f3db"]
    attenuation = float(corner["gain_v_per_v"]) / float(low["gain_v_per_v"])
    attenuation_db = float(corner["gain_db"]) - float(low["gain_db"])

    lines = [
        "# CS Transient Verification",
        "",
        "## 1. AC 결과의 시간 영역 검증",
        "",
        "| 조건 | 입력 진폭 | 출력 진폭 | Gain | Gain (dB) | 출력 위상 |",
        "|---|---:|---:|---:|---:|---:|",
    ]
    for variant in ("01_low_frequency", "02_f3db"):
        result = results[variant]
        lines.append(
            f"| {result['condition']} | {float(result['vin_amplitude_mv']):.3f} mV "
            f"| {float(result['vout_amplitude_mv']):.3f} mV "
            f"| {float(result['gain_v_per_v']):.4f} V/V "
            f"| {float(result['gain_db']):.3f} dB "
            f"| {float(result['phase_deg']):.2f}° |"
        )
    lines.extend(
        [
            "",
            f"- corner/저주파 gain 비: `{attenuation:.6f}`",
            f"- gain 감소량: `{attenuation_db:.4f} dB`",
            f"- 이상적인 half-power 비: `{1.0 / math.sqrt(2.0):.6f}`",
            "",
            "## 2. 입력 진폭 및 clipping sweep",
            "",
            "| VIN peak | Gain | Gain 변화 | VOUT THD | VOUT 범위 | R0 | R1 | R2 | R3 | High rail |",
            "|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|",
        ]
    )
    for variant in AMPLITUDE_VARIANTS:
        result = results[variant]
        lines.append(
            f"| {CASES[variant]['input_label']} "
            f"| {float(result['gain_v_per_v']):.4f} V/V "
            f"| {float(result['compression_db']):+.3f} dB "
            f"| {float(result['vout_thd_percent']):.3f}% "
            f"| {float(result['vout_min_v']):.3f}–{float(result['vout_max_v']):.3f} V "
            f"| {float(result['region_0_percent']):.1f}% "
            f"| {float(result['region_1_percent']):.1f}% "
            f"| {float(result['region_2_percent']):.1f}% "
            f"| {float(result['region_3_percent']):.1f}% "
            f"| {float(result['high_rail_dwell_percent']):.1f}% |"
        )
    lines.extend(["", "## 3. 결과 파일", ""])
    for variant in PUBLIC_CASE_VARIANTS:
        config = CASES[variant]
        lines.append(f"- [{config['condition']}](./{variant}/)")
    lines.extend(
        [
            "- [입력 진폭 및 clipping 비교](./05_clipping_comparison/)",
            "",
            "현재 PDK 모델의 region 표기는 0=cutoff/off, 1=triode, "
            "2=saturation, 3=weak-conduction/subthreshold로 해석하였다.",
            "",
        ]
    )
    (RESULT_ROOT / "README.md").write_text("\n".join(lines), encoding="utf-8")


def cleanup_individual_clipping_outputs() -> None:
    """Keep clipping results public only through the consolidated comparison."""
    for variant in CLIPPING_VARIANTS:
        output_dir = RESULT_ROOT / variant
        if output_dir.exists():
            shutil.rmtree(output_dir)



def main() -> None:
    results = {variant: measure_case(variant, config) for variant, config in CASES.items()}
    baseline_gain_db = float(results["01_low_frequency"]["gain_db"])
    for variant, result in results.items():
        result["compression_db"] = (
            float(result["gain_db"]) - baseline_gain_db
            if variant in AMPLITUDE_VARIANTS
            else 0.0
        )
        if variant not in CLIPPING_VARIANTS:
            write_case_measurements(result)

    plot_clipping_comparison(results)
    write_root_summary(results)
    cleanup_individual_clipping_outputs()

    for variant in AMPLITUDE_VARIANTS:
        result = results[variant]
        print(
            f"{CASES[variant]['input_label']}: "
            f"gain={float(result['gain_v_per_v']):.6f} V/V, "
            f"compression={float(result['compression_db']):+.4f} dB, "
            f"THD={float(result['vout_thd_percent']):.4f}%, "
            f"VOUT={float(result['vout_min_v']):.4f}..{float(result['vout_max_v']):.4f} V, "
            f"R0/R1/R2/R3="
            f"{float(result['region_0_percent']):.1f}/"
            f"{float(result['region_1_percent']):.1f}/"
            f"{float(result['region_2_percent']):.1f}/"
            f"{float(result['region_3_percent']):.1f}%, "
            f"high-rail={float(result['high_rail_dwell_percent']):.1f}%"
        )
    corner_ratio = float(results["02_f3db"]["gain_v_per_v"]) / float(
        results["01_low_frequency"]["gain_v_per_v"]
    )
    print(f"corner/low={corner_ratio:.6f}")


if __name__ == "__main__":
    main()
