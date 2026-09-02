import 'package:provider/single_child_widget.dart';

/// App-wide blocs for the chatbot. Owned by A4.
///
/// Spread into the root `MultiBlocProvider` in `main.dart` — do not open that
/// file. Screen-scoped blocs belong on their route, not here.
///
/// `chatbot_routes.dart` and `injection.dart` already existed and are already
/// registered; this is the only seam the chatbot was missing.
class ChatbotProviders {
  static List<SingleChildWidget> get providers => [];
}
