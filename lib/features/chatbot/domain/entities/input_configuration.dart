class InputConfiguration {
  final InputType inputType;
  final List<InputField> fields;

  InputConfiguration({
    required this.inputType,
    required this.fields,
  });

  InputConfiguration copyWith({
    InputType? inputType,
    List<InputField>? fields,
  }) {
    return InputConfiguration(
      inputType: inputType ?? this.inputType,
      fields: fields ?? this.fields,
    );
  }

  bool get supportsText => fields.any((f) => f.type == FieldType.text);
  bool get supportsFiles => fields.any((f) => f.type == FieldType.file);
  List<String> get acceptedFileTypes {
    final fileAcceptField = fields.firstWhere(
      (f) => f.type == FieldType.fileAccept,
      orElse: () =>
          InputField(key: 'accept', type: FieldType.fileAccept, value: 'all'),
    );
    return (fileAcceptField.value as String).split(',');
  }
}

enum InputType {
  dialogInput,
  formInput,
  messageInlineInput,
  messageInlineOption
}

enum FieldType { text, file, select, fileAccept }

class InputField {
  final String key;
  final FieldType type;
  final dynamic value;
  final String? label;
  final bool required;
  final bool multiple;
  final List<SelectOption>? options;

  InputField({
    required this.key,
    required this.type,
    this.value,
    this.label,
    this.required = false,
    this.multiple = false,
    this.options,
  });
}

class SelectOption {
  final String id;
  final String text;
  final String? type;

  SelectOption({
    required this.id,
    required this.text,
    this.type,
  });
}
