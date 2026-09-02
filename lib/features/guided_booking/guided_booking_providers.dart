import 'package:provider/single_child_widget.dart';

/// App-wide blocs for the guided booking flow. Owned by A1.
///
/// Spread into the root `MultiBlocProvider` in `main.dart` — do not open that
/// file. Screen-scoped blocs belong on their route, not here.
class GuidedBookingProviders {
  static List<SingleChildWidget> get providers => [];
}
