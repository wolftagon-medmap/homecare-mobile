# Domain language

This file defines the words used in this app. It does not explain how the app works, which is the job of [AGENTS.md](AGENTS.md).

Two vocabularies meet here, and they should not be mixed. The **domain** language is shared with the backend. A care task means the same thing on both sides of the wire. The **app** language describes how this Flutter application is built, and means nothing to the backend. Naming a widget after a database table, or an entity after a cubit, is how the two start to blur.

## The shared domain language

These words are defined once, in the **backend repository**, in the file `CONTEXT.md` at its root. That is the source of truth. What follows is a short reminder so that you can read this app without switching repositories. If the two ever disagree, the backend is right. Do not grow this list into a copy of theirs.

**Patient.** The person receiving care. Not necessarily the account holder, because a user can book for a family member. A patient is a profile, not a login.

**Professional.** The person delivering care. Nurse is the most common case, not a synonym for it.

**Care task.** The job being coordinated. It exists before there is any appointment.

**Appointment.** A real visit: this professional, at this time, at this address.

**Offer.** A time-limited request to one professional asking whether they will take a job. This is what the professional's Pending tab shows.

**Intake.** The chat conversation that turns what the patient says into a structured request.

## The app language

**Feature.** A self-contained slice of the app under `lib/features/<name>`, split into `domain`, `data`, and `presentation`. Features do not reach into each other. They share through `lib/core`.

**Entity.** A domain object. It belongs to the `domain` layer and knows nothing about JSON.

**Model.** A data transfer object in the `data` layer. It knows how to read itself from JSON. A model must never reach the presentation layer. Map it to an entity at the repository boundary.

**Use case.** One domain action, living in `domain/usecases`. This is what a cubit calls.

**Repository.** Declared as an interface in `domain`, implemented in `data`. This is what keeps the domain layer from depending on anything.

**Data source.** Where a repository implementation actually gets its bytes, either over HTTP or from a local cache.

**Cubit.** The thing that holds state and exposes it to the UI. Our default. A full BLoC is only for genuinely complex event flows.

**Failure.** A modeled error, such as a server failure or a cache failure. Repository methods return `Either<Failure, T>`, and the cubit folds it. Errors are values here, not exceptions.

**Server-driven block.** The conversational booking flow is rendered from blocks the server describes. The app is deliberately not clever about them. Do not hardcode intake screens.

## Words we avoid

**"v1" and "v2."** Do not use these. They look like version numbers and they are not. The backend's `/v1` routes are the whole platform, and `/v2` is the group of routes added for conversational booking. Nothing is deprecated. When you mean the workflow, say self-service or conversational.

**"Booking" on its own.** It is ambiguous. Say care task when you mean the job, appointment when you mean the confirmed visit, or name the workflow.

**"Slot" on its own.** A time slot is a bookable window in a professional's schedule. An intake slot is one field of the form the assistant is filling in. Always say which one you mean.

**"Screen."** We say page, matching `presentation/pages` and `go_router`.

**"Model" for a domain object.** A model is a data transfer object in the `data` layer. The domain object is an entity.

**"User."** Prefer patient or professional. The app serves both, and the account holder is not always the patient.
