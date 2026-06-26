#!/usr/bin/env python3
"""Validate the lightweight WBC experiment registry."""

from __future__ import annotations

import csv
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
PACKAGE_RE = re.compile(r"^\d{4}-\d{2}-\d{2}-[a-z0-9][a-z0-9-]*-[a-z0-9][a-z0-9-]*$")
REQUIRED_FILES = {
    "report.md",
    "manifest.yaml",
    "primary_metrics.csv",
    "run_index.csv",
    "commands.sh",
    "artifacts.md",
}
BANNED_SUFFIXES = {
    ".npz",
    ".npy",
    ".pt",
    ".pth",
    ".ckpt",
    ".onnx",
    ".mp4",
    ".mov",
    ".avi",
    ".mkv",
    ".log",
    ".zip",
}
BANNED_NUMBER_STRINGS = {"nan", "+nan", "-nan", "inf", "+inf", "-inf"}
ALLOWED_BINARY_ASSETS = {
    Path("assets/motion_data/walk/motion.npz"),
    Path("assets/motion_data/jump/motion.npz"),
    Path("assets/motion_data/qixing/motion.npz"),
    Path("assets/checkpoints/model_8000.pt"),
    Path("assets/results/2026-06-26-homejrhangmr-three-way-wjs/sweetpoint_rollout.npz"),
    Path("assets/results/2026-06-26-homejrhangmr-three-way-wjs/n8192_rollout.npz"),
    Path("assets/results/2026-06-26-homejrhangmr-three-way-wjs/sweetpoint_mpc_command.npz"),
    Path("assets/results/2026-06-26-homejrhangmr-three-way-wjs/n8192_mpc_command.npz"),
}


def fail(errors: list[str], message: str) -> None:
    errors.append(message)


def read_csv(path: Path) -> tuple[list[str], list[dict[str, str]]]:
    with path.open(newline="") as handle:
        reader = csv.DictReader(handle)
        return list(reader.fieldnames or []), list(reader)


def validate_package(package: Path, errors: list[str]) -> None:
    rel = package.relative_to(ROOT)
    if not PACKAGE_RE.match(package.name):
        fail(errors, f"{rel}: package name does not match YYYY-MM-DD-topic-runner")

    for required in REQUIRED_FILES:
        if not (package / required).is_file():
            fail(errors, f"{rel}: missing {required}")
    if not (package / "configs").is_dir():
        fail(errors, f"{rel}: missing configs/")

    manifest = package / "manifest.yaml"
    if manifest.exists():
        text = manifest.read_text()
        if f"experiment_id: {package.name}" not in text:
            fail(errors, f"{rel}: manifest experiment_id does not match directory")
        if "task_family: g1_body_tracking_wbc" not in text:
            fail(errors, f"{rel}: manifest task_family is not g1_body_tracking_wbc")
        if "raw_artifacts_in_git: false" not in text:
            fail(errors, f"{rel}: manifest must state raw_artifacts_in_git: false")

    primary_path = package / "primary_metrics.csv"
    run_index_path = package / "run_index.csv"
    if primary_path.exists() and run_index_path.exists():
        primary_header, primary_rows = read_csv(primary_path)
        index_header, index_rows = read_csv(run_index_path)
        for required_col in ["experiment_id", "run_id", "status"]:
            if required_col not in primary_header:
                fail(errors, f"{rel}/primary_metrics.csv: missing {required_col}")
            if required_col not in index_header:
                fail(errors, f"{rel}/run_index.csv: missing {required_col}")

        index_ids = [row.get("run_id", "") for row in index_rows]
        if len(index_ids) != len(set(index_ids)):
            fail(errors, f"{rel}/run_index.csv: run_id is not unique")

        index_id_set = set(index_ids)
        for row in primary_rows:
            run_id = row.get("run_id", "")
            if run_id not in index_id_set:
                fail(errors, f"{rel}/primary_metrics.csv: {run_id} missing from run_index.csv")
            if row.get("status") not in {"complete", "failed", "skipped", "invalid", "planned", "running"}:
                fail(errors, f"{rel}/primary_metrics.csv: invalid status for {run_id}")
            if row.get("success") not in {"true", "false", ""}:
                fail(errors, f"{rel}/primary_metrics.csv: invalid success value for {run_id}")
            for key, value in row.items():
                if value.strip().lower() in BANNED_NUMBER_STRINGS:
                    fail(errors, f"{rel}/primary_metrics.csv: non-finite value {value!r} in {run_id}.{key}")


def main() -> int:
    errors: list[str] = []

    for path in ROOT.rglob("*"):
        rel = path.relative_to(ROOT)
        if path.is_file() and path.suffix.lower() in BANNED_SUFFIXES and rel not in ALLOWED_BINARY_ASSETS:
            fail(errors, f"{path.relative_to(ROOT)}: banned raw artifact suffix")

    for rel in sorted(ALLOWED_BINARY_ASSETS):
        if not (ROOT / rel).is_file():
            fail(errors, f"{rel}: missing versioned testbed motion asset")

    package_roots = [
        ROOT / "g1_body_tracking_wbc" / "spider",
        ROOT / "g1_body_tracking_wbc" / "dial_mpc",
    ]
    packages: list[Path] = []
    for root in package_roots:
        if root.is_dir():
            packages.extend(path for path in root.iterdir() if path.is_dir() and PACKAGE_RE.match(path.name))

    if not packages:
        fail(errors, "no experiment packages found")
    for package in sorted(packages):
        validate_package(package, errors)

    if errors:
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        return 1

    print(f"validated {len(packages)} experiment packages")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
