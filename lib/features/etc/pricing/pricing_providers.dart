import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/etc/pricing/presentation/bloc/price_table_cubit.dart';
import 'package:m2health/service_locator.dart';
import 'package:provider/single_child_widget.dart';

/// App-wide blocs for pricing and estimates. Owned by A3.
///
/// Spread into the root `MultiBlocProvider` in `main.dart` — do not open that
/// file. Screen-scoped blocs belong on their route, not here.
class PricingProviders {
  static List<SingleChildWidget> get providers => [
        // App-wide because a price pill can appear on any service card, and a
        // widget cannot await. Loads from fixtures, so this costs no network.
        BlocProvider<PriceTableCubit>(
          create: (_) => sl<PriceTableCubit>()..load(),
        ),
      ];
}
