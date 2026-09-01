part of 'dashboard_cubit.dart';

class DashboardState extends Equatable {
  final DashboardHeader header;

  /// Only true before a header has ever resolved, so a background reload never
  /// blanks a header the user is already looking at.
  final bool headerLoading;

  final bool headerFailed;
  final bool sessionExpired;
  final int unreadNotifications;
  final bool notificationsFailed;

  const DashboardState({
    this.header = DashboardHeader.empty,
    this.headerLoading = true,
    this.headerFailed = false,
    this.sessionExpired = false,
    this.unreadNotifications = 0,
    this.notificationsFailed = false,
  });

  DashboardState copyWith({
    DashboardHeader? header,
    bool? headerLoading,
    bool? headerFailed,
    bool? sessionExpired,
    int? unreadNotifications,
    bool? notificationsFailed,
  }) {
    return DashboardState(
      header: header ?? this.header,
      headerLoading: headerLoading ?? this.headerLoading,
      headerFailed: headerFailed ?? this.headerFailed,
      sessionExpired: sessionExpired ?? this.sessionExpired,
      unreadNotifications: unreadNotifications ?? this.unreadNotifications,
      notificationsFailed: notificationsFailed ?? this.notificationsFailed,
    );
  }

  @override
  List<Object?> get props => [
        header,
        headerLoading,
        headerFailed,
        sessionExpired,
        unreadNotifications,
        notificationsFailed,
      ];
}
