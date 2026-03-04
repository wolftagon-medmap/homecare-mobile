part of 'chat_event_model.dart';

class InputSchemaModel {
  final String inputType;
  final List<InputFieldModel> value;
  String? nodeId; // Set from parent event

  InputSchemaModel({
    required this.inputType,
    required this.value,
    this.nodeId,
  });

  factory InputSchemaModel.fromJson(Map<String, dynamic> json) {
    return InputSchemaModel(
      inputType: json['input_type'] as String,
      value: (json['value'] as List<dynamic>)
          .map((e) => InputFieldModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  InputConfiguration toInputConfigurationEntity() {
    InputType parseInputType(String? type) {
      switch (type) {
        case 'dialog_input':
          return InputType.dialogInput;
        case 'form_input':
          return InputType.formInput;
        case 'message_inline_input':
          return InputType.messageInlineInput;
        case 'message_inline_option':
          return InputType.messageInlineOption;
        default:
          return InputType.dialogInput;
      }
    }

    return InputConfiguration(
      inputType: parseInputType(inputType),
      fields: value,
    );
  }
}

class InputFieldModel extends InputField {
  InputFieldModel({
    required super.key,
    required super.type,
    super.value,
    super.label,
    super.multiple = false,
    super.required = false,
    super.options,
  });

  factory InputFieldModel.fromJson(Map<String, dynamic> json) {
    FieldType parseFieldType(String? type) {
      switch (type) {
        case 'text':
          return FieldType.text;
        case 'file':
          return FieldType.file;
        case 'select':
          return FieldType.select;
        case 'dialog_file':
          return FieldType.file;
        case 'dialog_file_accept':
          return FieldType.fileAccept;
        default:
          return FieldType.text;
      }
    }

    return InputFieldModel(
      key: json['key'] as String,
      type: parseFieldType(json['type'] as String?),
      value: json['value'],
      label: json['label'] as String?,
      multiple: json['multiple'] as bool? ?? false,
      required: json['required'] as bool? ?? false,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => SelectOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SelectOptionModel extends SelectOption {
  SelectOptionModel({
    required super.id,
    required super.text,
    super.type,
  });

  factory SelectOptionModel.fromJson(Map<String, dynamic> json) {
    return SelectOptionModel(
      id: json['id'] as String,
      text: json['text'] as String,
      type: json['type'] as String?,
    );
  }
}
