# 2026-11-06 — RoboMimic BC 缺少训练/验证划分（当前轮聊天）

> **说明：本文件记录当前轮可核对的用户原文及助手主要答复；不是整个聊天的全量逐字导出。** 本次只提交聊天记录，不上传算法代码。

## 用户原文

**STDOUT will be forked to /mnt/4Tdata/LemonData/cross_behavior_4090_v1/runs/robomimic/PickCube-v1/demos_100_seed_42/official-bc-seed42/20261106195136/logs/log.txt**\
\
**============= Initialized Observation Utils with Obs Spec =============**\
\
**using obs modality: low_dim with keys: ['state']**\
**using obs modality: rgb with keys: []**\
**using obs modality: depth with keys: []**\
**using obs modality: scan with keys: []**\
\
**============= Loaded Environment Metadata =============**\
**obs key state with shape (42,)**\
\
**run failed with error:**\
**did not specify filter keys corresponding to train and valid split in dataset - please fill config.train.hdf5_filter_key and config.train.hdf5_validation_filter_key**\
\
**Traceback (most recent call last):**\&#xA;**&#x20; File "/mnt/4Tdata/LemonData/cross_behavior_4090_v1/upstream/robomimic/robomimic/scripts/train.py", line 504, in main**\&#xA;**&#x20;   train(config, device=device, resume=args.resume)**\&#xA;**&#x20; File "/mnt/4Tdata/LemonData/cross_behavior_4090_v1/upstream/robomimic/robomimic/scripts/train.py", line 157, in train**\&#xA;**&#x20;   trainset, validset = TrainUtils.load_data_for_training(**\&#xA;**&#x20; File "/mnt/4Tdata/LemonData/cross_behavior_4090_v1/upstream/robomimic/robomimic/utils/train_utils.py", line 118, in load_data_for_training**\&#xA;**&#x20;   assert (train_filter_by_attribute is not None) and (valid_filter_by_attribute is not None), \\**\
**AssertionError: did not specify filter keys corresponding to train and valid split in dataset - please fill config.train.hdf5_filter_key and config.train.hdf5_validation_filter_key**\
\
**To evaluate, find checkpoint with: find 'runs/robomimic/PickCube-v1/demos_100_seed_42' -name '\*.pth'**\
**ERROR: no checkpoint found under runs/robomimic/PickCube-v1/demos_100_seed_42**

## 助手（本轮答复内容）

这次已经进入 RoboMimic 官方 BC 的训练初始化阶段，环境、模型导入、HDF5 数据转换都已经通过了。当前错误是 v7 数据适配代码遗漏了训练集和验证集划分。

RoboMimic 要求在 HDF5 中创建训练、验证集 mask，并在配置中指定 config.train.hdf5_filter_key 和 config.train.hdf5_validation_filter_key。

已创建 v8 本地修复包 RoboMimic_SplitFix_v8.zip，在转换后的 100 条轨迹中按 seed=42 生成 80 条训练轨迹和 20 条验证轨迹，保证互斥，修改配置自动加载对应 mask，不改动原始 ManiSkill 数据。代码包只交付给当前对话，没有上传 GitHub。

运行方法：

~~~bash
cd /mnt/4Tdata/LemonData/cross_behavior_4090_v1
conda activate cbl4090_clean
unzip -o RoboMimic_SplitFix_v8.zip
python scripts/60_fix_robomimic_split.py
HF_HUB_OFFLINE=1 TRANSFORMERS_OFFLINE=1 bash scripts/12_train_robomimic.sh bc PickCube-v1 100 2 42
~~~

本地已测试 HDF5 80/20 不重叠和生成脚本语法；尚未在用户真实 GPU 环境完成训练验证。
