# Cross-Embodiment / Cross-Behavior Research — Conversation Record

> Date: 2026-11-06. Source: discussion available in this ChatGPT conversation. This file is a **faithful structured research log**, not a verbatim export of every chat message. Future turns require an explicit GitHub write during an active conversation; no unattended background synchronization is implied.

## Repository decision (latest and authoritative)

- **Only project repository and chat archive destination:** https://github.com/LemonQC/crossemboided
- Earlier proposed `https://github.com/LemonQC/huitu` was a mistake and has been superseded. Do not continue writing this project archive there. Existing files, if any, are **not asserted to have been migrated or deleted**.
- Record each subsequent discussion's decisions, code changes, commands, results, errors and pending work in dated Markdown in this repository.
- Prefer one shared `cbl4090` Conda environment and a unified ManiSkill simulator, observation/action schema, and closed-loop evaluation. Use separate environments only for unavoidable preprocessing dependencies.
- Publication baselines may be faithful reimplementations where upstream code cannot be integrated, but classify each as Official / Reimplementation / Adapted / Proxy; never present a proxy as an official result.

## Research objective

Target is a defensible IEEE T-RO contribution on **learning task-equivalent behaviors across embodiments**, potentially disentangling necessary task constraints and incidental demonstrator motion. Novelty and necessity are **not established**. The proper go/no-go test is whether relevant published baselines fail on controlled, same-goal/different-behavior transfer tasks under fair identical evaluation. Simple PickCube performance does not establish cross-behavior transfer.

Tentative ideas:
1. Process-Constrained Task Equivalence Learning: learn essential intermediate constraints of successful behavior.
2. Equivalence-Conditioned Policy Learning: generate embodiment-dependent actions preserving those constraints.
These are hypotheses, not experimentally verified contributions.

## Existing server setup and baseline evidence

- User server project: `/mnt/4Tdata/LemonData/cross_behavior_4090_v1`; an adapter project at `/mnt/4Tdata/LemonData/CrossBehavior_4090_CrossPaper_Adapters_v4`.
- Conda environment `cbl4090`, single NVIDIA RTX 4090 (24 GB).
- ManiSkill PickCube-v1, state observations and `pd_ee_delta_pos` control; initial demonstration count 100.
- Headless PhysX: unset `DISPLAY` and `WAYLAND_DISPLAY` to avoid X/GLX crashes.
- Gymnasium 1.4.0 official evaluation required autoreset and numpy-to-torch metric compatibility fixes.
- Official ManiSkill Diffusion Policy: configured 30,000 training iterations; last evaluation 20 episodes: Success Once **100%**, Success At End **70%**. These are small-sample, single-seed results, not final paper statistics.
- Official ManiSkill ACT: latest recorded Success Once **30%**, Success At End **0%**; requires better convergence and checkpoint comparison.
- Three pilot lightweight models: BC-GMM, BC-RNN, BC-Transformer; 2-epoch/2-rollout smoke test produced 0% in each. This shows the evaluation runs, **not** that the algorithms fail.
- RoboMimic six official configurations (BC, BC-GMM, BC-RNN, BC-RNN-GMM, BC-Transformer, BC-Transformer-GMM) received adapter scripts; actual end-to-end success not yet established from pasted logs.
- Earlier simplified methods should only be identified as controlled reimplementations, not official RoboMimic results.

## Cross-paper integration status, based on user's server audit

- **Im2Flow2Act**: upstream code downloaded at git `f44b368b76195c30bf38074f6419fc8b9f8feb5f`; audit initially gave false ENTRY_NOT_VERIFIED due to typo `scripts/control` vs actual **`scripts/controll`**. User confirmed files:
  - `scripts/controll/evaluate_from_flow_generation.py`
  - `scripts/controll/evaluate_flow_diffusion_policy.py`
  - `scripts/controll/train_flow_conditioned_diffusion_policy.py`
- **XSkill**: official code fetched, revision `b748071daeb031d6b42a8dcb88c38c52297e20af`; evaluation entry `scripts/skill_transfer_composing.py` exists; depends on original cross-embodiment kitchen data.
- **UniSkill**: partial upstream code at revision `eca49f032fb22200cb45d5e4055a87d306c3ba21`; `diffusion/train_uniskill.py` exists but some policy/checkpoint pieces remain unverified; not a complete end-to-end baseline.
- **CORE**: official usable repository not verified; proposed project address returned 404 when earlier checked.
- **Cross-Behavior Learning With Object Flow Prediction**: official usable repository not verified. Do not label unvalidated local substitute as official.

## Im2Flow2Act data/config checks

The user printed `config/diffusion_policy/evaluate_from_flow_generation.yaml` and `train_flow_conditioned_diffusion_policy.yaml`.
- `DEV_PATH` is an environment variable that all paths derive from.
- Pretrained policy `checkpoints/manipulation_policy`, configured `ckpt: 300`.
- Evaluation directories: `simulation_evaluation/drawer_open`, `pickNplace`, and `pouring`; camera intrinsics/pose matrices in `data_local/simulation`.
- Training data directories: `simulated_play/rigid`, `articulated`, `deformable`; configuration 1001 epochs, batch size 52, 128 tracked points, 7D actions.
- Policy-only evaluation uses `config/diffusion_policy/evaluate_flow_diffusion_policy.yaml`; full flow generation uses `evaluate_from_flow_generation.yaml`. Training is not the immediate priority.
- User's server HEAD requests returned HTTP 200 and file sizes:
  - `https://real.stanford.edu/im2flow2act/checkpoints.zip`: **6,303,833,294 bytes**.
  - `https://real.stanford.edu/im2flow2act/data/simulation_evaluation.zip`: **1,932,834,883 bytes**.
  - Total **8,236,668,177 bytes**, only the two known assets (additional generator weights may be required).
- Downloads and real Policy-only evaluation are **not confirmed completed**.
- Native tasks and PickCube are different, so native success numbers cannot be directly compared to PickCube.

## Engineering protocol and go/no-go criterion

1. Use existing official DP and ACT, and reproducible RoboMimic suite, as **single-behavior sanity checks**, not as proof of cross-embodiment novelty.
2. Construct a small, clearly defined same-goal / different-behavior demonstration protocol in ManiSkill. Match robot control, camera modalities, reward/success predicates, training budget, seeds, and evaluation episodes.
3. Faithfully implement/adapt key relevant algorithms (Im2Flow2Act, Object Flow, XSkill and CORE only if enough method details are available) in the unified simulator and state precisely what changed.
4. Test task success, cross-behavior transfer, unseen behavior variants, data efficiency and failure modes; report per-seed averages and uncertainty.
5. **Do not claim T-RO-level novelty before experiments show a meaningful limitation of existing methods**.
6. Record scripts, commands, versions, logs, data provenance, resource consumption and run IDs in subsequent logs.

## Conversation milestones (research log rather than verbatim transcript)

- User tested short BC-GMM/BC-RNN/BC-Transformer smoke runs; all showed 0% on two rollouts. Assistant confirmed pipeline works but this is non-diagnostic.
- User objected that too few algorithms and most are self-made: agreement to prioritize real published baselines and faithful reproduction.
- A RoboMimic adapter package was provided, but its server execution still needs verification.
- User requested Im2Flow2Act / Cross-Behavior Object Flow / XSkill / UniSkill / CORE integration; v4 sourced available upstream repos and generated an audit.
- User executed v4 audit, confirming XSkill and UniSkill entrypoints and discovering Im2Flow2Act path mismatch; then found the real `scripts/controll` entries.
- User inspected original Hydra YAML and successful HTTP HEAD requests for Im2Flow2Act weights and evaluation data.
- User requested unified Conda environment and same ManiSkill simulation; reimplementation acceptable with provenance.
- User first named `LemonQC/huitu` as archive destination, then **explicitly corrected** that ALL current and subsequent chat records must go to `LemonQC/crossemboided`. This is the superseding instruction.

## Current next actions

- Keep `crossemboided` the sole target for future research logs and code commits.
- Avoid overwriting unrelated upstream files; pin repository revisions and label reproductions.
- Build and execute the same-environment, same-simulator comparison and verify actual trajectories/closed-loop success.
- Preserve logs each turn when GitHub connection is available; do not pretend that an automated background service has been created.
