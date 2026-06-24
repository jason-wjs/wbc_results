# WBC Results

This repository is a lightweight experiment registry for WBC-related result
packages. It stores conclusions, metrics summaries, reproducibility metadata,
commands, checksums, and artifact links. It does not store raw rollouts, videos,
checkpoints, logs, or local `outputs/` trees.

Current experiment families:

- `g1_body_tracking_wbc/`: Unitree G1 body-only motion tracking with WBC-style
  rollout optimization. This excludes dexhand/manipulation experiments.

Raw artifacts must live in external storage such as BOS/S3/NAS/Drive, or remain
referenced by local paths while migration is in progress.

## Repository Layout

```text
wbc_results/
  schemas/
  templates/
  g1_body_tracking_wbc/
    CURRENT_STATUS.md
    MILESTONES.md
    spider/
      YYYY-MM-DD-topic-runner/
    dial_mpc/
      YYYY-MM-DD-topic-runner/
```

Each experiment package must be small enough to review in git. Use the template
under `templates/experiment/`.

## Package Contents

Each package is expected to contain:

- `report.md`: reader-facing conclusions and limitations.
- `manifest.yaml`: source repo, owner, status, confidence, and file map.
- `primary_metrics.csv`: compact comparison metrics.
- `run_index.csv`: run provenance and artifact references.
- `commands.sh`: audited reproduction commands.
- `artifacts.md`: raw artifact index; raw artifacts themselves stay outside git.
- `configs/`: small config and summary files only.

Read packages in this order: `report.md`, `primary_metrics.csv`,
`manifest.yaml`, `commands.sh`, then `artifacts.md`.
