# Contributing Experiment Results

## Naming

Experiment package directories use:

```text
YYYY-MM-DD-topic-runner
```

Examples:

```text
2026-06-17-testbed-motion-baselines-xwj
2026-06-23-mechanism-quality-speed-wjs
```

Rules:

- Use the experiment completion date, not the migration date.
- Use kebab-case for `topic`.
- Use the main experiment runner as the final suffix.
- Do not rename an experiment package after it is reviewed.
- If a later experiment supersedes an earlier one, mark the earlier package as
  `superseded` in `manifest.yaml` and reference `superseded_by`.

## Required Files

Every package must include:

- `report.md`: reader-facing conclusions, evidence, limitations, and next steps.
- `manifest.yaml`: metadata, source repo/version, status, confidence, and file map.
- `primary_metrics.csv`: compact metrics table for reviewed runs.
- `run_index.csv`: one row per source run or artifact-producing run.
- `commands.sh`: commands needed to reproduce or regenerate reviewed runs.
- `artifacts.md`: external artifact index and local source references.

Optional:

- `configs/`: small config files needed to understand or reproduce runs.
- `checksums.txt`: checksums for external artifacts when available.

## Size And Artifact Rules

Preferred package size is under 1 MB. Hard limit is 5 MB unless explicitly
approved in review.

Do not commit:

- `*.npz`, `*.npy`
- `*.mp4`, `*.mov`, `*.avi`
- `*.pt`, `*.pth`, `*.ckpt`
- full `stdout.txt` / `stderr.txt`
- local `outputs/` trees
- checkpoints, motion datasets, or raw rollouts

Use `artifacts.md` to point to external artifact URIs or local source paths.

## Evidence Rules

Experiment conclusions must include:

- Claim
- Evidence
- Confidence level: `low`, `medium`, `high`, or `baseline`
- Limitations
- Next validation

Video artifacts are qualitative sanity checks. They do not replace metrics.

