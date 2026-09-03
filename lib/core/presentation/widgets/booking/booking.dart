/// Shared chrome for the guided booking flow, messaging and pricing screens.
///
/// Owned by the orchestrator — consume it, don't edit it. If one of these needs
/// to change, ask, so the change lands once for everyone. The one exception: an
/// agent may delete what its own change orphans here, tests included.
///
/// ```dart
/// import 'package:m2health/core/presentation/widgets/booking/booking.dart';
/// ```
library;

export 'booking_async_states.dart';
export 'booking_step_header.dart';
export 'multi_select_list_tile.dart';
export 'price_pill.dart';
export 'selection_chip.dart';
export 'status_pill.dart';
export 'sticky_bottom_cta.dart';
