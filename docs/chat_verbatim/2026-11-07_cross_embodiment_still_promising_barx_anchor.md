# 2026-11-07 — Cross-embodiment 值得继续，但须更换实验切入点

> 当前轮研究讨论纪要。仅保存 Markdown；并非整个对话的逐字导出，没有上传任何代码。

## 用户原文

但是，我觉得cross-emboidement当前很火啊

## 讨论结论（助手回应内容摘要）

- 认可 cross-embodiment manipulation 在 2026 年持续活跃，不因过去同一 Panda 的手工 Push/Pick 专家失败就否认机器人跨具身研究方向。特别区分：用户参考的 Cross-Behavior T-RO 工作实际上同时涉及跨具身和跨行为，而此前自建实验只有单个 Panda，并没有完成严格跨具身验证。
- 对照 2026 BARX (ICRA; https://github.com/ajaysridhar0/barx), CEI (RA-L), CrossZero (CVPR Workshops), ZETA (CoRL), KITE 与 Keypose Exploration 发现：仅作轨迹统一、末端 IK、功能相似度、接触意图解耦或可达关键位姿筛选都有相近先例；不能先宣称原创性。
- 建议把方向层面保留为“目标机器人执行能力约束下的选择性跨具身迁移”候选问题，优先验证不同机器人上相同任务的源数据是否造成真实负迁移；不把尚未核实的技术机制称为 T-RO 创新。
- 已核对 BARX 官方仓库公开 RoboCasa-X 仿真、MiniVLA 训练/评估、RLDS/HDF5 数据与 checkpoint；README 的 walkthrough 需要约 70 GiB 磁盘，并有单 GPU 训练检查命令。该仓库不是已保证单卡4090高效复现整个基准。
- 下一步应使用官方模型与公开数据，在同任务、跨机器人、严格训练曝光协议下，对比 target-only、直接混合、简单源数据筛选与原 BARX；只有在可重复的具身约束负迁移且现有简单强对照失败时才进行方法开发。不要再从零编写专家、重启 v14+ Oracle 或承诺 T-RO 必中。

## 官方参考

- BARX official code https://github.com/ajaysridhar0/barx
- Cross-Embodiment Transfer via Behavior-Aligned Representations https://arxiv.org/abs/2607.27549
- CEI https://ieeexplore.ieee.org/document/11361084/
- ZETA https://arxiv.org/abs/2609.02546
- KITE https://arxiv.org/abs/2606.22113
- Keypose Exploration https://arxiv.org/abs/2606.29028
