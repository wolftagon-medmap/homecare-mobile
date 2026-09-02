import 'package:provider/single_child_widget.dart';

/// App-wide blocs for patient / professional messaging. Owned by A2.
///
/// Spread into the root `MultiBlocProvider` in `main.dart` — do not open that
/// file. Screen-scoped blocs belong on their route, not here.
class MessagingProviders {
  static List<SingleChildWidget> get providers => [];
}
