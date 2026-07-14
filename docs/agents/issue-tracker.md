# Issue tracker

Issues and specs live as markdown files under `.scratch`, committed to git. There is no GitHub issue tracker for this repository, and nothing to sign in to. The files are the tracker.

The backend repository has its own `.scratch`. Work that spans both gets an issue in each, and the two reference one another. Do not file backend work here.

## Layout

```
.scratch/
└── <feature-name>/
    ├── spec.md
    └── issues/
        ├── 01-<short-name>.md
        ├── 02-<short-name>.md
        └── ...
```

One directory per feature. The spec for that feature is `spec.md`. Each ticket is its own file under `issues`, numbered from 01.

Never put several tickets in one file. One file per ticket is what lets someone claim a ticket, work on it, and close it without touching anyone else's.

## What an issue file looks like

```markdown
# Short title, written as an instruction

Status: needs-triage
Size: M
Depends on: 03-some-other-issue

Why this matters, and the evidence for it. Cite the file and line rather than
describing the problem in the abstract.

## Acceptance criteria

- [ ] The thing that has to become true.

## Comments

Added underneath, in order, as the conversation happens.
```

The `Status` line goes near the top and uses one of the labels in [triage-labels.md](triage-labels.md): `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. Add `in-progress` or `done` if you need them.

Comments are appended at the bottom. Do not rewrite the body above them, because that is the record of what was originally asked.

## What the skills mean

When a skill says to publish something to the issue tracker, create a file under `.scratch/<feature-name>/`, making the directory if it does not exist yet.

When a skill says to fetch a ticket, read the file at the path given.

## These files are committed

`.scratch` is tracked in git, on purpose. Issues sit next to the code they describe, they survive a fresh clone, and they show up in a pull request.

An issue file is a real artifact that someone else will read, possibly months later. Write it for a person who was not in the conversation that produced it.
