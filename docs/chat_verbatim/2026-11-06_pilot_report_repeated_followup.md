# 2026-11-06 — Pilot 汇总表重复提交与下一步诊断

> 记录范围：本轮对话，用户内容逐字，助手回应为当前答复要点摘录。不是完整历史逐字导出。本提交只有 Markdown 聊天文档，没有算法代码。

## 用户（原文）

(cbl4090_clean) ubuntu@ubuntu-System-Product-Name:/mnt/4Tdata/LemonData/cross_behavior_4090_v1$ bash scripts/50_run_everything.sh report

cat results/all_in_one/summary.md
Collected 6 actual rollout records: /mnt/4Tdata/LemonData/cross_behavior_4090_v1/results/all_in_one/summary.csv / /mnt/4Tdata/LemonData/cross_behavior_4090_v1/results/all_in_one/summary.md
# Actual rollout results only

No unrun algorithm or test has been assigned a score.

| Record | Task | Method | Episodes | Success once | Success at end |
|---|---|---|---:|---:|---:|
| results/all_in_one/PickCube-v1_bc_100_20_seed42_rollout.json | PickCube-v1 | bc | 20 | 0.0% | 0.0% |
| results/all_in_one/PickCube-v1_bc_100_2_seed42_rollout.json | PickCube-v1 | robomimic_official | 2 | 0.0% | 0.0% |
| results/all_in_one/PickCube-v1_bc_gmm_100_20_seed42_rollout.json | PickCube-v1 | bc_gmm | 20 | 5.0% | 0.0% |
| results/all_in_one/PickCube-v1_bc_gmm_100_2_seed42_rollout.json | PickCube-v1 | robomimic_official | 2 | 0.0% | 0.0% |
| results/all_in_one/PickCube-v1_bc_rnn_100_20_seed42_rollout.json | PickCube-v1 | bc_rnn | 20 | 0.0% | 0.0% |
| results/all_in_one/PickCube-v1_bc_rnn_gmm_100_20_seed42_rollout.json | PickCube-v1 | bc_rnn_gmm | 20 | 0.0% | 0.0% |
(cbl4090_clean) ubuntu@ubuntu-System-Product-Name:/mnt/4Tdata/LemonData/cross_behavior_4090_v1$

## 助手答复摘要

用户此次重复执行的是 `bash scripts/50_run_everything.sh report`，只是再次整理旧 JSON，并非生成新诊断。当前有效 20 Epoch Rollout 只有 BC、BC-GMM、BC-RNN、BC-RNN-GMM 四项（0%、5%、0%、0% once；end 都为 0%）；另外两条来自 2 Epoch 的 Smoke。BC-Transformer 与 BC-Transformer-GMM 未产生评估记录。

已核对 v7 `scripts/50_run_everything.sh` 的 Pilot 顺序依次是 `bc bc_gmm bc_rnn bc_rnn_gmm bc_transformer bc_transformer_gmm`，脚本设置了 `set -Eeuo pipefail`，所以首个未完成方法很可能在第五项时中断。需要检查 `results/all_in_one/pilot_PickCube-v1_100_seed42.log` 的最后 100 行，并运行只读 `diagnose_pilot_v10.py` 生成 `pilot_diagnostic_v10.md`，而不是继续 report、Full 或增加训练时长。当前不能把结果直接归因为模型能力不足，也不构成跨行为论文假设的验证。
