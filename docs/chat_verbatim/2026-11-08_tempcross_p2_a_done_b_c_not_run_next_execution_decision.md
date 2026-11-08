# 2026-11-08 — 最新 tempcross P2 实验核查及执行决定

## 用户原文
现在呢，按照你的要求都完成了吧，你继续思考，给出方案

## 来源与最新提交
- https://github.com/LemonQC/tempcross/commit/74e57e36594ac7c25a4b410fa619fdf4c6d43603
- https://github.com/LemonQC/tempcross/commit/11b79e8636af9985e15261a0fc82f4759c50c540
- docs/P2_GRASP_CAUSAL_AUDIT.md, P2_INTERVENTION_REPORT.md, P2_TARGET_ADAPTATION.md, P2_SCIENTIFIC_DECISION.md, P2_WORKSPACE_SYNC_AUDIT.md
- evidence/p2/status.json and evidence/p2/offline_audit_verified/summary.json, episodes.csv
- p2_validation/offline_audit.py and tests/test_p2_offline_audit.py

## 实际已完成
- 初始官方 BARX P1 80 次物理仿真闭环：No Reps UR5e 5/20、Panda 1/20；Joint Reps UR5e 9/20、Panda 0/20。
- 新的 P2-A 离线诊断：基于上轮开发集 0–19 的 80 条轨迹计算真实指垫/TCP相对位姿、原始夹爪信号、夹爪动作、关节状态和接触；代码和明细已推送。
- 17 条 Joint Reps Panda 全程未闭爪；原夹爪输出最小值约0.738，轻调阈值到0.6/0.7不会触发闭爪，0.9+会触发但可能过早。
- 物体中心与指垫棱柱判据只在15条成功中出现6条，低召回且不包含物体全形状，不能当作合法抓取Oracle。
- P2-B新物理干预：NOT_RUN，测试 20–39 为0次。P2-C Panda目标适配：NOT_TRAINED，0 training steps；没有任何新成功率。状态 INSUFFICIENT_EVIDENCE 不等于研究失败。
- 此前“先不跑训练或仿真，仅找回同步”请求是导致没有新跑B/C的直接操作约束；下一条给Codex的执行指令必须明确允许并要求进行新的仿真/有限训练，不再停留在报告。

## 下一步固定方案（实操）
**只做 P2-B 物理干预和 P2-C 公开目标数据适配，保留 BARX、RoboCasa-X、UR5e/Panda、二指夹爪、固定agentview、pnp_counter_to_sink、官方成功判据、官方checkpoint，且不引入真机或ROS。**

1. 开发窗 0–19：新建实验模块，先严格验证如何从已记录官方初态+动作前缀重放候选时刻以得到相同 qpos/qvel/EEF/物体/控制器状态，然后在相同分支点干预第7维夹爪动作；不得仅设置qpos冒充完整反事实。
2. B1 non-privileged gripper threshold/hysteresis：仅用当前策略夹爪输出及其历史，不读取仿真物体真值/接触；仅在最多8个旧开发条件比较事先列出的阈值（如0.85/0.90/0.93）和固定滞回/保持，锁定一个规则，不根据新测试调参。记录早闭/误闭/成功救回。
3. B2 privileged physics intervention，明确DIAGNOSTIC_NOT_UPPER_BOUND：利用仿真物体/指垫完整碰撞几何及接触状态，验证曾成功轨迹的正对照，选择有限候选时机下单独辅助闭爪的物理反事实；如果Oracle未被开发验证，不运行/宣称有效的上界；远离失败的抓取要区分“无有效机会”与“闭爪时机不对”，而非单棱柱判断。
4. 新冻结集20–39：实现官方bundle完整验证后取窗，无错用start_seed偏移；保持实际seed/condition_id/model/state checksum；B0 Joint UR5e20+Panda20；No Reps Panda20；B1 Panda20；经开发验证的B2 Panda20 (最多100次)，全部真实物理成功/每对救回和损害+视频。若B2无效，将状态标为NOT_VALIDATED而不是0%成功。
5. 官方 target_50 Panda PnP为50条Counter→Sink +50条Sink→Counter，即总100条；官方XP900 target adaptation混源RLDS，不能静默用仅目标数据冒充官方。先审计训练/测试是否同轨迹与动作/夹爪规范；训练单步显存/梯度可行性探针。若3090预算支持，No Reps/Joint Reps相同训练样本数、优化预算进行目标适配并在20–39各20次独立物理评估；受限LoRA与低batch必须明确标注，不能以不足训练下失败判定常规适配无效。
6. 20–39首次看结果后严禁改超参；必要时用40–59进行冻结确认，不因没有达到预期就改种子。自源的上轮结果不能复用为新测试的数量。
7. 方案判断：B1若大幅救回，则停止“必须新增学习式夹爪残差”；常规适配若足够，则停止“零样本差距就是TRO贡献”；B1/充分适配依然失败但validated physical oracle能在同样条件救回，才进入跨具身接触阶段推理/纠正的新算法审查。20 条仅研发筛查，不是TRO论文终结论。眼在手上可观测耦合从未实测，不允许在本轮宣称验证。
8. 向 LemonQC/tempcross 推送真实可运行源码、精确环境/命令、新物理成功率JSON/CSV、完整逐次失败日志索引/视频路径和结论。保留旧完整结果，不重复旧80次；只在真实做完后报告commit，不伪造执行。

## 决定
不立刻开发全新 COFT 网络，不改研究平台；下一次必须执行物理干预，而不是继续添加离线分析。非完结状态要精确报告。对方法新颖性尚未作自动正面结论。
