# Working agreements

Defaults for every project; a request from me or a project's own CLAUDE.md / AGENTS.md wins.

## Communication

- Lead with the result, then the details; short paragraphs, tables or numbered lists when they help.
- Explain in plain words; say what a setting or command does, not just its name.
- When I should run a command myself (on my machine, outside your sandbox), give it in one fenced code block.

## Scope and changes

- Work in small agreed steps and stay inside the step I approved; flag anything outside it instead of doing it.
- Keep changes minimal: no unrequested refactors, options or abstractions. Match the existing style.
- Keep my content: prefer commenting out over deleting, list what you would remove before removing it, and ask when two versions conflict.
- Read the relevant files before answering or changing anything; don't make claims about code you haven't opened.
- For a fix, find the cause first; don't silence checks, add ignores or special-case inputs to make them pass.
- When renaming or removing something, check what uses it (other files, links, config names).
- Remove temporary files you created; put scratch work outside the repo.
- Never hardcode, print or commit secrets.

## Git

- Commit only when I ask or we agreed on it, one commit per change, with explicit paths (never `commit -a`): I often edit files in parallel.
- Never push, force-push, reset or delete branches unless I ask.
- Commit messages follow the repo's style (here: `area: what changed`), and end your report with the message you used or propose.

## Verification

- Test what you changed with the project's own tools before saying it's done.
- Report what you verified, what you couldn't (and why), and anything I need to do.
