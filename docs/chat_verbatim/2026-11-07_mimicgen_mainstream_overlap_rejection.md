# 2026-11-07 — Reject MimicGen terminal-state feasibility idea due to close prior art

## User (verbatim)

这种环境的复现很多论文了吧，你这又跑到主流赛道了吧

## Assistant (substantive discussion, not a literal UI export)

Agreed. MimicGen/StackThree is a mainstream, widely-used long-horizon manipulation benchmark. A mainstream benchmark is not itself disqualifying; the critical issue is overlap of the *specific scientific contribution*.

Web-checked research directly overlaps the assistant's previous proposal to learn how successful intermediate states affect the feasibility of subsequent operations:

- Yuhan Liu et al., **Foresight Residual RL for Long-Horizon Robot Manipulation with Vision-Language-Action Models**, arXiv:2607.16506, 2026-07-17, IROS 2026 according to Rutgers lab publication page, https://arxiv.org/abs/2607.16506. It directly learns future subtask success from terminal states and guides current-subtask policy updates. This is strong prior-art conflict, not a marginally related work.
- Jung et al., **SPIN: Distilling Skill-RRT for Long-Horizon Prehensile and Non-prehensile Manipulation**, CoRL 2025, https://proceedings.mlr.press/v305/jung25a.html; skill applicability, intermediate object poses, connector policies.
- Garrett et al., **SkillMimicGen**, CoRL 2025, https://proceedings.mlr.press/v270/garrett25a.html; segmented skills, recombination, initiation/termination and long-horizon execution.

**Decision**: withdraw the proposed StackThree-based terminal-state feasibility predictor and foresight-guided policy optimization as a research topic. Stop advising the user to train it, especially after prior excessive loops of patching baseline adapters and custom environments. Do not immediately replace it with another unverified mainline topic. The next topic must first pass a short literature-overlap check (recent explicit mechanisms, not just titles), code/data availability check, and a falsifiable case in which standard same-information value/CEM/planning baselines fail. No code was uploaded to GitHub.
