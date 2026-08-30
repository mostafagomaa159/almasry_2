import 'package:flutter/material.dart';
import 'package:almasry_2/core/constants/app_colors.dart';


class ProductSearchLabelModel {
  final String text;
  final String image;
  final String labelClass;
  final String position;
  final String cssStyle;

  const ProductSearchLabelModel({
    required this.text,
    required this.image,
    required this.labelClass,
    required this.position,
    required this.cssStyle,
  });

  factory ProductSearchLabelModel.fromJson(Map<String, dynamic> json) {
    return ProductSearchLabelModel(
      text: json['product_details_label_text']?.toString() ?? '',
      image: json['product_details_label_image']?.toString() ?? '',
      labelClass: json['product_details_label_class']?.toString() ?? '',
      position: json['product_details_label_position']?.toString() ?? '',
      cssStyle: json['product_details_label_css_style']?.toString() ?? '',
    );
  }

  bool get hasText => text.trim().isNotEmpty;

  bool get hasImage => image.trim().isNotEmpty;

  bool get isEmpty => !hasText && !hasImage;

  Color get backgroundColor =>
      _colorFrom('background-color') ?? AppColors.textLabelFallback;

  Color get textColor => _colorFrom('color') ?? Colors.white;

  Color? _colorFrom(String property) {
    if (cssStyle.trim().isEmpty) return null;

    final RegExp pattern = RegExp(
      '(?:^|[;\\s])$property\\s*:\\s*([^;]+)',
      caseSensitive: false,
    );

    final String? value = pattern.firstMatch(cssStyle)?.group(1)?.trim();

    if (value == null) return null;

    return _parseHex(value);
  }

  Color? _parseHex(String value) {
    final String hex = value.replaceAll('#', '').trim();

    if (hex.length != 3 && hex.length != 6) return null;

    /// `#fff` is the same colour as `#ffffff`.
    final String expanded = hex.length == 3
        ? hex.split('').map((char) => '$char$char').join()
        : hex;

    final int? parsed = int.tryParse(expanded, radix: 16);

    if (parsed == null) return null;

    return Color(0xFF000000 | parsed);
  }
}
