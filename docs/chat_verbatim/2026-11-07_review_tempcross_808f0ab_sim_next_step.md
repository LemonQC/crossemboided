# 2026-11-07 — Review of tempcross commit 808f0ab: next step without physical robot

## User (verbatim)
可以先不考虑真机哈，你去看看分析一下，怎么下一步：本轮代码验证和实验已经运行结束，报告、代码及结果已提交到目标仓库。
 
  •10 项测试通过。.
  •完成 36 个场景，其中 27 个独立测试场景。
  •1提交：808f0ab19b1fb0be6bbc9f20445744ab8db8b87a。
  •1结论：PROXY_ONLY / INSUFFICIENT_EVIDENCE，暂不支持学习算法立项。
 
  本轮没有运行真实机械臂；真实标定与物理执行验证仍未完成。

## Review grounded in actual repository
Inspected GitHub LemonQC/tempcross branch main, docs/VALIDATION_REPORT.md, docs/NEXT_STAGE.md, docs/VALIDATION_PROTOCOL.md, docs/NOVELTY_AUDIT.md, coftvalidation/*.py, evidence/v1/{statistics,integrity,manifest}.json, strata.csv, and BARX official docs.
- 36 scenes total, 9 development and 27 held-out from 3 seeds, 8 candidate actions each × obstacle pair × two robots and two hypothetical mounts.
- Panda 187/216 IK paths found; SR5 188/216. Panda 82/216 feasibility-proxy; SR5 23/216, dominated by SR5 152/216 arm-environment *proxy* collisions. Some such proxy failures occur even without obstacles. Treat this as a model/proxy and candidate-distribution concern, not as direct physical SR5 inferiority.
- Candidate menu only 2 antipodal grasps × 4 fixed transport route patterns, fixed contact pathway, cannot demonstrate learning advantage outside menu.
- Expected optical observation calculated from identical desired TCP trajectory and same mount between robots; therefore camera-only factor is identical across robots by design and factorial interaction cannot diagnose genuine body-specific executed view trajectories except exploratory self-occlusion; report itself says achieved-view occlusion hardly changes selected outcomes.
- The static geometry label 'F AND visibility' is also the analytic selector's criterion; exact enumeration reaches the same geometric coverage ceiling by construction. No independent simulated dynamics, grasp, place, feedback or closed-loop success labels. Report labels appropriately PROXY_ONLY.
- Panda vs SR5 proxy feasibility 37.96% vs 10.65%; interaction delta -1.39 percentage points CI [-5.09,+1.86] spanning 0. The effect to be explained is not a measured learning-relevant coupling.
- Initial 'D, insufficient evidence' is calibrated to REAL hardware prerequisites. Since user explicitly allows simulation-only this phase, one must define a separate honest simulation scientific gate, rather than keep demanding real hand-eye calibration and then automatically return INSUFFICIENT_EVIDENCE.

## Decision
Archive static COFT v1 as a software geometry diagnostic; **do not train a new network, and do not expand to more toy geometry scenes**. Not a global rejection of cross-embodiment robotics. Next use an OFFICIAL multi-arm dynamic manipulation benchmark and baseline checkpoints to obtain independent simulator task outcomes, with no own demonstration synthesis or custom robotics tasks. BARX/RoboCasa-X official repository https://github.com/ajaysridhar0/barx confirmed public sim, raw/processed data and MiniVLA/checkpoints, 100 fixed evaluation conditions, simulation-supported Panda and UR5e embodiment entries; verify each real gripper definition and evaluation command works before claiming target compatibility. Official walkthrough uses ~70GiB disk, reference main training is 8 GPUs × 32 and not feasible to declare same replication on single RTX4090. A pretrained-checkpoint rollout is not a complete 8-GPU training reproduction.

Short simulated gate:
- Phase 0: official end-to-end one-episode then small fixed-seed multi-arm closed-loop baselines, stable videos and task success; do not change scenes, cameras or create experts until works.
- Phase 1: under identical physics task/held-out states compare source-to-target policy transfer with same control interface, isolate robot morphology and camera mount factors (only if official simulator supports a wrist-mounted camera; adding it is an intervention and may cause observation distribution shift, which must be controlled).
- Phase 2: analyze genuine failure modes by source vs target executable outcome and observation uncertainty, with equal-input strong controls: source model, target-only small-data adaptation, direct joint data mixing, IK+collision+visibility shielding, belief/visual servo/MPC; no model training until at least one reliable *independent* outcome gap not explained by simple planning.
- If no stable gap, stop COFT **learning mechanism** and redirect to another evidence-based cross-embodiment failure, not automatically reject the field. Keep failure modes and scene stratification.
- Source archive here only; user did not request edits to tempcross in this turn. Do not upload code without a new explicit request.
