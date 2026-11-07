# 2026-11-07 — 新的机器人操作 T-RO 研究方向筛选（不继续旧跨行为实验）

> 当前轮话题记录：仅保存 Markdown 研究决策，非完整历史逐字聊天，不含源码。

## 用户原文

那我到底该做什么来发TRO啊，机器人操作方面的，感觉都发不了了这样

## 核实的外部文献和资源

- UniPred, `Unifying Deep Predicate Invention With Pre-Trained Foundation Models`, IEEE T-RO early access, 2026-10-12, https://unipred.github.io/ ：学习长时序操作的高层谓词和闭环恢复。新工作不能把“学可执行前后置条件”当作无人做过。
- `From Ambiguous Language to Verifiable Plans`, IEEE T-RO, 2026-07-29：使用形式规约、动态 affordance、执行监测。新工作若是简单规则接口也不够。
- RaC, IEEE RAS 2026-06-23：恢复/纠错训练已经有研究基础。
- `MoE-DP`, ICRA 2026：技能分解与恢复也不是空白。
- MimicGen official https://github.com/NVlabs/mimicgen 和 https://mimicgen.github.io/docs/datasets/mimicgen_corl_2023.html ：公开成功示范和官方训练配置；StackThree D1、Coffee D1 是实际可下载的多阶段操作任务。官方文档要求旧版 robosuite (1.4.x/commit b9d8d3...) 和 MuJoCo2.3.2，不得破坏旧 `cbl4090_clean` 环境。
- Benchmark audit arXiv 2606.04233 (2026-06-02) 指出仅靠单一标准分数和评估种子可能形成虚假泛化结论。

## 研究决策（助手答复的要点摘要）

旧 Push/Pick 跨行为课题不复活；停止写新自定义任务和手工专家，避免低可靠性采集。优选**长序列操作中间状态的连续几何可行性与后续技能成功率耦合**，而不是普通技能组合。要证明：两个状态都满足当前子目标成功条件，但后续技能成功率不同；能预测并主动形成有利于后续任务的中间状态。首选公开 MimicGen StackThree D1，次选 Coffee D1，训练和评估沿用官方的 robomimic/robosuite 数据与设置。数据、官方基线、训练/评估必须先独立跑通，且有严格两阶段停止条件。

强对照必须含不加约束的 BC-RNN/DP、几何距离启发式、动作序列状态价值模型、相同信息的 value-guided CEM 或 MPC，以及共享网络但不施加可行性损失的消融。如果同预算 Q-CEM 表现相同，不能虚称算法必要性。只有确实能找到稳定的“子任务表面成功但后继不成功”的几何反例，才开展新算法。支持新的研究问题，不等于已达到 T-RO；完整 T-RO 仍需多个任务、强近期 baselines、反事实干预、统计与有条件的真实机器人验证。
