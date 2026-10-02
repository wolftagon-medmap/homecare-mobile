# Questions render from the contract's layouts

Status: ready-for-agent
Priority: P0
Size: M
Depends on: M01

The deleted feature drew every question by its type only (radio list, checkbox list, chips, text box). The user chose templates driven by layout hints from the API, so that a designer can pick how each question looks without an app release (spec, decision 7).

## Outcome

The section page looks as described in the spec under "Section page", for every question in contract C6, and for any future question that uses the contract.

## Acceptance criteria

- [ ] `rows`, `chips`, and `grid` render as the spec describes, for both single and multi choice. Grid tiles show the option's icon from a fixed set in the app (`walk`, `gym`, `run`, `swim`, `bike`, mapped to Material icons); a tile without a known icon shows its label only.
- [ ] Exclusive options follow the others after a divider in `rows`; in `chips` and `grid` they come last.
- [ ] The own-answer control ("Add another condition", "Other") opens an inline text field; a saved entry appears as a selected option that can be removed. Empty or whitespace entries are ignored; more than 100 characters cannot be typed.
- [ ] A follow-up appears and disappears as its controlling answer changes, without the page jumping.
- [ ] "Last updated 28 Sep 2026" under the section title when `updated_at` is set, in the device locale's date format; nothing when it is null.
- [ ] Loading, load error with Retry, and save error states as the spec describes.
- [ ] Contrast, tap target, screen reader, narrow screen, and text size criteria from the spec's quality bar hold. Contrast pairs checked with a contrast tool and recorded in the issue comments.
- [ ] Widget tests: each layout renders its options and reports taps; exclusive and own-answer behaviour; follow-up visibility.
- [ ] Checks as in M01.

## Comments
