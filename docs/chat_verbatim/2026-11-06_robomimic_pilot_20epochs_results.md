# 2026-11-06 — RoboMimic Pilot（20 Epoch）结果

> 当前轮聊天记录。仅存储文字，不上传诊断脚本或其他代码。助手最终答复中可能包含为便于阅读而整理的命令，不代表更早历史的完整导出。

## 用户原文

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

## 助手（当前轮答复内容）

这组结果说明：**RoboMimic 的基础实验已经从安装调试进入实际性能验证阶段，但目前不能直接开始 100 Epoch 的正式训练。**

### 目前的结果

| 算法 | 训练轮数 | 评估次数 | Success Once | Success at End |
|---|---:|---:|---:|---:|
| BC | 20 | 20 | 0% | 0% |
| BC-GMM | 20 | 20 | 5% | 0% |
| BC-RNN | 20 | 20 | 0% | 0% |
| BC-RNN-GMM | 20 | 20 | 0% | 0% |
| BC-Transformer | — | — | 未得到结果 | 未得到结果 |
| BC-Transformer-GMM | — | — | 未得到结果 | 未得到结果 |

另外两条 2 Epoch 的记录属于上一轮 Smoke Test，不能与本轮 Pilot 混为一谈。

目前有三个重要判断：

1. **四种算法的实际闭环表现很差。** BC-GMM 的 5% 代表 20 次评估中仅 1 次曾经成功，而且最终没有保持成功。
2. **六种算法尚未跑齐。** 汇总中缺少两个 Transformer 变体，需要查明是没有执行、训练失败还是评估失败。
3. **还不能认定是模型能力不足。** 必须先确认 checkpoint、训练损失、数据及动作适配是否正确，再判断是否值得增加训练轮数。

对于后续 T-RO 论文，这是必要的区分：如果底层评估存在问题，继续堆训练时间只会产生无效结果。

### 后续行动

提供本地下载的只读诊断脚本 `diagnose_pilot_v10.py`。在项目根目录运行，可分析六种方法的结果完整性、checkpoint 与方法匹配、训练日志、HDF5 训练/验证集划分、动作统计、训练配置，输出 `results/all_in_one/pilot_diagnostic_v10.md` 与 `.json`。脚本不会训练、下载数据、改写模型或 HDF5，仅写诊断报告。本地已通过空项目和合成四方法结果/100-demo 数据测试；尚未在用户服务器执行。

需优先核实为何 Transformer 两种方法缺失，并排查已有四种方法 0～5% 成功率的根因。20 Epoch 当前脚本设定 200 step/epoch，理论上有约 4000 优化步，低成功率不应仅归结为训练不足。尚不能支持跨行为或跨本体论文创新结论；现阶段 PickCube 是基础管线验证。
