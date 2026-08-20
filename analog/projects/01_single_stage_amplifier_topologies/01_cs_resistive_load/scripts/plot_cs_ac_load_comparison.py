#!/usr/bin/env python3
"""Overlay the CS AC gain and phase results for all load capacitances."""

from __future__ import annotations

import csv
import math
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
matplotlib.rcParams["svg.hashsalt"] = "circuit-design-fundamentals"
import matplotlib.pyplot as plt  # noqa: E402
import numpy as np  # noqa: E402


PROJECT = Path(__file__).resolve().parents[1]
RESULT_ROOT = PROJECT / "figures" / "generated" / "tb_p01_cs_ac"
OUTPUT_DIR = RESULT_ROOT / "04_cl_comparison"

CASES = (
    ("01_cl_10f", "10 fF", "#0072B2"),
    ("02_cl_100f", "100 fF", "#E69F00"),
    ("03_cl_1p", "1 pF", "#009E73"),
)


def read_csv(path: Path, value_column: str) -> tuple[np.ndarray, np.ndarray]:
    x_values: list[float] = []
    y_values: list[float] = []
    with path.open(encoding="utf-8", newline="") as handle:
        for row in csv.DictReader(handle):
            x_values.append(float(row["x"]))
            y_values.append(float(row[value_column]))
    return np.asarray(x_values), np.asarray(y_values)


def interpolate_crossing(
    frequency: np.ndarray, values: np.ndarray, target: float
) -> float:
    indices = np.flatnonzero(values <= target)
    if not len(indices):
        return math.nan
    upper = int(indices[0])
    if upper == 0:
        return float(frequency[0])
    lower = upper - 1
    y0, y1 = values[lower], values[upper]
    log_x0, log_x1 = np.log10(frequency[[lower, upper]])
    fraction = (target - y0) / (y1 - y0)
    return float(10 ** (log_x0 + fraction * (log_x1 - log_x0)))


def format_frequency(value: float) -> str:
    for scale, suffix in ((1e9, "GHz"), (1e6, "MHz"), (1e3, "kHz")):
        if value >= scale:
            return f"{value / scale:.4g} {suffix}"
    return f"{value:.4g} Hz"


def main() -> None:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    fig, (gain_ax, phase_ax) = plt.subplots(
        2,
        1,
        figsize=(10.5, 8.2),
        sharex=True,
        gridspec_kw={"height_ratios": [1.15, 1]},
    )

    summaries: list[tuple[str, float, float]] = []
    for directory, label, color in CASES:
        case_dir = RESULT_ROOT / directory
        frequency, gain_db = read_csv(case_dir / "03_cs_gain.csv", "Gain")
        phase_frequency, phase_deg = read_csv(case_dir / "04_cs_phase.csv", "Phase")
        if not np.array_equal(frequency, phase_frequency):
            raise RuntimeError(f"gain/phase frequency grids differ for {directory}")

        low_frequency_gain = float(gain_db[0])
        three_db_target = low_frequency_gain - 10.0 * math.log10(2.0)
        three_db_frequency = interpolate_crossing(frequency, gain_db, three_db_target)
        summaries.append((label, low_frequency_gain, three_db_frequency))

        legend = f"CL = {label}  (f3dB = {format_frequency(three_db_frequency)})"
        gain_ax.semilogx(frequency, gain_db, color=color, linewidth=2.1, label=legend)
        phase_ax.semilogx(frequency, phase_deg, color=color, linewidth=2.1, label=f"CL = {label}")
        gain_ax.plot(
            three_db_frequency,
            three_db_target,
            marker="o",
            markersize=6,
            color=color,
            markeredgecolor="white",
            markeredgewidth=0.8,
            zorder=3,
        )

    nominal_gain = summaries[0][1]
    gain_ax.axhline(
        nominal_gain - 10.0 * math.log10(2.0),
        color="#666666",
        linewidth=1.0,
        linestyle="--",
        label=f"Half-power level ({nominal_gain - 10.0 * math.log10(2.0):.2f} dB)",
    )

    gain_ax.set_title("Common-Source AC Response vs. Load Capacitance", fontsize=14, pad=10)
    gain_ax.set_ylabel("Voltage gain |VOUT/VIN| (dB)")
    gain_ax.grid(True, which="major", alpha=0.35)
    gain_ax.grid(True, which="minor", alpha=0.15)
    gain_ax.legend(loc="lower left", fontsize=9)

    phase_ax.set_xlabel("Frequency (Hz)")
    phase_ax.set_ylabel("Phase (deg)")
    phase_ax.grid(True, which="major", alpha=0.35)
    phase_ax.grid(True, which="minor", alpha=0.15)
    phase_ax.legend(loc="lower left", fontsize=9)

    fig.text(
        0.5,
        0.012,
        "RD = 5.6 kOhm, VIN_BIAS = 0.714 V, VDD = 1.1 V, input AC magnitude = 1",
        ha="center",
        fontsize=9,
        color="#444444",
    )
    fig.tight_layout(rect=(0, 0.035, 1, 1))

    output_path = OUTPUT_DIR / "01_cs_ac_load_comparison.svg"
    fig.savefig(output_path, format="svg", bbox_inches="tight")
    plt.close(fig)

    readme_lines = [
        "# CS AC Load-Capacitance Overlay",
        "",
        "동일한 DC 동작점에서 `CL`만 변경한 gain/phase 중첩 그래프이다.",
        "",
        "![CS AC load comparison](./01_cs_ac_load_comparison.svg)",
        "",
        "| CL | Low-frequency gain | -3 dB bandwidth |",
        "|---:|---:|---:|",
    ]
    for label, gain_db, bandwidth in summaries:
        readme_lines.append(f"| {label} | {gain_db:.3f} dB | {format_frequency(bandwidth)} |")
    readme_lines.extend(
        [
            "",
            "`CL`이 커질수록 저주파 이득은 거의 유지되지만 output pole이 낮아져 bandwidth가 감소한다.",
            "원 표식은 각 곡선의 저주파 이득 대비 `-3 dB` 지점이다.",
            "",
            "## 재생성",
            "",
            "```bash",
            "python3 scripts/plot_cs_ac_load_comparison.py",
            "```",
            "",
        ]
    )
    (OUTPUT_DIR / "README.md").write_text("\n".join(readme_lines), encoding="utf-8")

    print(f"generated: {output_path}")
    for label, gain_db, bandwidth in summaries:
        print(f"  CL={label:>6}: gain={gain_db:.6f} dB, f3dB={format_frequency(bandwidth)}")


if __name__ == "__main__":
    main()
