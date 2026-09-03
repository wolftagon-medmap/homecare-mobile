import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/features/chatbot/data/fixtures/assistant_script_fixture.dart';
import 'package:m2health/features/chatbot/data/models/assistant_script_model.dart';

void main() {
  test('the served script parses and matches the fixture verbatim', () {
    final raw = File('served_script.json').readAsStringSync();
    final served = (jsonDecode(raw) as Map<String, dynamic>)['data']
        as Map<String, dynamic>;

    final parsed = AssistantScriptModel.fromJson(served);
    expect(parsed.scriptId, 'assistant_triage_v1');
    expect(parsed.step(parsed.entryStep), isNotNull);

    const eq = DeepCollectionEquality();
    final fixtureSteps = {
      for (final s in kAssistantScriptFixture['steps'] as List) (s as Map)['id']: s
    };
    final servedSteps = {
      for (final s in served['steps'] as List) (s as Map)['id']: s
    };

    expect(servedSteps.keys.toSet(), fixtureSteps.keys.toSet());
    for (final id in fixtureSteps.keys) {
      expect(
        eq.equals(
          jsonDecode(jsonEncode(servedSteps[id])),
          jsonDecode(jsonEncode(fixtureSteps[id])),
        ),
        isTrue,
        reason: 'step $id differs\nserved:  ${jsonEncode(servedSteps[id])}\n'
            'fixture: ${jsonEncode(fixtureSteps[id])}',
      );
    }

    expect(served['entry_step'], kAssistantScriptFixture['entry_step']);
    expect(served['off_topic_reply'], kAssistantScriptFixture['off_topic_reply']);
  });
}
