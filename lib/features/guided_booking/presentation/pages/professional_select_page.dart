import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/presentation/widgets/booking/booking.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_professional.dart';
import 'package:m2health/features/guided_booking/guided_booking_routes.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_cubit.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_state.dart';
import 'package:m2health/features/guided_booking/presentation/pages/professional_detail_page.dart';
import 'package:m2health/features/guided_booking/presentation/widgets/address_picker_sheet.dart';
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
  bool _pickerShown = false;
  String _query = '';

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
    _search.dispose();
    super.dispose();
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

  List<BookingProfessional> _visible(GuidedBookingState state) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return state.professionals;
    return state.professionals
        .where((p) =>
            p.name.toLowerCase().contains(query) ||
            (p.jobTitle?.toLowerCase().contains(query) ?? false))
        .toList();
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
                address: state.selectedAddress,
                isLoading: state.addressStatus == BookingLoadStatus.loading,
                onTap: () => _openPicker(state),
              ),
              if (state.professionalStatus == BookingLoadStatus.ready &&
                  state.professionals.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: TextField(
                    controller: _search,
                    onChanged: (value) => setState(() => _query = value),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, size: 20),
                      hintText: t.professional.search_hint,
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Const.placeholderTextColor,
                      ),
                      isDense: true,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 12),
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
        final visible = _visible(state);
        if (visible.isEmpty) {
          return BookingEmptyState(
            message: t.empty,
            icon: Icons.person_search_outlined,
          );
        }
        return ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            BookingStepHeader(title: t.title),
            for (final professional in visible)
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
