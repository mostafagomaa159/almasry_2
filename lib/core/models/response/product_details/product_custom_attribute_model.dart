import 'dart:convert';

class ProductCustomAttributeModel {
  final String code;
  final String label;
  final String dataType;
  final String uiInputType;
  final bool isHtmlAllowed;
  final bool isSystem;
  final List<String> selectedOptions;

  final List<String> selectedOptionUids;

  final String enteredValue;

  const ProductCustomAttributeModel({
    required this.code,
    required this.label,
    required this.dataType,
    required this.uiInputType,
    required this.isHtmlAllowed,
    required this.isSystem,
    required this.selectedOptions,
    required this.selectedOptionUids,
    required this.enteredValue,
  });

  factory ProductCustomAttributeModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? metadata =
        json['attribute_metadata'] as Map<String, dynamic>?;

    final Map<String, dynamic>? uiInput =
        metadata?['ui_input'] as Map<String, dynamic>?;

    final Map<String, dynamic>? selected =
        json['selected_attribute_options'] as Map<String, dynamic>?;

    final List<Map<String, dynamic>> options =
        (selected?['attribute_option'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .toList();

    final List<String> selectedOptions = options
        .map((option) => option['label']?.toString() ?? '')
        .where((label) => label.trim().isNotEmpty)
        .toList();

    final List<String> selectedOptionUids = options
        .map((option) => option['uid']?.toString() ?? '')
        .where((uid) => uid.trim().isNotEmpty)
        .toList();

    return ProductCustomAttributeModel(
      code: metadata?['code']?.toString() ?? '',
      label: metadata?['label']?.toString() ?? '',
      dataType: metadata?['data_type']?.toString() ?? '',
      uiInputType: uiInput?['ui_input_type']?.toString() ?? '',
      isHtmlAllowed: uiInput?['is_html_allowed'] as bool? ?? false,
      isSystem: metadata?['is_system'] as bool? ?? false,
      selectedOptions: selectedOptions,
      selectedOptionUids: selectedOptionUids,
      enteredValue:
          (json['entered_attribute_value'] as Map<String, dynamic>?)?['value']
              ?.toString() ??
          '',
    );
  }

  String get displayValue {
    if (selectedOptions.isNotEmpty) return selectedOptions.join(', ');

    return _stripHtml(enteredValue).trim();
  }

  bool get hasValue => displayValue.isNotEmpty && label.trim().isNotEmpty;

  String get firstOptionId {
    if (selectedOptionUids.isEmpty) return '';

    try {
      final String decoded = utf8.decode(
        base64Decode(selectedOptionUids.first),
      );

      final List<String> parts = decoded
          .split('/')
          .where((part) => part.trim().isNotEmpty)
          .toList();

      return parts.isEmpty ? '' : parts.last;
    } catch (_) {
      return '';
    }
  }

  static String _stripHtml(String value) {
    if (value.isEmpty) return value;

    return value
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll('&nbsp;', ' ')
        .replaceAll(RegExp(r'\s+'), ' ');
  }
}
