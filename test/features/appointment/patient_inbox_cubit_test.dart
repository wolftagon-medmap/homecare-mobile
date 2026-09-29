import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/features/appointment/bloc/patient_inbox_cubit.dart';

/// Records every request and answers from a script.
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

  Dio dioWith(HttpClientAdapter adapter) => Dio()..httpClientAdapter = adapter;

  test('loads server rows only', () async {
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

  test('a failure is an error state', () async {
    final cubit = PatientInboxCubit(dioWith(_RecordingAdapter(fail: true)));

    await cubit.fetchInbox();

    expect(cubit.state, isA<PatientInboxError>());
  });
}
