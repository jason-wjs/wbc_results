#!/usr/bin/env bash
set -euo pipefail

# Run from the spider source checkout.
# Example:
#   cd /home/wujs/Projects/BrainStorm/Learning/RL/model-based/spider

REWARD_WEIGHTS=../g1_wbc_testbed_motion_package_20260617/metadata/g1_wbc_reward_weights_method_specific_v14_20260612.json
COMMON="--execute --motions jump --iterations 2 --horizons 40 --controls 20 --knot-counts 8 --sigma-triplets 0.04,0.10,0.18 --max-steps 800 --device cuda:0 --mpc-reward-weights ${REWARD_WEIGHTS}"

# cmd-stage-a-budget-curve: sample budget curve across motions.
.venv/bin/python scripts/run_g1_wbc_low_sample_sweep.py --execute \
  --output-root outputs/g1_wbc_mechanism_20260623/stage_a_budget_curve \
  --motions jump walk qixing \
  --samples 64 96 128 192 256 512 1024 2048 \
  --iterations 2 --horizons 40 --controls 20 --knot-counts 8 \
  --sigma-triplets 0.04,0.10,0.18 --seeds 0 --max-steps 800 --device cuda:0 \
  --mpc-reward-weights ${REWARD_WEIGHTS}

# cmd-stage-a-jump-repeats: sample-budget repeatability on jump.
.venv/bin/python scripts/run_g1_wbc_low_sample_sweep.py ${COMMON} \
  --output-root outputs/g1_wbc_mechanism_20260623/stage_a_jump_repeats \
  --samples 128 512 2048 --seeds 1 2

# cmd-stage-b-iterations: iteration main effect on jump at s512.
.venv/bin/python scripts/run_g1_wbc_low_sample_sweep.py ${COMMON} \
  --output-root outputs/g1_wbc_mechanism_20260623/stage_b_structure/iterations \
  --samples 512 --iterations 1 3 --seeds 0

# cmd-stage-b-knot: knot-count main effect on jump at s512.
.venv/bin/python scripts/run_g1_wbc_low_sample_sweep.py ${COMMON} \
  --output-root outputs/g1_wbc_mechanism_20260623/stage_b_structure/knot \
  --samples 512 --knot-counts 4 12 16 --seeds 0

# cmd-stage-b-h20-c10: short horizon/control probe.
.venv/bin/python scripts/run_g1_wbc_low_sample_sweep.py ${COMMON} \
  --output-root outputs/g1_wbc_mechanism_20260623/stage_b_structure/horizon_control/h20_c10 \
  --samples 512 --horizons 20 --controls 10 --seeds 0

# cmd-stage-b-h80-c20: long horizon with same control interval.
.venv/bin/python scripts/run_g1_wbc_low_sample_sweep.py ${COMMON} \
  --output-root outputs/g1_wbc_mechanism_20260623/stage_b_structure/horizon_control/h80_c20 \
  --samples 512 --horizons 80 --controls 20 --seeds 0

# cmd-stage-b-h80-c40: long horizon/control probe.
.venv/bin/python scripts/run_g1_wbc_low_sample_sweep.py ${COMMON} \
  --output-root outputs/g1_wbc_mechanism_20260623/stage_b_structure/horizon_control/h80_c40 \
  --samples 512 --horizons 80 --controls 40 --seeds 0

# cmd-stage-c-command-reg005: command regularization mechanism.
.venv/bin/python scripts/run_g1_wbc_low_sample_sweep.py ${COMMON} \
  --output-root outputs/g1_wbc_mechanism_20260623/stage_c_mechanisms/command_reg005 \
  --samples 128 256 512 --seeds 0 --mpc-command-reg-weight 0.005

# cmd-stage-c-command-smooth0001: command smoothness penalty mechanism.
.venv/bin/python scripts/run_g1_wbc_low_sample_sweep.py ${COMMON} \
  --output-root outputs/g1_wbc_mechanism_20260623/stage_c_mechanisms/command_smooth0001 \
  --samples 128 256 512 --seeds 0 --mpc-command-smooth-weight 0.0001

# cmd-stage-c-warm-best: shifted-plan warm start from best candidate.
.venv/bin/python scripts/run_g1_wbc_low_sample_sweep.py ${COMMON} \
  --output-root outputs/g1_wbc_mechanism_20260623/stage_c_mechanisms/warm_best \
  --samples 128 256 512 --seeds 0 \
  --mpc-warm-start --mpc-warm-start-source best --mpc-warm-start-decay 1.0

# cmd-stage-c-warm-mean-decay08: shifted-plan warm start from mean candidate.
.venv/bin/python scripts/run_g1_wbc_low_sample_sweep.py ${COMMON} \
  --output-root outputs/g1_wbc_mechanism_20260623/stage_c_mechanisms/warm_mean_decay08 \
  --samples 128 256 512 --seeds 0 \
  --mpc-warm-start --mpc-warm-start-source mean --mpc-warm-start-decay 0.8
