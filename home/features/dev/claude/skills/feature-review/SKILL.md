---
name: feature-review
description: Independent multi-reviewer design review of one feature against a fixed code quality standard. Use when the user asks to review a feature with N reviewers.
disable-model-invocation: true
---

# Feature Review: Orchestrator

## 1. Purpose

You orchestrate an independent design review of one feature. Reviewers assess the code against the standard in [reviewer.md](reviewer.md). You merge their findings into one summary.

Design the target and plan the migration only after the user agrees on the findings. That is a separate step.

## 2. Workflow

1. **Scope.** List every file connected with the feature across the relevant repositories, grouped by layer, as `file:line` where useful. Show the list to the user and ask what is missing. Proceed only after the user confirms the scope, because a missed file leaves a gap in every report.
2. **Reviewers.** Ask how many reviewers to launch (default 2). Launch them in parallel as fresh agents, not forks, so that each starts without this conversation and judges the code independently. Give each reviewer:
   - the instruction to read `${CLAUDE_SKILL_DIR}/reviewer.md` first and follow it;
   - the confirmed file list inside a `<scope>` tag;
   - its report path: `REVIEW_<feature>_<reviewer>.md` in the project root.
3. **Validation.** When all reviewers finish, open every piece of evidence each finding cites. Drop findings whose evidence does not hold, and record the reason.
4. **Summary.** Merge the validated findings into `REVIEW_<feature>.md` in the project root. Follow Section 3 for structure and Section 4 for style. Mark where reviewers disagree.
5. **Report.** Give the user the summary path and the five most important findings.

## 3. Summary Report Structure

1. **Summary.** The most important problems and an overall verdict on the current design.
2. **Current architecture.** The data flow and module map as implemented, with file references.
3. **Findings.** One entry per problem, ordered by severity. Each entry states:
   - **Location:** `file:line`, or the set of modules affected.
   - **Criterion:** one from the Target Code Quality section of `reviewer.md`.
   - **Severity:** per the classification below.
   - **Problem:** the defect and its evidence.
   - **Impact:** the user-visible effect or the maintenance cost. For a design decision, also its original intent, where you can find it, and whether that intent still holds.
   - **Fix direction:** the fix that brings the code to the target quality, or the redesign where the design is fundamentally flawed.
   - **Alternatives:** only where a real choice exists. For each, give its mechanism, its trade-offs (performance, complexity, maintenance, migration cost) and evidence that it works in this stack. Then name the preferred option and the reason.
   - **Reviewers:** which reviewers reported it, and any disagreement.
4. **Dropped findings.** Findings you removed during validation, with the reason.
5. **Open questions.** Decisions the team must make, each with your recommendation.
6. **Unverified.** Claims you could not verify, with what you tried and what would verify them.
7. **Sources.** Every URL and dependency source file you relied on.

### Severity classification

You assign severity from the reviewers' evidence of impact, so that one scale applies consistently across all reports. Where that evidence is insufficient, mark the severity unverified.

- **Critical:** data loss, security breach, crash, or a defect that blocks the feature.
- **High:** incorrect behaviour or a significant performance defect visible to users.
- **Medium:** a maintainability or design defect that raises the cost of change.
- **Low:** a local readability or style defect.

## 4. Style

The user and the team read the summary. Write it for a technical reader who is your equal.

1. **Readability.** Aim for a Flesch Reading Ease of about 70–80 in prose. Code, identifiers and paths do not count.
2. **Sentences.** Use short words and short, simple sentences, and vary their length. Prefer active voice.
3. **Paragraphs.** One idea per paragraph, one to three sentences each. One topic per section, under a clear, informative heading.
4. **Coherence.** Order content logically, and link paragraphs and sections with clear transitions.
5. **Terms.** Use precise technical terms, and explain one briefly where a reader may not know it. Name criteria exactly as in `reviewer.md`.
6. **Analogies.** Use one only where it makes a complex design problem clearer.
7. **Concision.** Omit anything the reader does not need: no introduction, conclusion, filler, buzzwords, clichés or slang.
8. **References.** Cite specific sources only where they support a statement. Do not discuss them beyond that.
