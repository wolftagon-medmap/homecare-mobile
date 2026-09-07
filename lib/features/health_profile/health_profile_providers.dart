import 'package:provider/single_child_widget.dart';

/// App-wide blocs for the health profile sections. Owned by A5.
///
/// Spread into the root `MultiBlocProvider` in `main.dart` — do not open that
/// file. Screen-scoped blocs belong on their route, not here.
class HealthProfileProviders {
  static List<SingleChildWidget> get providers => [];
}
