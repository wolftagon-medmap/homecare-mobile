import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/core/presentation/widgets/booking/booking.dart';
import 'package:m2health/features/guided_booking/guided_booking_routes.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_cubit.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_state.dart';
import 'package:m2health/features/guided_booking/presentation/widgets/address_picker_sheet.dart';
import 'package:m2health/features/guided_booking/presentation/widgets/booking_location_bar.dart';
import 'package:m2health/features/guided_booking/presentation/widgets/professional_card.dart';
import 'package:m2health/i18n/translations.g.dart';

class ProfessionalSelectPage extends StatefulWidget {
  const ProfessionalSelectPage({super.key, required this.args});

  final GuidedBookingStepArgs args;

  @override
  State<ProfessionalSelectPage> createState() => _ProfessionalSelectPageState();
}

class _ProfessionalSelectPageState extends State<ProfessionalSelectPage> {
  bool _pickerShown = false;

  @override
  void initState() {
    super.initState();
    final cubit = widget.args.cubit;
    if (cubit.state.addressStatus == BookingLoadStatus.initial) {
      cubit.loadAddresses();
    } else if (cubit.state.professionalStatus == BookingLoadStatus.initial) {
      cubit.loadProfessionals();
    }
  }

  Future<void> _openPicker(GuidedBookingState state) async {
    final cubit = widget.args.cubit;
    final picked = await AddressPickerSheet.show(
      context,
      addresses: state.addresses,
      selectedId: state.draft.addressId,
    );
    if (picked != null) cubit.selectAddress(picked);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.guidedBooking;
    final cubit = context.read<GuidedBookingCubit>();

    return BlocConsumer<GuidedBookingCubit, GuidedBookingState>(
      listenWhen: (previous, current) =>
          previous.addressStatus != current.addressStatus,
      listener: (context, state) {
        final noAddress = state.addressStatus == BookingLoadStatus.ready &&
            state.addresses.isEmpty;
        if (noAddress && !_pickerShown) {
          _pickerShown = true;
          _openPicker(state);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              t.professional.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          body: Column(
            children: [
              BookingLocationBar(
                address: state.selectedAddress,
                isLoading: state.addressStatus == BookingLoadStatus.loading,
                onTap: () => _openPicker(state),
              ),
              Expanded(child: _body(context, state, cubit)),
            ],
          ),
          bottomNavigationBar: StickyBottomCta(
            label: t.cta.kContinue,
            onPressed: state.draft.hasProfessional
                ? () {
                    if (widget.args.returnToReview) {
                      context.pop();
                    } else {
                      context.push(
                        GuidedBookingRoutes.dateTime,
                        extra: GuidedBookingStepArgs(cubit),
                      );
                    }
                  }
                : null,
          ),
        );
      },
    );
  }

  Widget _body(
    BuildContext context,
    GuidedBookingState state,
    GuidedBookingCubit cubit,
  ) {
    final t = context.t.guidedBooking.professional;

    switch (state.professionalStatus) {
      case BookingLoadStatus.initial:
      case BookingLoadStatus.loading:
        return BookingLoadingState(message: t.loading);
      case BookingLoadStatus.failure:
        return BookingErrorState(
          message: state.errorMessage ?? t.error,
          onRetry: cubit.loadProfessionals,
        );
      case BookingLoadStatus.ready:
        if (state.professionals.isEmpty) {
          return BookingEmptyState(
            message: t.empty,
            icon: Icons.person_search_outlined,
          );
        }
        return ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            BookingStepHeader(
              title: t.title,
              subtitle: t.subtitle,
              step: 3,
            ),
            for (final professional in state.professionals)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: ProfessionalCard(
                  professional: professional,
                  category: state.pricingCategory,
                  selected: professional.id == state.draft.professionalId,
                  onTap: () => cubit.selectProfessional(professional.id),
                ),
              ),
          ],
        );
    }
  }
}
