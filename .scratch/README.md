# Issues

This is the issue tracker. It is markdown files, in git. There is no GitHub tracker for this repository.

```
.scratch/
└── <feature-name>/
    ├── spec.md
    └── issues/
        ├── 01-<short-name>.md
        └── 02-<short-name>.md
```

One directory per feature. One file per ticket.

Each issue has a `Status` line near the top, gives its evidence as a file and line rather than a description, lists what has to become true before it is done, and collects comments at the bottom as the conversation goes on.

The full conventions are in [docs/agents/issue-tracker.md](../docs/agents/issue-tracker.md), and the status labels are in [docs/agents/triage-labels.md](../docs/agents/triage-labels.md).

Backend work lives in the backend repository's own `.scratch`, not here.
