import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:m2health/core/services/appointment_service.dart';
import 'package:m2health/features/appointment/data/models/inbox_item.dart';
import 'package:m2health/features/appointment/data/provider_inbox_service.dart';

part 'provider_inbox_state.dart';

/// Drives the provider Pending tab (ADR-0006): loads the unified inbox and routes
/// accept/decline to the right endpoint by the action's `(entity, kind)` — v2
/// offers via [ProviderInboxService], v1 appointments via [AppointmentService].
class ProviderInboxCubit extends Cubit<ProviderInboxState> {
  final ProviderInboxService _inbox;
  final AppointmentService _appointments;

  ProviderInboxCubit(Dio dio)
      : _inbox = ProviderInboxService(dio),
        _appointments = AppointmentService(dio),
        super(ProviderInboxInitial());

  Future<void> fetchInbox() async {
    try {
      emit(ProviderInboxLoading());
      final items = await _inbox.fetchInbox();
      emit(ProviderInboxLoaded(items));
    } catch (e, stackTrace) {
      log('Error fetching provider inbox: $e',
          name: 'ProviderInboxCubit', error: e, stackTrace: stackTrace);
      emit(ProviderInboxError('Failed to load pending requests'));
    }
  }

  Future<void> respond(
    InboxItem item,
    InboxAction action, {
    String? cancellationReason,
    String? otherReason,
  }) async {
    try {
      if (action.entity == 'offer') {
        if (action.kind == 'accept') {
          await _inbox.acceptOffer(action.entityId);
        } else {
          await _inbox.declineOffer(action.entityId);
        }
      } else {
        if (action.kind == 'accept') {
          await _appointments.acceptProviderAppointment(action.entityId);
        } else {
          await _appointments.rejectProviderAppointment(
            action.entityId,
            cancellationReason: cancellationReason ?? 'declined',
            otherReason: otherReason,
          );
        }
      }
      emit(ProviderInboxActionSucceed(
        action.kind == 'accept' ? 'Request accepted' : 'Request declined',
      ));
      await fetchInbox();
    } catch (e, stackTrace) {
      log('Error responding to inbox item: $e',
          name: 'ProviderInboxCubit', error: e, stackTrace: stackTrace);
      emit(ProviderInboxError('Action failed. Please try again.'));
    }
  }
}
