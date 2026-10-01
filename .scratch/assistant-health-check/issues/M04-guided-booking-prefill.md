# Let guided booking start with issues and remarks already filled in

Status: ready-for-agent
Priority: P0
Size: S
Depends on: none (do this before M03, which uses the new fields)

A service suggestion from the assistant opens guided booking with a `BookingPrefill` (contract A5). Today `GuidedBookingArgs` (`lib/features/guided_booking/guided_booking_routes.dart`) carries only `category` and `subCategory`.

## What to build

1. `GuidedBookingArgs`: add `final List<String> issueCodes;` (default `const []`) and `final String? remarks;` (default `null`). Keep the constructor `const`.
2. `lib/features/guided_booking/injection.dart`: the `registerFactoryParam<GuidedBookingCubit, GuidedBookingArgs, void>` factory passes `initialIssueCodes: args.issueCodes` and `initialRemarks: args.remarks`.
3. `GuidedBookingCubit` (`presentation/bloc/guided_booking_cubit.dart`):
   - Constructor gains `List<String> initialIssueCodes = const []` and `String? initialRemarks`.
   - The initial draft becomes `GuidedBookingDraft(category: category, subCategory: subCategory, issueCodes: initialIssueCodes, remarks: initialRemarks ?? '')`. Respect `GuidedBookingDraft.remarksLimit` (300): cut longer remarks with the draft's existing `withRemarks` rule, or by substring if building directly.
   - A private `bool _hasPrefill` = `initialIssueCodes.isNotEmpty || (initialRemarks?.isNotEmpty ?? false)`.
   - `loadCatalogue()`: when `_hasPrefill`, do **not** call `restoreDraft()` (a saved draft must not overwrite the assistant's prefill).
   - In the `ready` branch of `loadCatalogue()`, after the sub-category auto-selection, keep only the draft's `issueCodes` that appear in `catalogue.issuesFor(<the draft's subCategory>)`. Use the existing draft methods to rebuild the list (read `guided_booking_draft.dart`; add a small `withIssueCodes(List<String>)` method there if no existing method fits, following `_copyWith`).
4. `presentation/pages/guided_booking_entry_page.dart`: skip the sub-service page when a sub-category is already set: `needsSubService = (state.catalogue?.needsSubServiceStep ?? false) && state.draft.subCategory == null`.

Nothing else in guided booking changes. Home tiles pass no prefill and no sub-category, so they behave exactly as before.

## Tests (`test/features/guided_booking/guided_booking_prefill_test.dart`)

Build the cubit with fake use cases (look at `test/features/guided_booking/guided_booking_cubit_draft_test.dart` for how the existing tests build it). At least:

- With prefill `category: 'pharmacy', subCategory: 'medication_support', issueCodes: ['med_side_effects', 'not_a_code'], remarks: 'x'`: after `loadCatalogue()` the draft has `['med_side_effects']`, remarks `'x'`, and `loadDraft` was never called.
- Without prefill: `loadDraft` is called (unchanged behaviour).
- Remarks longer than 300 characters are cut to 300.

## Acceptance criteria

- [ ] `fvm flutter analyze` shows no new issues; tests pass.
- [ ] Commit: `feat(guided-booking): accept issues and remarks on entry`
