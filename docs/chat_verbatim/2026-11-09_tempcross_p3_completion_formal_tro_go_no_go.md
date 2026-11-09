# 2026-11-09 — P3 completion and T-RO formal-study go/no-go

## User message (verbatim)
这次按照你的要求，全部执行完毕了，你去github看看，是否可以开始正式的实验了

## Actual sources inspected
- P3 commit: https://github.com/LemonQC/tempcross/commit/bd0e2864eece26fe27b2b4ccb4fae889cbdf7c82
- docs/P3_SCIENTIFIC_DECISION.md
- docs/P3_SPATIOTEMPORAL_CAUSAL_REPORT.md
- docs/P3_STRONGER_ADAPTATION.md
- docs/P3_FROZEN_PROTOCOL.md and P3_PROTOCOL_AMENDMENT_01.md
- configs/p3_protocol.json
- evidence/p3/execution/ directory and p3_validation source tree.
- Related work: MimicGen CoRL 2023 object-relative EE trajectory source-transformed motion; KITE 2026 zero-shot interaction intent plus kinematic decoder; CrossZero CVPRW 2026 object-centric hierarchical EE/IK diffusion; CEI IEEE RA-L 2026 diverse embodiment alignment; TRO 2026 Cross-Behavior Learning With Object Flow Prediction for Robotic Manipulation DOI 10.1109/TRO.2026.3701576.

## Verified results
- Original official BARX/Panda target transfer and controls: new untouched 40–59 condition set Joint UR5e 6/20, Joint Panda 2/20, B1 Panda 1/20, earlier 6k LoRA Panda 2/20, new 96k LoRA Panda 2/20. Source/target difference 4/20; small N, wide intervals.
- P3 A1/A2/A3 developed on 8 *selected, previously examined* conditions; A1 stable grasp 1/8 full 1/8, A2 0/8 full 0/8, A3 stable 8/8 full 5/8. A3 additionally includes *privileged object truth*, fixed planned approach, closed-gripper action, lift, transfer, placement and retreat. It is NOT a learned method, does not isolate spatial vs temporal effects, and was not separately evaluated on untouched 40–59 as an official comparable RGB algorithm.
- A1 has long bilateral finger contact but inadequate load lift on several conditions; A3 introduces post-grasp transport/lift actions, so its advantage cannot uniquely imply a new contact-pose alignment insight.
- New LoRA 12,000 optimizer updates x batch8 = 96,000 samples, 18.71 GiB peak allocated and full sampled provenance, passes test; still only 1/8 of released paper's example 768,000 samples and uses restricted LoRA rather than full parameter. It does not exclude fully trained standard adaptation.
- There is no independent fair common-observation head-to-head with MimicGen/object-relative pose retargeting, contact-aware IK planner, KITE/CrossZero equivalents. Proposed algorithm itself is not coded or defined beyond a concept.
- The report has complete evidence of development and testing, but *this is the conclusion of a pre-study, not a T-RO paper-level novel method validation.*

## Decision
**NO-GO for starting full-scale T-RO experiments in the *current COFT / pose+closing* algorithm branch.** This is NOT an attack on the user's execution: they completed the requested P0/P1/P2/P3 correctly. Stop iterating P4 or raising bars retroactively. Freeze/retain code, trained models and logs, and be explicit about which outputs are publishable negative/engineering observations. The workload should not be repeated; existing platform is reusable.

Suggested practical next step:
1. Close P3 (do not train more COFT): preserve immutable results, model hashes, provenance, reproducible commands, stage-classification labels, highlight privileged vs RGB.
2. Before any new formal *method* experiment, define a problem with demonstrably differentiating algorithmic claim beyond source contact poses, motion retargeting, or extra LoRA; name equal-information strong baselines and >=2 tasks/embodiment transfers; preserve one clear logical contribution. Do NOT promise T-RO acceptance from these results.
3. If continuing cross-embodiment, formulate a new separate hypothesis anchored in *post-contact task-effect feedback*, distinguish from published 2026 object-flow and contact/intent transfer; do not silently relabel COFT failure as verified novel method. This would be an entirely new proposal, not continuation of COFT formal results.
4. No more blind P4/P5 threshold changes or oracle diagnosis as substitute for algorithm novelty.

## Limitations
The Github interface exposes source and committed results, but not re-execution on the user's GPU or direct playback of unmounted server videos. Checked reported SHA paths and source code/report claims rather than personally verifying 124 local videos.
