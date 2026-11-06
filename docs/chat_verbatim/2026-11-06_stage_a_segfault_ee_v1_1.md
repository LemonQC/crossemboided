# 2026-11-06 — Stage A native segmentation fault and EE-control repair decision

> Current-turn chat archive. The user message is verbatim; assistant reply is an explicitly labeled factual summary because full UI serialization is not available. The full past conversation remains incompletely exported. This commit contains only Markdown, not executable code.

## User (verbatim)

```text
(cbl4090_clean) ubuntu@ubuntu-System-Product-Name:/mnt/4Tdata/LemonData/cross_behavior_4090_v1$ bash run_stage_a.sh
run_stage_a.sh: 第 6 行： 4192481 段错误               （核心已转储） python -m formal_cb.workflow a 2>&1
     4192482 已完成               | tee formal_stage_a.log
```

## Assistant response (summary of work and instructions; not verbatim)

The Stage A process crashed with a native segmentation fault rather than a Python exception; there was not enough evidence to determine the exact crashing library. The v1 package introduced a native MPLib-based Panda motion planner with `pd_joint_pos` control, even though the user's earlier ManiSkill PickCube workflow had already simulated `pd_ee_delta_pos` successfully. Replacing that new planner dependency with an end-effector-space procedural Push/Pick controller was judged to be a lower-risk experiment design.

A full local-only replacement ZIP `FormalCrossBehavior_EE_v1_1.zip` was delivered to the user in the conversation; no source code was pushed to GitHub. The implementation uses Panda's 4D `pd_ee_delta_pos` actions, CPU PhysX, no `mplib` import in expert code, no RGB rendering in demonstration generation, and a fresh data/results root `formal_results_ee_v1` to avoid action-space data contamination.

The revised Stage A checks two procedural experts against the same task success function, requires each to pass 18/20 trials and checks physical behavior validity and initial-state identity. It stops early after 3 failed episodes for one behavior. The diagnostic launcher uses Python faulthandler and clear import, construction, reset, and seed markers. The assistant recommended one run of `bash run_stage_a.sh`, then `bash run_stage_b.sh` only after Stage A says GO. If segfaults persist, only `tail -30 formal_stage_a_ee.log` is needed to locate the failure; no automatic rebuilding or continuing the endless Oracle diagnostic loop.

Local checks: Python compile, shell syntax, compressed ZIP CRC, and two synthetic learning/model unit tests passed. Real physics was not tested in the assistant container because ManiSkill/SAPIEN are absent; no success rate or native crash resolution was claimed.
