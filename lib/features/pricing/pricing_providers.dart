import 'package:provider/single_child_widget.dart';

/// App-wide blocs for pricing and estimates. Owned by A3.
///
/// Spread into the root `MultiBlocProvider` in `main.dart` — do not open that
/// file. Screen-scoped blocs belong on their route, not here.
class PricingProviders {
  static List<SingleChildWidget> get providers => [];
}
