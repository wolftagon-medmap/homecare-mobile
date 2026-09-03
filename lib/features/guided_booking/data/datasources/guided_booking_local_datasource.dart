import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:m2health/features/guided_booking/data/datasources/guided_booking_datasource.dart';
import 'package:m2health/features/guided_booking/data/models/booking_models.dart';
import 'package:m2health/features/guided_booking/domain/entities/guided_booking_draft.dart';

/// The one genuinely local source in this feature: an in-progress draft is
/// device state, not server data. Everything else — issues, professionals,
/// addresses, submissions — comes from the backend.
class BookingDraftLocalDataSource implements BookingDraftDataSource {
  static const String _prefix = 'guided_booking_draft.';

  final SharedPreferences prefs;

  BookingDraftLocalDataSource(this.prefs);

  @override
  Future<GuidedBookingDraft?> load(String category) async {
    final raw = prefs.getString('$_prefix$category');
    if (raw == null) return null;
    try {
      return GuidedBookingDraftModel.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } on FormatException {
      await clear(category);
      return null;
    }
  }

  @override
  Future<void> save(GuidedBookingDraft draft) async {
    await prefs.setString(
      '$_prefix${draft.category}',
      jsonEncode(draft.toJson()),
    );
  }

  @override
  Future<void> clear(String category) async {
    await prefs.remove('$_prefix$category');
  }
}
