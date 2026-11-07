# 2026-11-07 — 确定真实机器人型号与夹爪型号

> 当前轮科研讨论纪要。仅保存 Markdown，不上传代码。用户当轮原文逐字保留，助手建议为摘要，并非完整历史记录。

## 用户（原文）

ROKAE SR5-5/0.9C，夹爪是PGIA-140-80-W

## 实物设备最终配置

- **ROKAE SR5-5/0.9C**（珞石六自由度协作机械臂）
- **DH Robotics PGIA-140-80-W**（大寰二指平行电动夹爪）
- **Intel RealSense D435i**, Eye-in-Hand
- 本项目按单臂、二指抓手开展研究，不假定多指灵巧手、触觉传感器、外部固定相机或第二台真实机器人。

## 公开参数和文档（已核对）

1. 珞石产品官方页面：https://www.rokae.com/cn/product/show/544/xMateSR.html
   - SR5-5/0.9C：6 DOF、5 kg 最大负载、919 mm 最大臂展、±0.03 mm 重复定位精度。整套末端工具、相机、安装支架及工件的质量共同计入有效负载。
   - 型号后缀对应实际各轴角度限制存在配置差异，不预先把 ±360° 或 ±175° 当作适用于每一实机。
2. 大寰 PGIA 系列官方页面：https://www.dh-robotics.com/product/pgia
   - PGIA-140-80：80 mm **总行程**、40–140 N **单侧夹持力**、最大推荐 3 kg 工件、约 1 kg 本体质量、RS485/Modbus RTU 或数字 I/O 标准接口（选配 TCP/IP 等）。用户型号是 `PGIA-140-80-W`；未查明 W 后缀确切电气/机械意义，不作臆断。
   - AUBO 第三方技术文档提供 PGIA-140-80-W&O-F2 3D 模型链接：https://developer.aubo-robotics.cn/ecology_manual/end_effector/DH_robotis/pgia.html
3. 珞石 2026-09-07 ROS 2 官方手册：https://docs.rokae.com/en/docs/ROS2/rokae%20ros2%E4%BD%BF%E7%94%A8%E6%89%8B%E5%86%8C/
   - 支持 `xMateSR5` 系列 robot_type，`rokae_description`、ROS 2 Humble、MoveIt 2、`ros2_control` 和相关仿真/实机驱动，官方源码 https://github.com/RokaeRobot/rokae_ros2 。需核实 SR5-5/0.9C 特定控制柜和固件与此 ROS 2 软件兼容，不能把文档列出“SR5”直接当作已完成实机联调。
4. 珞石 xCore v3.2 末端工具指令：https://docs.rokae.com/docs/xCore/_versions/V3.2/15-rl-%E6%8C%87%E4%BB%A4/%E6%9C%AB%E7%AB%AF%E5%B7%A5%E5%85%B7%E6%8C%87%E4%BB%A4/
   - `DhGripInit`, `DhGripMove`, `DhGripGetStatus` 针对大寰 **PGI-140-80 系列**有具体定义。用户实机为 **PGIA** 而非 PGI，不能未经验证就承诺完全兼容；要核实控制版本、通讯协议、驱动型号和实际状态读取能力。

## 后续 Cross-Embodiment 实验边界

将珞石机械臂作为唯一真实目标本体；仿真源机器人可选 Panda 等不同运动学机械臂但保持二指夹爪。必要的准备工作：官方精确 URDF（包括实际关节限制与法兰坐标）、PGIA 指端 CAD 和控制协议、手眼标定、相机到夹爪 TCP 的外参、碰撞模型、workspace/夹爪负载与实机安全限速。优先利用官方 `rokae_ros2`，不重新编写大量本体驱动或造专家数据，不在尚未证明科研假设时启动昂贵的大规模 VLA 训练。

**当前仅锁定硬件，不承诺 T-RO 方法创新已经成立。**
