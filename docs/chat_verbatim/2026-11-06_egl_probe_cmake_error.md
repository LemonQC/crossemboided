# 2026-11-06 — RoboMimic 安装报错：egl_probe 缺少 CMake（本轮聊天）

> 此文件保存本轮用户输入及助手回复的文本。它不是整段历史聊天的全量导出。对于 UI 生成的组件，只保留其对应文字内容。

## 用户（原文）

报错：     copying egl_probe/glad/glad/glx.h -> build/lib.linux-x86_64-cpython-310/egl_probe/glad/glad
      running build_ext
      Traceback (most recent call last):
        File "<string>", line 21, in run
        File "/home/fu/SoftWare/Anaconda/envs/cbl4090/lib/python3.10/subprocess.py", line 421, in check_output
          return run(*popenargs, stdout=PIPE, timeout=timeout, check=True,
        File "/home/fu/SoftWare/Anaconda/envs/cbl4090/lib/python3.10/subprocess.py", line 503, in run
          with Popen(*popenargs, **kwargs) as process:
        File "/home/fu/SoftWare/Anaconda/envs/cbl4090/lib/python3.10/subprocess.py", line 971, in __init__
          self._execute_child(args, executable, preexec_fn, close_fds,
        FileNotFoundError: [Errno 2] No such file or directory: 'cmake'
      
      During handling of the above exception, another exception occurred:
      
      Traceback (most recent call last):
        File "/home/fu/SoftWare/Anaconda/envs/cbl4090/lib/python3.10/site-packages/pip/_vendor/pyproject_hooks/_in_process/_in_process.py", line 389, in <module>
          main()
        File "/home/fu/SoftWare/Anaconda/envs/cbl4090/lib/python3.10/site-packages/pip/_vendor/pyproject_hooks/_in_process/_in_process.py", line 373, in main
          json_out["return_val"] = hook(**hook_input["kwargs"])
        File "/home/fu/SoftWare/Anaconda/envs/cbl4090/lib/python3.10/site-packages/pip/_vendor/pyproject_hooks/_in_process/_in_process.py", line 280, in build_wheel
          return _build_backend().build_wheel(
        File "/tmp/pip-build-env-4hnn8634/overlay/lib/python3.10/site-packages/setuptools/build_meta.py", line 441, in build_wheel
          return _build(['bdist_wheel', '--dist-info-dir', str(metadata_directory)])
        File "/tmp/pip-build-env-4hnn8634/overlay/lib/python3.10/site-packages/setuptools/build_meta.py", line 429, in _build
          return self._build_with_temp_dir(
        File "/tmp/pip-build-env-4hnn8634/overlay/lib/python3.10/site-packages/setuptools/build_meta.py", line 410, in _build_with_temp_dir
          self.run_setup()
        File "/tmp/pip-build-env-4hnn8634/overlay/lib/python3.10/site-packages/setuptools/build_meta.py", line 520, in run_setup
          super().run_setup(setup_script)
        File "/tmp/pip-build-env-4hnn8634/overlay/lib/python3.10/site-packages/setuptools/build_meta.py", line 317, in run_setup
          exec(code, locals())  # noqa: S102 # exec is intentional here
        File "<string>", line 50, in <module>
        File "/tmp/pip-build-env-4hnn8634/overlay/lib/python3.10/site-packages/setuptools/__init__.py", line 117, in setup
          return distutils.core.setup(**attrs)
        File "/tmp/pip-build-env-4hnn8634/overlay/lib/python3.10/site-packages/setuptools/_distutils/core.py", line 168, in setup
          return run_commands(dist)
        File "/tmp/pip-build-env-4hnn8634/overlay/lib/python3.10/site-packages/setuptools/_distutils/core.py", line 184, in run_commands
          dist.run_commands()
        File "/tmp/pip-build-env-4hnn8634/overlay/lib/python3.10/site-packages/setuptools/_distutils/dist.py", line 1028, in run_commands
          self.run_command(cmd)
        File "/tmp/pip-build-env-4hnn8634/overlay/lib/python3.10/site-packages/setuptools/dist.py", line 1106, in run_command
          super().run_command(cmd)
        File "/tmp/pip-build-env-4hnn8634/overlay/lib/python3.10/site-packages/setuptools/_distutils/dist.py", line 1047, in run_command
          cmd_obj.run()
        File "/tmp/pip-build-env-4hnn8634/overlay/lib/python3.10/site-packages/setuptools/_distutils/command/build.py", line 137, in run
          self.run_command(cmd_name)
        File "/tmp/pip-build-env-4hnn8634/overlay/lib/python3.10/site-packages/setuptools/_distutils/cmd.py", line 342, in run_command
          self.distribution.run_command(cmd)
        File "/tmp/pip-build-env-4hnn8634/overlay/lib/python3.10/site-packages/setuptools/dist.py", line 1106, in run_command
          super().run_command(cmd)
        File "/tmp/pip-build-env-4hnn8634/overlay/lib/python3.10/site-packages/setuptools/_distutils/dist.py", line 1047, in run_command
          cmd_obj.run()
        File "<string>", line 23, in run
      RuntimeError: CMake must be installed.
      [end of output]
  
  note: This error originates from a subprocess, and is likely not a problem with pip.
  ERROR: Failed building wheel for egl_probe
Successfully built robomimic
Failed to build egl_probe
error: failed-wheel-build-for-install

× Failed to build installable wheels for some pyproject.toml based projects
╰─> egl_probe
(cbl4090) ubuntu@ubuntu-System-Product-Name:/mnt/4Tdata/LemonData/cross_behavior_4090_v1$

## 助手（本轮回答）

这个报错已经定位，**不是 RoboMimic 算法本身的问题，而是安装依赖 `egl_probe` 时找不到 CMake 编译工具。**

关键报错：

```text
FileNotFoundError: [Errno 2] No such file or directory: 'cmake'
RuntimeError: CMake must be installed.
```

日志中 `Successfully built robomimic` 说明 RoboMimic 的安装包已经成功构建，但整个依赖安装流程尚未成功完成。

### 1. 在现有 cbl4090 环境中修复

不需要重新建立 Conda 环境，也不需要重新下载数据。

```bash
conda activate cbl4090

# 安装编译工具
conda install -c conda-forge cmake ninja -y

# 确认 CMake 可用
cmake --version
```

如果 `conda-forge` 下载速度慢，可以尝试：

```bash
python -m pip install cmake ninja
```

两种安装方式任选一种即可。

### 2. 重新安装 RoboMimic

先确认当前目录仍然是：

```bash
cd /mnt/4Tdata/LemonData/cross_behavior_4090_v1
```

执行：

```bash
bash scripts/10_setup_robomimic.sh
```

成功后检查：

```bash
python - <<'PY'
import robomimic
import torch

print("RoboMimic: OK")
print("PyTorch:", torch.__version__)
print("CUDA:", torch.cuda.is_available())
print("GPU:", torch.cuda.get_device_name(0))
PY
```

随后重新执行：

```bash
CBL_RUN_EXTRA=0 \
bash scripts/31_low_cost_baselines.sh PickCube-v1 100 smoke 42
```

**注意：** 如果安装 CMake 后还出现 OpenGL、EGL 或其他 C++ 编译依赖报错，就不能继续简单地重复安装命令，需要根据新的错误判断缺少哪个系统库。优先保护已经能运行的 ManiSkill 和 DP/ACT 环境。
