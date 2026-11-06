# 2026-11-06 — Official RoboMimic v11 offline action audit and pilot results

This file records the user's current message verbatim and a concise record of the assistant's response. It is not a complete verbatim export of all turns. No algorithm source code has been uploaded.

## User — verbatim

```text
using obs modality: low_dim with keys: ['state']
using obs modality: rgb with keys: []
using obs modality: depth with keys: []
using obs modality: scan with keys: []
Created GPT_Backbone model with number of parameters: 3156480
WROTE: /mnt/4Tdata/LemonData/cross_behavior_4090_v1/results/pilot_v11/action_audit_v11.md
# RoboMimic action agreement audit (offline, NO environment rollouts)

Uses the saved 20-epoch checkpoint and existing train/validation demonstration states.
A GMM policy may produce stochastic samples; numerical comparison is diagnostic only.

| Method | Train MSE | Valid MSE | Train gripper sign | Valid gripper sign | Status |
|---|---:|---:|---:|---:|---|
| bc | 0.000590 | 0.000900 | 100.0% | 100.0% | ok |
| bc_gmm | 0.043547 | 0.056122 | 95.7% | 94.4% | ok |
| bc_rnn | 0.000326 | 0.000214 | 100.0% | 100.0% | ok |
| bc_rnn_gmm | 0.248902 | 0.242990 | 75.2% | 75.9% | ok |
| bc_transformer | 0.000249 | 0.000400 | 100.0% | 100.0% | ok |

**Interpretation:** Very low offline error with poor online success suggests a rollout/domain shift or implementation mismatch, but it does not prove one. Check model actions and first-step observations against the original demonstrations.
Huge GMM validation negative-log-likelihood cannot be compared directly with MSE.
No new dataset, training, or real-environment episodes were created by this diagnostic.

# RoboMimic action agreement audit (offline, NO environment rollouts)

Uses the saved 20-epoch checkpoint and existing train/validation demonstration states.
A GMM policy may produce stochastic samples; numerical comparison is diagnostic only.

| Method | Train MSE | Valid MSE | Train gripper sign | Valid gripper sign | Status |
|---|---:|---:|---:|---:|---|
| bc | 0.000590 | 0.000900 | 100.0% | 100.0% | ok |
| bc_gmm | 0.043547 | 0.056122 | 95.7% | 94.4% | ok |
| bc_rnn | 0.000326 | 0.000214 | 100.0% | 100.0% | ok |
| bc_rnn_gmm | 0.248902 | 0.242990 | 75.2% | 75.9% | ok |
| bc_transformer | 0.000249 | 0.000400 | 100.0% | 100.0% | ok |

**Interpretation:** Very low offline error with poor online success suggests a rollout/domain shift or implementation mismatch, but it does not prove one. Check model actions and first-step observations against the original demonstrations.
Huge GMM validation negative-log-likelihood cannot be compared directly with MSE.
No new dataset, training, or real-environment episodes were created by this diagnostic.
(cbl4090_clean) ubuntu@ubuntu-System-Product-Name:/mnt/4Tdata/LemonData/cross_behavior_4090_v1$ 
aved: /mnt/4Tdata/LemonData/cross_behavior_4090_v1/results/pilot_v11/PickCube-v1_bc_transformer_gmm_100demo_20epoch_20eval_trainseed42_evalseed6000.json | once=0.0%, end=0.0%
WROTE: /mnt/4Tdata/LemonData/cross_behavior_4090_v1/results/pilot_v11/summary_v11.md
# v11 official RoboMimic evaluation (existing checkpoints preferred)

The original v7-v10 results are preserved. Missing methods are not assigned a score.

| Method | Status | Epoch | Episodes | Once | At end |
|---|---|---:|---:|---:|---:|
| bc_transformer | evaluated | 20 | 20 | 0.0% | 0.0% |
| bc_transformer_gmm | evaluated | 20 | 20 | 0.0% | 0.0% |

# v11 official RoboMimic evaluation (existing checkpoints preferred)

The original v7-v10 results are preserved. Missing methods are not assigned a score.

| Method | Status | Epoch | Episodes | Once | At end |
|---|---|---:|---:|---:|---:|
| bc_transformer | evaluated | 20 | 20 | 0.0% | 0.0% |
| bc_transformer_gmm | evaluated | 20 | 20 | 0.0% | 0.0% |
(cbl4090_clean) ubuntu@ubuntu-System-Product-Name:/mnt/4Tdata/LemonData/cross_behavior_4090_v1$ 
Saved: /mnt/4Tdata/LemonData/cross_behavior_4090_v1/results/pilot_v11/PickCube-v1_bc_rnn_gmm_100demo_20epoch_20eval_trainseed42_evalseed6000.json | once=0.0%, end=0.0%
WROTE: /mnt/4Tdata/LemonData/cross_behavior_4090_v1/results/pilot_v11/summary_v11.md
# v11 official RoboMimic evaluation (existing checkpoints preferred)

The original v7-v10 results are preserved. Missing methods are not assigned a score.

| Method | Status | Epoch | Episodes | Once | At end |
|---|---|---:|---:|---:|---:|
| bc | evaluated | 20 | 20 | 0.0% | 0.0% |
| bc_gmm | evaluated | 20 | 20 | 0.0% | 0.0% |
| bc_rnn | evaluated | 20 | 20 | 0.0% | 0.0% |
| bc_rnn_gmm | evaluated | 20 | 20 | 0.0% | 0.0% |

# v11 official RoboMimic evaluation (existing checkpoints preferred)

The original v7-v10 results are preserved. Missing methods are not assigned a score.

| Method | Status | Epoch | Episodes | Once | At end |
|---|---|---:|---:|---:|---:|
| bc | evaluated | 20 | 20 | 0.0% | 0.0% |
| bc_gmm | evaluated | 20 | 20 | 0.0% | 0.0% |
| bc_rnn | evaluated | 20 | 20 | 0.0% | 0.0% |
| bc_rnn_gmm | evaluated | 20 | 20 | 0.0% | 0.0% |
(cbl4090_clean) ubuntu@ubuntu-System-Product-Name:/mnt/4Tdata/LemonData/cross_behavior_4090_v1$ 
```

## Assistant — decision / proposed next step (summary, not verbatim)

All six RoboMimic BC-family variants have real 20-epoch closed-loop results, all 0/20 Success Once under v11. Offline audit on 3 training and 3 validation trajectories per policy shows BC valid MSE 0.000900, BC-RNN 0.000214 and BC-Transformer 0.000400 with 100% gripper sign agreement; GMM variants have much worse action agreement and earlier extreme validation negative log-likelihood. Low aggregate MSE is not proof of accurate translational commands, especially when gripper and translational action scales differ.

**Decision**: Do not add epochs or train models yet. First replay expert actions in ManiSkill from the recorded reset kwargs or first saved env state. Compare initial state, first-step drift and expert success against learned BC on the exact same initial state. A local code artifact `RoboMimic_Oracle_Replay_v12.zip` (with `diagnose_oracle_v12.py`) was created for the user in this conversation. Code is delivered as a chat attachment, **not** to GitHub.
