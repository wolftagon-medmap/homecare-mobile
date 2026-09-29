import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:m2health/features/appointment/data/models/inbox_item.dart';
import 'package:m2health/features/appointment/data/provider_inbox_service.dart';

part 'provider_inbox_state.dart';

/// Drives the provider Pending tab: loads the care-task offer inbox and routes
/// accept/decline through [ProviderInboxService].
class ProviderInboxCubit extends Cubit<ProviderInboxState> {
  final ProviderInboxService _inbox;

  ProviderInboxCubit(Dio dio)
      : _inbox = ProviderInboxService(dio),
        super(ProviderInboxInitial());

  Future<void> fetchInbox() async {
    try {
      emit(ProviderInboxLoading());
      emit(ProviderInboxLoaded(await _inbox.fetchInbox()));
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
      if (action.kind == 'accept') {
        await _inbox.acceptOffer(item.careTaskId);
      } else {
        await _inbox.declineOffer(item.careTaskId);
      }
      emit(ProviderInboxActionSucceed(_label(action.kind)));
      await fetchInbox();
    } catch (e, stackTrace) {
      log('Error responding to inbox item: $e',
          name: 'ProviderInboxCubit', error: e, stackTrace: stackTrace);
      emit(ProviderInboxError('Action failed. Please try again.'));
    }
  }

  static String _label(String kind) => switch (kind) {
        'accept' => 'Request accepted',
        'propose_time' => 'Suggestion sent',
        _ => 'Request declined',
      };
}
