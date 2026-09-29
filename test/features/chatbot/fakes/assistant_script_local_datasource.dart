import 'package:m2health/features/chatbot/data/datasources/assistant_script_datasource.dart';
import 'package:m2health/features/chatbot/data/models/assistant_script_model.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_script.dart';

import 'assistant_script_fixture.dart';

class AssistantScriptLocalDataSource implements AssistantScriptDataSource {
  const AssistantScriptLocalDataSource();

  @override
  Future<AssistantScript> fetch() async =>
      AssistantScriptModel.fromJson(kAssistantScriptFixture);
}
