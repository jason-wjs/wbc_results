# G1 WBC Mechanism Quality-Speed Experiment Design

## Goal

Identify which controllable MPC factors dominate G1 WBC optimization quality and
inference speed on the current three-motion testbed: `jump`, `walk`, and
`qixing`.

The experiment is diagnostic first. It should answer whether the current gap
between `best_s128` and the packaged SPIDER `g1_wbc_joint_global` baseline is
mainly caused by sample budget, MPC structure, or algorithmic update mechanics.

## Fixed Anchors

`best_s128` is the quality floor:

```text
method: g1_wbc_joint_global
samples: 128
iterations: 2
planning_horizon_steps: 40
control_steps: 20
knot_count: 8
sigma_triplets: 0.04,0.10,0.18
temperature: 0.7
guided_candidate: true
acceptance_gate: true
reward_weights: g1_wbc_reward_weights_method_specific_v14_20260612.json
seed: 0
max_steps: 800
```

The packaged `baseline_8192_joint_global` is the quality target. High-sample
runs such as `s1024` and `s2048` are allowed as diagnostic probes, but they are
not the deployment target.

For `jump`, use the historical `best_s128` metrics as the numeric floor. The
rendered rerun is only the visual artifact reference because the historical run
did not save `rollout.npz`.

## Metrics-First Evaluation

Do not reduce the result to scalar score alone. Each run is evaluated across:

- Global: `root_pos_error_mean`, `body_global_pos_error_mean`,
  `ee_global_pos_error_mean`
- Local/posture: `body_local_pos_error_mean`, `ee_local_pos_error_mean`
- Contact: `contact_mismatch_rate`
- Smooth/control: `control_delta_mean`, `joint_acc_mean`
- Aggregate/runtime: `score`, `success`, `num_steps`, `duration_sec`

The stage is metrics-first. Videos are not required for this diagnostic pass.

## Experiment Stages

### Stage A: Sample-Budget Upper Curve

Run the unmodified v14 reward anchor with the `best_s128` structure
(`i2/h40/c20/k8`, sigma `0.04,0.10,0.18`) across:

```text
samples: 64,96,128,192,256,512,1024,2048
motions: jump,walk,qixing
seed: 0
```

This establishes the first quality-speed curve on all three motions.

After the seed-0 curve, add repeatability probes for `jump` on the budgets that
look most informative. Prefer `s128`, the smallest budget that beats
`best_s128` if one exists, and the smallest budget that approaches the packaged
baseline.

### Stage B: MPC Structure Main Effects

Use `jump` as the main diagnostic motion. Hold reward weights and sigma fixed,
then vary one structure factor at a time around the current anchor:

```text
samples: 512
seed: 0
iterations: 1,2,3
horizon/control: (20,10), (40,20), (80,20), (80,40)
knot_count: 4,8,12,16
```

This stage identifies whether quality comes primarily from refinement count,
planning horizon, command frequency, or knot expressivity.

### Stage C: Algorithmic Mechanism Checks

Run low-risk mechanism checks that can plausibly improve same-budget quality:

```text
budgets: 128,256,512
motion: jump
seed: 0
mechanisms:
  - warm_start=best, decay=1.0
  - warm_start=mean, decay=0.8
  - command_reg_weight=0.005
  - command_smooth_weight=0.0001
```

This stage checks whether quality can be improved without simply increasing
sample count. Any promising mechanism should later be transferred to
`walk/qixing` before visual review.

## Decision Rules

- If `s1024` or `s2048` approaches the packaged baseline, then sample budget is
  sufficient in principle and the next algorithmic goal is to compress that
  quality down to lower budgets.
- If high-sample runs improve global metrics but not local/contact/smooth
  metrics, then sample count mostly repairs root/global tracking and a separate
  objective or update mechanism is needed for the remaining categories.
- If high-sample runs do not approach the packaged baseline, then the bottleneck
  is unlikely to be sample count alone.
- If higher budgets are better on `jump` but regress `walk` or `qixing`, treat
  the factor as motion-specific rather than a general replacement.

## Output Package

All outputs for this stage live under:

```text
spider/outputs/g1_wbc_mechanism_20260623/
```

The final report should include:

- raw sweep `summary.csv` files,
- a compact metrics table grouped by experiment stage,
- best-vs-baseline deltas,
- runtime scaling,
- a concise conclusion for each factor class.
