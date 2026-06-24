# G1 WBC Mechanism Quality-Speed Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Run and analyze the next-stage G1 WBC mechanism experiments that identify core quality and inference-speed factors.

**Architecture:** Use the existing `scripts/run_g1_wbc_low_sample_sweep.py` runner as the execution backend. Keep CUDA experiment execution serial on the main GPU, and use subagents only for non-GPU exploration/review so they do not compete for device memory.

**Tech Stack:** Python stdlib, existing SPIDER G1 WBC runner, CUDA via project `.venv`, CSV/JSON metrics artifacts.

---

## File Structure

- Read: `scripts/run_g1_wbc_low_sample_sweep.py`
  - General parameterized sweep runner for samples, iterations, horizons,
    controls, knot counts, sigma triplets, seeds, and motions.
- Read: `spider/tasks/g1_wbc/local_first_stage.py`
  - Existing baselines and metric helper conventions.
- Create outputs under: `outputs/g1_wbc_mechanism_20260623/`
  - `stage_a_budget_curve/summary.csv`
  - `stage_a_jump_repeats/summary.csv`
  - `stage_b_structure/summary.csv`
  - `stage_c_mechanisms/summary.csv`
  - `mechanism_report.md`

## Task 1: Establish Execution Context

- [ ] **Step 1: Confirm runner capability**

Use a subagent to verify that `run_g1_wbc_low_sample_sweep.py` supports the
needed command flags and output layout.

Expected: runner supports `--samples`, `--iterations`, `--horizons`,
`--controls`, `--knot-counts`, `--sigma-triplets`, `--seeds`, and `--motions`.

- [ ] **Step 2: Confirm reference metrics**

Use a subagent to extract `best_s128` and packaged baseline metrics for
`jump`, `walk`, and `qixing`.

Expected: reference metrics cover score, global, local, contact, smooth, and
runtime fields.

- [ ] **Step 3: Confirm CUDA outside sandbox**

Run:

```bash
.venv/bin/python -c "import torch; print(torch.__version__); print(torch.cuda.is_available()); print(torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'no cuda')"
```

Expected: CUDA is available and device is the RTX 4070 Laptop GPU.

## Task 2: Run Stage A Sample-Budget Curve

- [ ] **Step 1: Dry-run Stage A**

Run:

```bash
.venv/bin/python scripts/run_g1_wbc_low_sample_sweep.py \
  --dry-run \
  --output-root outputs/g1_wbc_mechanism_20260623/stage_a_budget_curve \
  --motions jump walk qixing \
  --samples 64 96 128 192 256 512 1024 2048 \
  --iterations 2 \
  --horizons 40 \
  --controls 20 \
  --knot-counts 8 \
  --sigma-triplets 0.04,0.10,0.18 \
  --seeds 0 \
  --max-steps 800 \
  --device cuda:0 \
  --mpc-reward-weights ../g1_wbc_testbed_motion_package_20260617/metadata/g1_wbc_reward_weights_method_specific_v14_20260612.json
```

Expected: 24 evaluate jobs.

- [ ] **Step 2: Execute Stage A**

Run the same command with `--execute`.

Expected: `outputs/g1_wbc_mechanism_20260623/stage_a_budget_curve/summary.csv`
contains 24 rows with `status=ok`.

## Task 3: Run Jump Repeatability Probe

- [ ] **Step 1: Select repeat budgets**

Read Stage A summary and select:

- `128`
- the smallest budget that beats the `jump` historical `best_s128` score
- the smallest budget whose global metrics approach the packaged baseline

If no budget beats the floor, use `128`, `512`, and `2048`.

- [ ] **Step 2: Execute jump repeats**

Run:

```bash
.venv/bin/python scripts/run_g1_wbc_low_sample_sweep.py \
  --execute \
  --output-root outputs/g1_wbc_mechanism_20260623/stage_a_jump_repeats \
  --motions jump \
  --samples <selected budgets> \
  --iterations 2 \
  --horizons 40 \
  --controls 20 \
  --knot-counts 8 \
  --sigma-triplets 0.04,0.10,0.18 \
  --seeds 1 2 \
  --max-steps 800 \
  --device cuda:0 \
  --mpc-reward-weights ../g1_wbc_testbed_motion_package_20260617/metadata/g1_wbc_reward_weights_method_specific_v14_20260612.json
```

Expected: repeat rows reveal whether the sample-budget conclusion is stable.

## Task 4: Run Stage B Structure Main Effects

- [ ] **Step 1: Execute structure matrix on jump**

Run a compact set of sweeps under `outputs/g1_wbc_mechanism_20260623/stage_b_structure`.
Use `samples=512`, `seed=0`, reward weights v14, and sigma `0.04,0.10,0.18`.

Required factor sets:

- iterations: `1 2 3` with `h40/c20/k8`
- horizon/control: `(20,10)`, `(40,20)`, `(80,20)`, `(80,40)` with `i2/k8`
- knot count: `4 8 12 16` with `i2/h40/c20`

Expected: summary rows make the main effect of each structure factor visible.

## Task 5: Run Stage C Algorithmic Mechanism Checks

- [ ] **Step 1: Execute warm-start checks**

Run `jump`, `seed=0`, samples `128 256 512`, anchor structure
`i2/h40/c20/k8`, sigma `0.04,0.10,0.18`, with:

- `--mpc-warm-start --mpc-warm-start-source best --mpc-warm-start-decay 1.0`
- `--mpc-warm-start --mpc-warm-start-source mean --mpc-warm-start-decay 0.8`

- [ ] **Step 2: Execute command regularization checks**

Run the same budget set with:

- `--mpc-command-reg-weight 0.005`
- `--mpc-command-smooth-weight 0.0001`

Expected: mechanism rows reveal whether same-budget quality can improve without
sample escalation.

## Task 6: Analyze And Report

- [ ] **Step 1: Build compact comparison tables**

Compare every run against:

- motion-specific `best_s128`
- motion-specific packaged `baseline_8192_joint_global`

Use metrics groups:

- global
- local
- contact
- smooth
- runtime

- [ ] **Step 2: Write report**

Create:

```text
outputs/g1_wbc_mechanism_20260623/mechanism_report.md
```

The report must state:

- whether sample count alone can approach baseline,
- which metric groups are most sample-sensitive,
- which structure factors dominate quality or runtime,
- whether warm start or regularization gives same-budget gains,
- recommended next algorithmic direction.
