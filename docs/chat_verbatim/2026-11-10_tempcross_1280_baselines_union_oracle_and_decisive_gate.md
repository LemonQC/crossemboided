# 2026-11-10 — Baseline completion, union-oracle audit, and one-stage feasibility gate

## User request (verbatim)
本次按照你的要求，终于都跑完了，仔细查看，认真分析，接下来要用最少的步骤确定是否可行，然后开展下一步的工作研究

## Verified upstream artifacts
Repo: https://github.com/LemonQC/tempcross
Latest commit: https://github.com/LemonQC/tempcross/commit/fe149302b6f9f00c96fca6236e22df4e4a72cb06
Reviewed docs/BASELINE_RESULTS.md, BASELINE_SCIENTIFIC_ASSESSMENT.md, BASELINE_FAILURE_ANALYSIS.md, BASELINE_PROTOCOL.md, BASELINE_REPRODUCIBILITY_MATRIX.md, BASELINE_REPRODUCTION.md and baselines/common/{prepare_data,dataset_adapter,action_adapter,policies,evaluator,model_factory,audit_semantics,validate}.py.
Parsed results/baselines/episodes.csv directly to compute co-success unions, rather than relying on the report's summary.
- Baseline complete: 8 newly trained setups, 4 reused BARX checkpoints, 32 evaluation cells x 40 official frozen conditions = 1,280 physics rollouts (960 Panda and 320 UR5e), two tasks and 1280 videos/checksums. Group A ZS NoReps Panda CounterSink 5/40, SinkCounter1/40; Joint Panda1/40,7/40; Joint UR5e16/40,14/40. Scratch source-only BC Transformer and diffusion achieve 0/40 even on source UR5e, thus not competent transfer baselines by themselves. Target-only models max1/40; source+target Transformer CounterSink4/40 SinkCounter0/40; DP both0. All user-provided results are from official physics task success rather than geometric proxy, but FAITHFUL_PORT (not official stock paper implementation) for robomimic-based RGB-only ports. Historic BARX LoRA has different budgets and splits.
- Failure stage classification for Panda 960: 932 failures; 745 close but no bilateral contact, 131 no close; labels are observations, not causal diagnoses.
- New offline union-oracle of same-index Panda successes:
  * CounterSink group A (four zero-shot policies): 6/40; group B (four target-only): 1/40; group C (four mixed): 6/40; all 12 methods together (unfair mix of budgets): 10/40.
  * SinkCounter group A:7/40; group B:1/40; group C:3/40; all methods union 11/40.
  * Joint+NoReps group A CounterSink union6/40 (best individual5/40), SinkCounter union7/40 (best individual7/40). Thus a policy router alone has near-zero oracle headroom.
- Major source-target morphology gap for BARX Joint CounterSink: UR5e16/40, Panda1/40. When selecting indices where source Joint succeeded and all 12 Panda methods failed, exact candidate official indices are [64,68,71,72,76,88,93,94,97,99]. These are *selected after outcome inspection*, only valid for mechanism development, not independent held-out generalization.

## Decision: one and only one next feasibility gate; no more P4/P5 toy tests
Use first 8 source-positive, Panda-all-fail cases [64,68,71,72,76,88,93,94] on Counter-to-Sink. Use already recorded UR5e successful contact sequences and P3 standard object-coordinate pose transfer / OSC. Fully verify source-target object/sink asset frame alignment. Implement three paired physical interventions in the same Panda frozen scene:
- M0 scripted source-object pose retargeting + physical grasp + closed-loop waypoint attainment, then source task transport/release/retreat by conventional OSC, privileged true object pose (classic reference).
- M1 exactly same approach/grasp/lift prefix then hand back to original pretrained Panda BARX Joint RGB policy to finish; reset action queue properly, no oracle after handoff.
- M2 same prefix then conventional privileged object-goal feedback OSC (servo based on current physical object/sink goal), not a new learning algorithm. Keep physics, success predicate, maximum task steps unchanged; no object teleport; all share exact prehandoff state (full replay/recording validation).
24 new rollouts max. Snapshot action/trajectory/contact and official success, route failure by phase. Pre-register before execution:
  - Pilot feasibility if M0 or M2 stable contact-lift >=6/8 and full task >=4/8, heuristic only not statistical proof.
  - If M1 >=4/8 full, suggests *pregrasp acquisition* bottleneck; before designing novel method must compare MimicGen/KITE/CrossZero/IK.
  - If M1 <=2/8 but M2 >=4/8 full, suggests *postgrasp feedback* bottleneck; before designing method must compare standard RGB visual servo and classic MPC.
  - If both privileged controls fail the threshold, stop this exact proposal and investigate controller/tracking constraints, do NOT train new network.
  - For middling cases use phase evidence and label ambiguous, do not expand a threshold search.
- All counts for these eight hard cases are diagnostic selection only. If positive, start a tightly scoped prototype targeted at the established missing *observable* mechanism (not pose+closure for its own sake), with RGB and optionally proprioception equally available to comparisons, train only on existing source/target data, and later pre-register novel new seeded frozen conditions. No T-RO novelty claim from these privileged probes.
- Distinguish engineering feasibility, causal phase evidence, and novelty versus literature (MimicGen object-relative retarget, KITE contact intent/decode, CrossZero object-centric IK, RobotCritic feedback). No new task, ROS, real robot, or generic new VLA.
