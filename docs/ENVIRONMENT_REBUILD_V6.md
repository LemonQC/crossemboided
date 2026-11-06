# v6: recreate clean CPython environment

The old `cbl4090` is confirmed to use **GraalPy**, `torch 2.14.1`, and GraalVM JSSE. Do not try more RoboMimic installs in it.

## Run (original project's root directory)

```bash
cd /mnt/4Tdata/LemonData/cross_behavior_4090_v1
# Copy/checkout the scripts from this repository, without overwriting your existing project files.
bash scripts/40_rebuild_clean_env.sh
conda activate cbl4090_clean
bash scripts/41_test_clean_env.sh
```

The script creates a **new** env, preserves old env + datasets + models, forces CPython using defaults channel, installs PyTorch 2.5.1 / CUDA 12.1 wheels, ManiSkill 3, and basic training dependencies. No original data are redownloaded. Do not use the old `scripts/10_setup_robomimic.sh` until reviewed. Optional `CBL_WITH_ROBOMIMIC=1` installs only the RoboMimic package without its transitive dependencies, so a successful import/training is **not** guaranteed.

**GPU requirement:** NVIDIA driver must support CUDA 12.1 runtime. No live GPU test was possible in the build environment. If dependencies conflict, the installer stops; read `results/env_rebuild/rebuild_cbl4090_clean.log`. The script fails rather than silently replacing torch or python.

**Compatibility:** Matching the exact historical working DP/ACT environment may require additional packages or a known-good lockfile. This v6 is a practical fresh baseline, not verified numerical reproduction. Keep existing checkpoints and records.
