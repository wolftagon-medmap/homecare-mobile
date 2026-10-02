# Questions render from the contract's layouts

Status: done
Priority: P0
Size: M
Depends on: M01

The deleted feature drew every question by its type only (radio list, checkbox list, chips, text box). The user chose templates driven by layout hints from the API, so that a designer can pick how each question looks without an app release (spec, decision 7).

## Outcome

The section page looks as described in the spec under "Section page", for every question in contract C6, and for any future question that uses the contract.

## Acceptance criteria

- [x] `rows`, `chips`, and `grid` render as the spec describes, for both single and multi choice. Grid tiles show the option's icon from a fixed set in the app (`walk`, `gym`, `run`, `swim`, `bike`, mapped to Material icons); a tile without a known icon shows its label only.
- [x] Exclusive options follow the others after a divider in `rows`; in `chips` and `grid` they come last.
- [x] The own-answer control ("Add another condition", "Other") opens an inline text field; a saved entry appears as a selected option that can be removed. Empty or whitespace entries are ignored; more than 100 characters cannot be typed.
- [x] A follow-up appears and disappears as its controlling answer changes, without the page jumping.
- [x] "Last updated 28 Sep 2026" under the section title when `updated_at` is set, in the device locale's date format; nothing when it is null.
- [x] Loading, load error with Retry, and save error states as the spec describes.
- [x] Contrast, tap target, screen reader, narrow screen, and text size criteria from the spec's quality bar hold. Contrast pairs checked with a contrast tool and recorded in the issue comments.
- [x] Widget tests: each layout renders its options and reports taps; exclusive and own-answer behaviour; follow-up visibility.
- [x] Checks as in M01.

## Comments

2026-10-02: Done. Contrast pairs checked with the antislop contrast tool: selected text `#0B5F66` on `#E6F8F9` 6.74:1; white on `#0B7A82` (Save) 5.1:1; `#0B7A82` text on white 5.1:1; muted `#6B7489` on white 4.68:1; disabled Save `#414C6B` on `#E0E0E0` 6.44:1. The shared booking error widget was not reused because its body text (`#868686`) is 3.6:1. Widget tests cover each layout, the exclusive divider, own answers, follow-up visibility, last updated, saving, and a 320 dp screen at 130% text size. Dates follow the app language (slang locale).
