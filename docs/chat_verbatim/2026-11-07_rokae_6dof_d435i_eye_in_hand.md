# 2026-11-07 — 真实机器人配置：珞石六轴 + 二指夹爪 + D435i Eye-in-Hand

> 用户本轮事实按原文记录；助手答复为研究约束摘要，不代表对话全量逐字导出。只写 Markdown，不上传程序代码。

## 用户（原文）

我的真实机械臂是6DOF的珞石机械臂，相机是眼在手上的RealsenseD435i

## 已知本聊天的硬件约束

- 真实机械臂：珞石 ROKAE，**6 自由度**，具体产品型号尚未告知。
- 末端执行器：**二指夹爪**，没有多指灵巧手。
- 视觉：**Intel RealSense D435i，Eye-in-Hand（手眼相机）**；可以使用 RGB、深度和从深度投影得到的局部点云。
- 不能假设有腕部力/力矩传感器、触觉传感器、固定第三人称相机、多指手，或现成精确珞石仿真模型。
- D435i 官方产品规格给出的典型深度工作距离为约 0.3–3 m，深度视场角约 87°×58°；近距离接触可能有深度盲区、夹爪遮挡。
  https://www.realsenseai.com/products/depth-camera-d435i/

## 助手决定（摘要）

Cross-Embodiment 是值得保留的机器人操作研究主线，不再把仅使用一台 Panda 的 Push/Pick 跨行为自建实验视为跨具身证据。真实珞石 6-DOF 作为目标机器人；仿真公开基准上的不同具身机械臂（例如 Panda）作为来源，保持两端二指夹爪和严格一致的任务目标。暂不重新造演示、训练新大模型，也不对 T-RO 创新性提前打包票。

后续训练/测试需显式考虑：
1. 两种机械臂的运动学、工作空间、关节极限、可达性差异；
2. **Eye-in-Hand 摄像机位姿随机器人运动**：RGB-D/点云相机坐标和 robot-base 坐标的转换、手眼标定、遮挡、近距离深度盲区；
3. 不同机器人控制量不可把关节动作直接混训；策略表征可考虑任务/物体坐标的目标运动与受可行性约束的 robot-specific 执行接口，但要以强 baseline 验证并不得声称首创；
4. 最终独立真实机器人成功率与小样本适配数据成本，不能用仿真中的 Panda 作为真实目标机器人的替身。

必要的下一项硬件确认：**珞石具体型号**（官方同为 6-DOF 的 xMate SR 系列等型号的负载与工作半径不同），以及能否获得 URDF / CAD / 控制接口。先确认型号，避免假设精确仿真可用。

公开资料：
- 珞石 ROKAE xMate SR 六轴参数 https://www.rokae.com/cn/product/show/544/xMateSR.html
- Intel RealSense D435i https://www.intel.cn/content/www/cn/zh/products/sku/190004/intel-realsense-depth-camera-d435i/specifications.html
