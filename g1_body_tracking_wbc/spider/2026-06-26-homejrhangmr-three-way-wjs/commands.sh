#!/usr/bin/env bash
set -euo pipefail

# Run from the spider source checkout.
cd /data_team/junsong/model-based/spider

MOTION=/data_zcy/wxy/test_motion/homejrhangmr_dataset_pbhc_contact_maskACCADFemale1Walking_c3dB19-walktopickupbox_posespkl/motion.npz
CHECKPOINT=/data_team/junsong/model-based/wbc_results/assets/checkpoints/model_8000.pt
REWARD_WEIGHTS=/data_team/junsong/model-based/wbc_results/g1_body_tracking_wbc/spider/2026-06-23-mechanism-quality-speed-wjs/configs/g1_wbc_reward_weights_method_specific_v14_20260612.json
OUT_ROOT=/data_team/junsong/model-based/spider/outputs/g1_wbc_single_motion_homejrhangmr_compare_20260626

mkdir -p "${OUT_ROOT}"/logs

# no_mpc_baseline: policy-only full-length rollout, no render.
PYTHONPATH=. .venv/bin/python -m spider.tasks.g1_wbc.evaluate   --motion "${MOTION}"   --motion-type isaaclab   --checkpoint "${CHECKPOINT}"   --method no_mpc   --device cuda:0   --output-dir "${OUT_ROOT}/no_mpc"   --save-rollout   --seed 0 2>&1 | tee "${OUT_ROOT}/logs/no_mpc.log"

# sweetpoint: s512/i2/h40/c20/k8, sigma=0.04/0.10/0.18, no render.
PYTHONPATH=. .venv/bin/python -m spider.tasks.g1_wbc.evaluate   --motion "${MOTION}"   --motion-type isaaclab   --checkpoint "${CHECKPOINT}"   --method g1_wbc_joint_global   --device cuda:1   --output-dir "${OUT_ROOT}/sweetpoint"   --save-rollout   --mpc-preset aggressive   --mpc-reward-weights "${REWARD_WEIGHTS}"   --mpc-samples 512   --mpc-iterations 2   --mpc-planning-horizon-steps 40   --mpc-control-steps 20   --mpc-sampling-mode knot   --mpc-knot-count 8   --mpc-temperature 0.7   --mpc-root-pos-sigma 0.04   --mpc-root-rot-sigma 0.10   --mpc-joint-sigma 0.18   --mpc-smooth-passes 0   --mpc-command-reg-weight 0.0   --mpc-command-smooth-weight 0.0   --mpc-guided-root-pos-gain 0.5   --mpc-guided-root-rot-gain 0.5   --mpc-guided-joint-gain 0.5   --mpc-guided-root-pos-clip 0.05   --mpc-guided-root-rot-clip 0.12   --mpc-guided-joint-clip 0.35   --mpc-guided-candidate   --mpc-acceptance-gate   --seed 0 2>&1 | tee "${OUT_ROOT}/logs/sweetpoint.log"

# n8192: s8192/i2/h80/c20/k8, sigma=0.08/0.18/0.28, no render.
# Final successful run used an empty H100 exposed as CUDA_VISIBLE_DEVICES=2.
CUDA_DEVICE_ORDER=PCI_BUS_ID CUDA_VISIBLE_DEVICES=2 PYTHONPATH=. .venv/bin/python -m spider.tasks.g1_wbc.evaluate   --motion "${MOTION}"   --motion-type isaaclab   --checkpoint "${CHECKPOINT}"   --method g1_wbc_joint_global   --device cuda:0   --output-dir "${OUT_ROOT}/n8192"   --save-rollout   --mpc-preset aggressive   --mpc-reward-weights "${REWARD_WEIGHTS}"   --mpc-samples 8192   --mpc-iterations 2   --mpc-planning-horizon-steps 80   --mpc-control-steps 20   --mpc-sampling-mode knot   --mpc-knot-count 8   --mpc-temperature 0.7   --mpc-root-pos-sigma 0.08   --mpc-root-rot-sigma 0.18   --mpc-joint-sigma 0.28   --mpc-smooth-passes 0   --mpc-command-reg-weight 0.0   --mpc-command-smooth-weight 0.0   --mpc-guided-root-pos-gain 0.5   --mpc-guided-root-rot-gain 0.5   --mpc-guided-joint-gain 0.5   --mpc-guided-root-pos-clip 0.05   --mpc-guided-root-rot-clip 0.12   --mpc-guided-joint-clip 0.35   --mpc-guided-candidate   --mpc-acceptance-gate   --seed 0 2>&1 | tee "${OUT_ROOT}/logs/n8192_gpu2.log"
