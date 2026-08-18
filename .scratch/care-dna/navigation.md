# Professional navigation

## The problem

The app shipped one navigation for both roles: Home, Appointments, Store, Favourites,
Profile. For a professional three of those five are dead. Home is a service catalogue
offering to book a nurse — shown to a nurse. Store sells products they do not buy.
Favourites holds favourited professionals, which a professional has no reason to keep.

Their actual work — the offer inbox and the visit list — sat in tab two of five, behind
a launch screen built for somebody else. That is why the app did not feel like theirs.

## What it is now

Patients are untouched: same five destinations, same order, same icons.

Professionals get four:

| Tab | Branch | Screen |
| --- | --- | --- |
| Today | 0 | `ProfessionalTodayPage` (new) |
| Visits | 1 | `ProviderAppointmentPage` (existing, unchanged) |
| Availability | 5 | `WorkingSchedulePage` (existing, promoted out of Profile) |
| Profile | 4 | Professional 360 |

Branches 2 and 3 still exist and still serve patients; professionals simply never
navigate to them. Availability is a new sixth branch at `/availability` rather than a
repurposing of the store branch, so the URL keeps telling the truth.

The floating bar now renders from a role-driven destination list and every item carries a
text label. Five unlabelled icons was guesswork — `add_shopping_cart` for a medical store
being the clearest example.

## Today

Answers the three questions a professional opens the app with.

**Is anything waiting on me?** Pending offers from `ProviderInboxCubit`, the same
`/v2/provider/inbox` feed the Visits tab uses. Shown only when non-empty, with a count and
a per-offer countdown, because offers expire. Hidden entirely when there is nothing
waiting rather than showing a cheerful empty card.

**What is next?** Today's accepted visits, each with time, patient, service and address.
When today is empty it says when the next one is; when there is nothing upcoming at all it
points at Availability, because an empty schedule is the usual reason a professional stops
receiving offers.

**How has this week gone?** Completed visits and their booked value.

## On the week summary

The app has no earnings feature — no screen, no endpoint, nothing in the backend. For
someone paid per visit that is a real gap, and this strip is a deliberate down payment on
it rather than a solution. It sums `order.total` across completed appointments, so it is
what was booked, not what has been paid out. Anything more honest needs a payouts concept
that does not exist yet.

## Role resolution

`UserRoleCubit` already existed, is provided at the root of the app and loads the stored
role at startup, so the navigation bar reads it synchronously. No new session service was
needed. `UnifiedHomePage` follows the same pattern as the existing `UnifiedAppointmentPage`
and `UnifiedProfilePage`.

One consequence worth knowing: the role is loaded asynchronously at startup, so for the
first frames after a cold launch `state.role` is null and the bar renders the patient set.
It corrects itself as soon as the cubit emits. If that flicker is visible on a real device,
the fix is to resolve the role before the first frame rather than to special-case the bar.

## Not done

Admins get the patient navigation, which is wrong in the same way but was out of scope.

The Today page has no profile or verification nudge. It was in the design and I left it
out: the profile page already carries both the verification card and Care DNA
completeness, and repeating them on the home screen is how a home screen turns back into a
dashboard of notices.
