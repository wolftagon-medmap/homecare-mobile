import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/presentation/widgets/booking/booking.dart';
import 'package:m2health/features/etc/pricing/domain/entities/provider_service_rate.dart';
import 'package:m2health/features/etc/pricing/presentation/bloc/provider_rates_cubit.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/service_locator.dart';

/// A professional's rate card. Every row starts at the standard price and can
/// only move upward — there is no ceiling.
class ProviderServiceRatesPage extends StatelessWidget {
  const ProviderServiceRatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProviderRatesCubit>()..load(),
      child: const _ProviderServiceRatesView(),
    );
  }
}

class _ProviderServiceRatesView extends StatelessWidget {
  const _ProviderServiceRatesView();

  @override
  Widget build(BuildContext context) {
    final t = context.t.pricing;

    return BlocConsumer<ProviderRatesCubit, ProviderRatesState>(
      listenWhen: (previous, current) =>
          current.justSaved ||
          (current.error != null && previous.error == null),
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);
        if (state.justSaved) {
          messenger.showSnackBar(SnackBar(
            content: Text(t.rates_saved),
            backgroundColor: Colors.green,
          ));
        } else if (state.error != null) {
          messenger.showSnackBar(SnackBar(
            content: Text(state.error!),
            backgroundColor: Colors.red,
          ));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              t.rates_title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          body: _body(context, state),
          bottomNavigationBar: state.rates.isEmpty
              ? null
              : StickyBottomCta(
                  label: t.save,
                  isLoading: state.status == ProviderRatesStatus.saving,
                  onPressed: state.canSave
                      ? () => context.read<ProviderRatesCubit>().save()
                      : null,
                ),
        );
      },
    );
  }

  Widget _body(BuildContext context, ProviderRatesState state) {
    final t = context.t.pricing;

    return switch (state.status) {
      ProviderRatesStatus.initial ||
      ProviderRatesStatus.loading =>
        const BookingLoadingState(),
      ProviderRatesStatus.failure => BookingErrorState(
          message: state.error ?? t.rates_error,
          onRetry: () => context.read<ProviderRatesCubit>().load(),
        ),
      _ when state.rates.isEmpty => BookingEmptyState(
          message: t.rates_empty,
          icon: Icons.price_change_outlined,
        ),
      _ => ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: state.rates.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  t.rates_subtitle,
                  style: const TextStyle(fontSize: 12.5, color: Colors.black54),
                ),
              );
            }
            return _RateRow(rate: state.rates[index - 1], state: state);
          },
        ),
    };
  }
}

class _RateRow extends StatelessWidget {
  const _RateRow({required this.rate, required this.state});

  final ProviderServiceRate rate;
  final ProviderRatesState state;

  @override
  Widget build(BuildContext context) {
    final t = context.t.pricing;
    final serviceId = rate.service.id;
    final draft = state.drafts[serviceId];
    final valid = state.isValid(serviceId);
    final floor = _money(rate.service.floorPrice);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE6E9EE)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rate.service.name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Text(
            t.standard_price(price: floor),
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 10),
          TextFormField(
            key: ValueKey('rate-$serviceId'),
            initialValue: draft ??
                (rate.usesFloor ? '' : _money(rate.basePrice!, symbol: false)),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            onChanged: (value) =>
                context.read<ProviderRatesCubit>().edit(serviceId, value),
            decoration: InputDecoration(
              isDense: true,
              labelText: t.your_price,
              hintText: _money(rate.service.floorPrice, symbol: false),
              prefixText: r'$ ',
              helperText:
                  rate.usesFloor && draft == null ? t.charging_standard : null,
              errorText: valid
                  ? null
                  : (double.tryParse((draft ?? '').trim()) == null
                      ? t.not_a_number
                      : t.at_least(price: floor)),
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Const.tosca),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _money(double value, {bool symbol = true}) {
    final text =
        value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(2);
    return symbol ? '\$$text' : text;
  }
}
