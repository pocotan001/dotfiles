---
name: pr-address-comments
description: Address all valid review comments on a PR for the current branch. Use when a PR has received reviewer feedback that needs to be addressed, including code changes, style fixes, and documentation updates.
---

# Address PR Comments

Address actionable review comments on the PR for the current branch using `gh` CLI.

Prereq: ensure `gh` is authenticated (for example, run `gh auth login` once), then run `gh auth status` so `gh` commands succeed. If your runtime blocks networked `gh` calls, rerun with the environment's elevated network/permission mode.

## Inspect comments needing attention

- Run `python scripts/fetch_comments.py` which will print out all the comments and review threads on the PR

Notes:
- If `gh` hits auth/rate issues mid-run, prompt the user to re-authenticate with `gh auth login`, then retry.

## Detailed Triage Guidance

Code review requires technical evaluation, not emotional performance.

**Core principle:** Verify before implementing. Ask before assuming. Technical correctness over social comfort.

**Include:** Unresolved threads, `issue`/`todo`/`chore` comments, maintainer feedback, `CHANGES_REQUESTED` reviews

**Exclude:** Resolved threads, `praise`/`thought`/`note` comments, and self-authored comments that do not request action. Do not auto-exclude comments from your human partner.

**Critical analysis:** Before categorizing a comment or suggesting a response, thoroughly investigate the code and context:
- **Read the code:** Carefully read the relevant code sections mentioned in the comment, including surrounding logic.
- **Challenge assumptions:** Do not take the reviewer's comment or the original code's correctness for granted. Question both.
- **Seek the truth:** Determine the most correct outcome - whether that means siding with the reviewer, defending the code, or proposing a new solution.
- **Verify bot comments:** Bot suggestions may be false positives. Always validate the issue exists before acting.

**Action types** (per [conventional comments](https://conventionalcomments.org)): `issue` / `todo` / `chore` (must fix) · `suggestion` (consider) · `nitpick` (optional) · `question` (clarify) · `praise` / `thought` / `note` (skip)

### The Response Pattern

```
WHEN receiving code review feedback:

1. READ: Complete feedback without reacting
2. UNDERSTAND: Restate requirement in own words (or ask)
3. VERIFY: Check against codebase reality
4. EVALUATE: Technically sound for THIS codebase?
5. RESPOND: Technical acknowledgment or reasoned pushback
6. IMPLEMENT: One item at a time, test each
```

### Forbidden Responses

**NEVER:**
- "You're absolutely right!" (explicit CLAUDE.md violation)
- "Great point!" / "Excellent feedback!" (performative)
- "Let me implement that now" (before verification)

**INSTEAD:**
- Restate the technical requirement
- Ask clarifying questions
- Push back with technical reasoning if wrong
- Just start working (actions > words)

### Handling Unclear Feedback

```
IF any item is unclear:
  STOP - do not implement anything yet
  ASK for clarification on unclear items

WHY: Items may be related. Partial understanding = wrong implementation.
```

**Example:**
```
your human partner: "Fix 1-6"
You understand 1,2,3,6. Unclear on 4,5.

❌ WRONG: Implement 1,2,3,6 now, ask about 4,5 later
✅ RIGHT: "I understand items 1,2,3,6. Need clarification on 4 and 5 before proceeding."
```

### Source-Specific Handling

#### From your human partner

- **Trusted** - implement after understanding
- **Still ask** if scope unclear
- **No performative agreement**
- **Skip to action** or technical acknowledgment

#### From External Reviewers

```
BEFORE implementing:
  1. Check: Technically correct for THIS codebase?
  2. Check: Breaks existing functionality?
  3. Check: Reason for current implementation?
  4. Check: Works on all platforms/versions?
  5. Check: Does reviewer understand full context?

IF suggestion seems wrong:
  Push back with technical reasoning

IF can't easily verify:
  Say so: "I can't verify this without [X]. Should I [investigate/ask/proceed]?"

IF conflicts with your human partner's prior decisions:
  Stop and discuss with your human partner first
```

**your human partner's rule:** "External feedback - be skeptical, but check carefully"

### YAGNI Check for "Professional" Features

```
IF reviewer suggests "implementing properly":
  grep codebase for actual usage

  IF unused: "This endpoint isn't called. Remove it (YAGNI)?"
  IF used: Then implement properly
```

**your human partner's rule:** "You and reviewer both report to me. If we don't need this feature, don't add it."

## Present options

```
Found {N} unresolved comments on PR #{NUMBER}: {TITLE}

Actionable Items:
─────────────────────────────────────────────────────────

1. [issue] {file_path}:{line}
   @{reviewer}: "{comment text}"
   Action: {what will be done}

2. [todo] {file_path}:{line}
   @{reviewer}: "{comment text}"
   Action: {what will be done}

3. [chore] (general)
   @{reviewer}: "{comment text}"
   Action: {what will be done}

4. [suggestion] {file_path}:{line}
   @{reviewer}: "{comment text}"
   Action: {what will be done} (optional)

5. [nitpick] {file_path}:{line}
   @{reviewer}: "{comment text}"
   Action: {what will be done} (optional)

6. [question] {file_path}:{line}
   @{reviewer}: "{comment text}"
   Action: Clarify with user

Skipped: {N} items (praise/thought/note)
─────────────────────────────────────────────────────────

Which items should I address?
Recommended: "1,2,3" (required items)
Options: "1-5" | "all" | "1,2,3" | "skip 4,5"
```

## Apply fixes

For each selected item:
1. Clarify anything unclear FIRST
2. Read the affected file and assess complexity
3. Prioritize implementation in this order: blocking issues, simple fixes, then complex fixes
4. Apply minimal fix for one item at a time and test each fix
5. Verify no regressions
6. Prepare brief reply text for the PR comment
7. Post the reply immediately in-thread with `🤖` + newline; do not leave pending replies
8. Resolve only bot-started threads, and only after posting the reply

### When To Push Back

Push back when:
- Suggestion breaks existing functionality
- Reviewer lacks full context
- Violates YAGNI (unused feature)
- Technically incorrect for this stack
- Legacy/compatibility reasons exist
- Conflicts with your human partner's architectural decisions

**How to push back:**
- Use technical reasoning, not defensiveness
- Ask specific questions
- Reference working tests/code
- Involve your human partner if architectural

**Signal if uncomfortable pushing back out loud:** "Strange things are afoot at the Circle K"

**High-complexity fixes:** If a fix requires large refactors, new abstractions, or risky changes disproportionate to the comment, stop and present the trade-off to the user. Let them decide whether to proceed, push back, or find a simpler approach.

### Acknowledging Correct Feedback

When feedback IS correct:
```
✅ "Fixed. [Brief description of what changed]"
✅ "Good catch - [specific issue]. Fixed in [location]."
✅ [Just fix it and show in the code]

❌ "You're absolutely right!"
❌ "Great point!"
❌ "Thanks for catching that!"
❌ "Thanks for [anything]"
❌ ANY gratitude expression
```

**Why no thanks:** Actions speak. Just fix it. The code itself shows you heard the feedback.

**If you catch yourself about to write "Thanks":** DELETE IT. State the fix instead.

### Gracefully Correcting Your Pushback

```
✅ "You were right—I checked [X] and it does [Y]. Implementing now."
✅ "Verified this and you're correct. My initial understanding was wrong because [reason]. Fixing."

❌ Long apology
❌ Defending why you pushed back
❌ Over-explaining
```

State the correction factually and move on.

## Summary

```bash
git status --short
git diff --stat
```

Report:
- Changes per comment with suggested reply text
- Remaining unaddressed comments
- Skipped items (questions, bot false positives)
- Next steps: `git add`, `git commit -m "fix: address PR review comments"`, `git push`

**Example summary:**

```
─────────────────────────────────────────────────────────
Summary of Changes
─────────────────────────────────────────────────────────

Addressed 3 of 5 comments:

✅ #1 [issue]: Fixed null check in utils.py
   Reply: "Fixed. Added null check before accessing the property."

✅ #2 [nitpick]: Renamed variable to snake_case
   Reply: "Fixed."

✅ #3 [todo]: Added docstring to function
   Reply: "Good catch - missing docstring. Added in utils.py:42."

⏭️ #4 [question]: Skipped - requires your input
   Question: "Should this handle the edge case of empty lists?"

🤖 #5 [suggestion] (bot): Skipped - false positive
   Bot suggested: "Variable may be undefined"
   Reason: Variable is always initialized in the preceding block

─────────────────────────────────────────────────────────

Files modified:
  src/utils.py | 15 +++++++++------

Next steps:
  git add -A
  git commit -m "fix: address PR review comments"
  git push

─────────────────────────────────────────────────────────
Post Replies to PR Comments now? (optional; immediate post, no pending)

Options: "all" | "bots" (skip humans) | "1,2,3" | "skip"
```

## GitHub Thread Replies

When replying to inline review comments on GitHub, reply in the comment thread (`gh api repos/{owner}/{repo}/pulls/{pr}/comments/{id}/replies`), not as a top-level PR comment.

Reply rules:
- Prefix every reply body with `🤖` followed by a newline.
- Post replies immediately via direct API endpoints so they are not pending.
- Never resolve threads started by humans.
- Resolving threads started by bots is allowed after posting the reply.

To post a reply to a review comment:

```bash
# For inline review comments (use the comment ID from the API response)
gh api repos/{OWNER}/{REPO}/pulls/{PR_NUMBER}/comments/{COMMENT_ID}/replies \
  -f body="🤖
Your reply text here"

# For general PR discussion comments
gh api repos/{OWNER}/{REPO}/issues/{PR_NUMBER}/comments \
  -f body="🤖
@{reviewer} Re: {brief context} - {reply text}"
```

To resolve a review thread after replying (bot-started threads only):

```bash
gh api graphql -f query="
mutation {
  resolveReviewThread(input: { threadId: \"{THREAD_NODE_ID}\" }) {
    thread { isResolved }
  }
}"
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Performative agreement | State requirement or just act |
| Blind implementation | Verify against codebase first |
| Batch without testing | One at a time, test each |
| Assuming reviewer is right | Check if it breaks things |
| Avoiding pushback | Technical correctness > comfort |
| Partial implementation | Clarify all items first |
| Can't verify, proceed anyway | State limitation, ask for direction |

## Error handling

| Issue | Solution |
|-------|----------|
| Auth failed | `gh auth login` |
| No PR for branch | `gh pr list --head $(git branch --show-current)` |
| No comments | "No actionable comments found" |
| File not found | Comment may reference deleted/moved file |
| Rate limited | Wait and retry |
| Uncommitted changes | Warn user first |

## The Bottom Line

**External feedback = suggestions to evaluate, not orders to follow.**

Verify. Question. Then implement.

No performative agreement. Technical rigor always.
