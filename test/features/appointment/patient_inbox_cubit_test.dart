import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/core/config/feature_flags.dart';
import 'package:m2health/features/appointment/bloc/patient_inbox_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Records every request and answers from a script. A call it was not scripted
/// for is a failure, which is how "the flag-off path never touches the network"
/// is asserted rather than assumed.
class _RecordingAdapter implements HttpClientAdapter {
  final List<String> calls = [];
  final Map<String, dynamic>? body;
  final bool fail;

  _RecordingAdapter({this.body, this.fail = false});

  @override
  Future<ResponseBody> fetch(RequestOptions options, _, __) async {
    calls.add(options.path);
    if (fail) throw DioException(requestOptions: options, message: 'boom');
    return ResponseBody.fromString(
      _encode(body ?? const {'items': []}),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType]
      },
    );
  }

  @override
  void close({bool force = false}) {}

  static String _encode(Map<String, dynamic> value) => jsonEncode(value);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    AppFlags.clearServerFlags();
    await AppFlags.init(await SharedPreferences.getInstance());
    await AppFlags.clearOverrides();
  });

  Dio dioWith(HttpClientAdapter adapter) => Dio()..httpClientAdapter = adapter;

  test('flag off: fixture rows only, and the network is never called',
      () async {
    final adapter = _RecordingAdapter();
    final cubit = PatientInboxCubit(dioWith(adapter));

    await cubit.fetchInbox();

    expect(adapter.calls, isEmpty);
    final state = cubit.state;
    expect(state, isA<PatientInboxLoaded>());
    expect((state as PatientInboxLoaded).items, isNotEmpty);
    expect(state.items.map((i) => i.status),
        containsAll(<String>['time_proposed', 'unmatched']));
  });

  test('flag on: server rows only, no fixture merged in', () async {
    await AppFlags.setOverride(Feature.timeProposal, true);
    final adapter = _RecordingAdapter(body: {
      'items': [
        {
          'origin': 'care_task',
          'key': 'task:1',
          'careTaskId': 1,
          'serviceLabel': 'Home Nursing',
          'status': 'matched',
          'statusLabel': 'Awaiting confirmation',
          'issueLabels': ['Wound care'],
        }
      ]
    });
    final cubit = PatientInboxCubit(dioWith(adapter));

    await cubit.fetchInbox();

    expect(adapter.calls, hasLength(1));
    final items = (cubit.state as PatientInboxLoaded).items;
    expect(items, hasLength(1));
    expect(items.single.careTaskId, 1);
    expect(items.single.issueLabels, ['Wound care']);
  });

  test('flag on: a failure is an error state, not a fixture', () async {
    await AppFlags.setOverride(Feature.timeProposal, true);
    final cubit = PatientInboxCubit(dioWith(_RecordingAdapter(fail: true)));

    await cubit.fetchInbox();

    expect(cubit.state, isA<PatientInboxError>());
  });
}
