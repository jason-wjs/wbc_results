# run_index.csv Columns

`run_index.csv` maps each reviewed run to its provenance and raw artifacts.

Current package columns:

- `experiment_id`
- `run_id`
- `source_project`
- `motion`
- `method`
- `config_label`
- `seed`
- `status`
- `metrics_source`
- `rollout_source`
- `command_source`
- `video_source`
- `log_source`
- `artifact_ref`
- `notes`

Rules:

- `run_id` must be unique inside each package.
- Every `primary_metrics.csv` run_id must exist in `run_index.csv`.
- Raw artifact paths are references only; do not copy `.npz`, `.npy`, `.mp4`,
  `.log`, or checkpoint files into this repository.
- Use `artifact_ref` to point to the related section or row in `artifacts.md`.
