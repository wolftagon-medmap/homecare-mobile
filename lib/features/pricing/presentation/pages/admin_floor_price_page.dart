import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/presentation/widgets/booking/booking.dart';
import 'package:m2health/features/pricing/domain/entities/service_price.dart';
import 'package:m2health/features/pricing/presentation/bloc/floor_price_cubit.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/service_locator.dart';

/// The admin's standardised floor per service. Raising one lifts every
/// professional who was charging below it.
class AdminFloorPricePage extends StatelessWidget {
  const AdminFloorPricePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FloorPriceCubit>()..load(),
      child: const _AdminFloorPriceView(),
    );
  }
}

class _AdminFloorPriceView extends StatelessWidget {
  const _AdminFloorPriceView();

  @override
  Widget build(BuildContext context) {
    final t = context.t.pricing;

    return BlocConsumer<FloorPriceCubit, FloorPriceState>(
      listenWhen: (previous, current) =>
          previous.lastLiftedRates != current.lastLiftedRates &&
          current.lastLiftedRates != null,
      listener: (context, state) {
        final lifted = state.lastLiftedRates ?? 0;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(lifted == 0
              ? t.floor_saved
              : '${t.floor_saved} ${t.floor_lifted(count: lifted)}'),
          backgroundColor: Colors.green,
        ));
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              t.floor_title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          body: _body(context, state),
        );
      },
    );
  }

  Widget _body(BuildContext context, FloorPriceState state) {
    final t = context.t.pricing;

    if (state.status == FloorPriceStatus.initial ||
        state.status == FloorPriceStatus.loading) {
      return const BookingLoadingState();
    }
    if (state.status == FloorPriceStatus.failure) {
      return BookingErrorState(
        message: state.error ?? t.floor_error,
        onRetry: () => context.read<FloorPriceCubit>().load(),
      );
    }

    final grouped = state.byCategory;
    final categories = grouped.keys.toList()..sort();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        Text(
          t.floor_subtitle,
          style: const TextStyle(fontSize: 12.5, color: Colors.black54),
        ),
        const SizedBox(height: 12),
        for (final category in categories) ...[
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 6),
            child: Text(
              _categoryLabel(category),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Const.tosca,
              ),
            ),
          ),
          for (final service in grouped[category]!) _FloorRow(service: service),
        ],
      ],
    );
  }

  static String _categoryLabel(String category) => category
      .split('_')
      .map((word) =>
          word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');
}

class _FloorRow extends StatelessWidget {
  const _FloorRow({required this.service});

  final ServicePrice service;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(service.name, style: const TextStyle(fontSize: 14)),
      subtitle: Text(
        service.code,
        style: const TextStyle(fontSize: 11, color: Colors.black45),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PricePill(
            amount: service.floorPrice,
            variant: PricePillVariant.exact,
            dense: true,
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 18),
            onPressed: () => _edit(context),
          ),
        ],
      ),
    );
  }

  Future<void> _edit(BuildContext context) async {
    final cubit = context.read<FloorPriceCubit>();
    final price = await showDialog<double>(
      context: context,
      builder: (_) => _FloorPriceDialog(service: service),
    );
    if (price != null) await cubit.setFloor(service.id, price);
  }
}

class _FloorPriceDialog extends StatefulWidget {
  const _FloorPriceDialog({required this.service});

  final ServicePrice service;

  @override
  State<_FloorPriceDialog> createState() => _FloorPriceDialogState();
}

class _FloorPriceDialogState extends State<_FloorPriceDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: _plain(widget.service.floorPrice),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.pricing;
    final parsed = double.tryParse(_controller.text.trim());

    return AlertDialog(
      title: Text(widget.service.name),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          labelText: t.floor_new_price,
          prefixText: r'$ ',
          errorText: parsed == null ? t.not_a_number : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.t.global.cancel),
        ),
        TextButton(
          onPressed:
              parsed == null ? null : () => Navigator.of(context).pop(parsed),
          child: Text(t.save),
        ),
      ],
    );
  }

  static String _plain(double value) =>
      value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(2);
}
