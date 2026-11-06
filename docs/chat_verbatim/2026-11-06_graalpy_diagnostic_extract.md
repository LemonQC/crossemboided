# 2026-11-06 — GraalPy 诊断结果（当前轮可核对原文节选）

> **归档状态：部分原文节选，不是完整逐字聊天。** 当前轮较长的命令回显和两段完整 Python Traceback 尚未无遗漏录入；需要对话原始导出才能完成全量逐字归档。

## 用户消息（逐字节选）

```text
========== Python Paths ==========
/home/fu/SoftWare/Anaconda/envs/cbl4090/bin/python
/home/fu/SoftWare/Anaconda/envs/cbl4090/bin/pip
/home/fu/SoftWare/Anaconda/envs/cbl4090/bin/python3
/usr/bin/python3
/bin/python3
========== Interpreter ==========
Executable: /home/fu/SoftWare/Anaconda/envs/cbl4090/bin/python
Implementation: GraalVM
Version: 3.10.8 (Wed Jun 14 15:29:07 CST 2023)
[Graal, GraalVM CE, Java 17.0.7]
Prefix: /mnt/4Tdata/Anaconda/envs/cbl4090/lib/jvm/languages/python
PYTHONHOME: None
PYTHONPATH: None
torch => /mnt/4Tdata/Anaconda/envs/cbl4090/lib/jvm/languages/python/lib/python3.10/site-packages/torch/__init__.py
pip => /mnt/4Tdata/Anaconda/envs/cbl4090/lib/jvm/languages/python/lib/python3.10/site-packages/pip/__init__.py
ssl => /mnt/4Tdata/Anaconda/envs/cbl4090/lib/jvm/languages/python/lib/python3.10/ssl.py
graalpy => NOT FOUND
========== Environment ==========
graalpy                   23.0.0          0_graalvm_native    conda-forge
pip                       26.2.2             pyhc872135_0
python                    3.10.8          0_native230_graalpy    conda-forge
python_abi                3.10            9_graalpy230_310_native    conda-forge
torch                     2.14.1                   pypi_0    pypi
torchvision               0.29.2                   pypi_0    pypi
========== SSL ==========
GraalVM JSSE
Normal Python:
/home/fu/SoftWare/Anaconda/envs/cbl4090/bin/python
ImportError: Failed to load PyTorch C extensions:
Isolated Python:
/home/fu/SoftWare/Anaconda/envs/cbl4090/bin/python
ImportError: Failed to load PyTorch C extensions:
Isolated SSL:
GraalVM JSSE
```

## 助手处理建议（摘要，非逐字）

确认 Conda 环境被 GraalPy 替代，停止安装 RoboMimic 和 PyTorch；先运行只读的 conda list --revisions、readlink -f python 和环境备份，找到可回滚的 CPython 版本。回滚前仅执行 dry-run，暂不修改现有环境。

> 如需供专家核验的整轮双向逐字记录，仍需 ChatGPT 官方原始导出；不得用本文件替代。
