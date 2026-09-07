import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/presentation/widgets/booking/booking.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_professional.dart';
import 'package:m2health/features/guided_booking/guided_booking_routes.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_cubit.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_state.dart';
import 'package:m2health/features/guided_booking/presentation/pages/professional_detail_page.dart';
import 'package:m2health/core/location/visit_location_picker.dart';
import 'package:m2health/features/guided_booking/presentation/widgets/booking_flow_progress.dart';
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
  final TextEditingController _search = TextEditingController();
  Timer? _debounce;
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

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 350),
      () => widget.args.cubit.loadProfessionals(name: query),
    );
  }

  Future<void> _openPicker(GuidedBookingState state) async {
    final picked = await showVisitLocationPicker(
      context,
      addresses: state.addresses,
      selected: state.visitLocation,
    );
    if (picked != null) widget.args.cubit.selectVisitLocation(picked);
  }

  void _openProfile(BookingProfessional professional) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => GuidedProfessionalDetailPage(
          args: widget.args,
          professional: professional,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.guidedBooking;
    final cubit = context.read<GuidedBookingCubit>();

    return BlocConsumer<GuidedBookingCubit, GuidedBookingState>(
      listenWhen: (previous, current) =>
          previous.addressStatus != current.addressStatus,
      listener: (context, state) {
        final needsLocation = state.addressStatus == BookingLoadStatus.ready &&
            state.visitLocation == null;
        if (needsLocation && !_pickerShown) {
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
              state.catalogue?.title ?? t.namespace_title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          body: Column(
            children: [
              BookingFlowProgress(
                state: state,
                step: GuidedBookingStep.professional,
              ),
              BookingLocationBar(
                location: state.visitLocation,
                isLoading: state.addressStatus == BookingLoadStatus.loading,
                onTap: () => _openPicker(state),
              ),
              if (state.professionalStatus != BookingLoadStatus.failure)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: TextField(
                    controller: _search,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, size: 20),
                      hintText: t.professional.search_hint,
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Const.placeholderTextColor,
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Const.borderSubtle,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Const.borderSubtle,
                        ),
                      ),
                    ),
                  ),
                ),
              Expanded(child: _body(context, state, cubit)),
            ],
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
            BookingStepHeader(title: t.title),
            for (final professional in state.professionals)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: ProfessionalCard(
                  professional: professional,
                  category: state.pricingCategory,
                  onOpenProfile: () => _openProfile(professional),
                ),
              ),
          ],
        );
    }
  }
}
