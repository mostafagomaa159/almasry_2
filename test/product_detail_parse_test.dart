import 'dart:convert';
import 'dart:io';

import 'package:almasry_2/core/models/response/product_details/get_product_detail_response.dart';
import 'package:almasry_2/core/models/response/product_details/product_detail_model.dart';
import 'package:almasry_2/core/models/response/product_details/products_by_brand_response.dart';
import 'package:flutter_test/flutter_test.dart';

/// Parses real `GetProductDetail` payloads captured from the live endpoint, so
/// a shape the models guess wrong about fails here instead of on the screen.
///
/// The two fixtures differ on purpose: one product is plainly priced, the
/// other carries a discount and a merchandising label.
void main() {
  ProductDetailModel parse(String fixture) {
    final String raw = File('test/fixtures/$fixture').readAsStringSync();

    final Map<String, dynamic> body = jsonDecode(raw) as Map<String, dynamic>;

    final ProductDetailModel? product = GetProductDetailResponse.fromJson(
      body['data'] as Map<String, dynamic>,
    ).product;

    expect(product, isNotNull);

    product!
      ..galleryUrls
      ..carouselProducts
      ..discountPercent
      ..ratingOutOfFive
      ..isInStock
      ..brandName
      ..videos
      ..currency;

    for (final review in product.reviews.items) {
      review.ratingOutOfFive;
    }

    return product;
  }

  test('parses a plainly priced product', () {
    final ProductDetailModel product = parse('product_detail_response.json');

    expect(product.sku, 'ISG009089');
    expect(product.name, isNotEmpty);
    expect(product.brandName, 'Natrol');
    expect(product.customAttributes, hasLength(14));
    expect(product.categories, hasLength(2));
    expect(product.finalPrice, 1242.0);
    expect(product.hasDiscount, isFalse);
    expect(product.isInStock, isFalse);
    expect(product.galleryUrls, hasLength(1));
    expect(product.weight, 5.0);
  });

  test('parses a discounted product with a label', () {
    final ProductDetailModel product = parse('product_detail_response_2.json');

    expect(product.sku, 'ISG009085');
    expect(product.regularPrice, 1104.0);
    expect(product.finalPrice, 994.0);
    expect(product.hasDiscount, isTrue);
    expect(product.discountPercent, 10);
    expect(product.labels, hasLength(1));
    expect(product.customAttributes, hasLength(15));
  });

  test('reads the brand id the carousel filters on', () {
    final ProductDetailModel product = parse('product_detail_response_2.json');

    expect(product.brandName, 'Natrol');
    expect(product.brandId, '7413');
  });

  test('parses the brand products payload', () {
    final String raw = File(
      'test/fixtures/products_by_brand_response.json',
    ).readAsStringSync();

    final Map<String, dynamic> body = jsonDecode(raw) as Map<String, dynamic>;

    final ProductsByBrandResponse response = ProductsByBrandResponse.fromJson(
      body['data'] as Map<String, dynamic>,
    );

    expect(response.totalCount, 20);
    expect(response.items, hasLength(10));

    for (final item in response.items) {
      expect(item.sku, isNotEmpty);
      expect(item.thumbnailUrl, startsWith('https://'));
    }
  });

  test('survives an empty payload', () {
    final GetProductDetailResponse response = GetProductDetailResponse.fromJson(
      const {
        'products': {'items': <dynamic>[]},
      },
    );

    expect(response.product, isNull);
  });
}
