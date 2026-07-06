part of 'provider_inbox_cubit.dart';

@immutable
abstract class ProviderInboxState {}

class ProviderInboxInitial extends ProviderInboxState {}

class ProviderInboxLoading extends ProviderInboxState {}

class ProviderInboxLoaded extends ProviderInboxState {
  final List<InboxItem> items;
  ProviderInboxLoaded(this.items);
}

class ProviderInboxActionSucceed extends ProviderInboxState {
  final String message;
  ProviderInboxActionSucceed(this.message);
}

class ProviderInboxError extends ProviderInboxState {
  final String message;
  ProviderInboxError(this.message);
}
