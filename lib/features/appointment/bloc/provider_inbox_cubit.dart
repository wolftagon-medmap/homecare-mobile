import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:m2health/core/config/feature_flags.dart';
import 'package:m2health/core/services/appointment_service.dart';
import 'package:m2health/features/appointment/data/fixtures/inbox_demo_fixture.dart';
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

  /// True while the counter-propose demo is on fixtures. Dead the moment the
  /// flag flips: no demo row is merged and a failure is an error again.
  bool get _demo => !AppFlags.remote(Feature.timeProposal);

  List<InboxItem> get _demoItems =>
      kProviderInboxDemoFixture().map(InboxItem.fromJson).toList();

  Future<void> fetchInbox() async {
    try {
      emit(ProviderInboxLoading());
      final items = await _inbox.fetchInbox();
      emit(ProviderInboxLoaded(_demo ? [..._demoItems, ...items] : items));
    } catch (e, stackTrace) {
      log('Error fetching provider inbox: $e',
          name: 'ProviderInboxCubit', error: e, stackTrace: stackTrace);
      if (_demo) {
        emit(ProviderInboxLoaded(_demoItems));
        return;
      }
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
      if (_demo) {
        // Nothing to call: the scripted offer is a fixture. The conversation is
        // where the counter-proposal actually happens in the demo.
        emit(ProviderInboxActionSucceed(_demoLabel(action.kind)));
        await fetchInbox();
        return;
      }
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
      emit(ProviderInboxActionSucceed(_demoLabel(action.kind)));
      await fetchInbox();
    } catch (e, stackTrace) {
      log('Error responding to inbox item: $e',
          name: 'ProviderInboxCubit', error: e, stackTrace: stackTrace);
      emit(ProviderInboxError('Action failed. Please try again.'));
    }
  }

  static String _demoLabel(String kind) => switch (kind) {
        'accept' => 'Request accepted',
        'propose_time' => 'Suggestion sent',
        _ => 'Request declined',
      };
}
