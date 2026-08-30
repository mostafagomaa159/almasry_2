class ProductPriceModel {
  final double value;
  final String currency;

  const ProductPriceModel({this.value = 0, this.currency = ''});

  factory ProductPriceModel.fromJson(Map<String, dynamic>? json) {
    return ProductPriceModel(
      value: (json?['value'] as num?)?.toDouble() ?? 0,
      currency: json?['currency']?.toString() ?? '',
    );
  }

  bool get isEmpty => value <= 0;
}

class ProductDiscountModel {
  final double percentOff;
  final double amountOff;

  const ProductDiscountModel({this.percentOff = 0, this.amountOff = 0});

  factory ProductDiscountModel.fromJson(Map<String, dynamic>? json) {
    return ProductDiscountModel(
      percentOff: (json?['percent_off'] as num?)?.toDouble() ?? 0,
      amountOff: (json?['amount_off'] as num?)?.toDouble() ?? 0,
    );
  }

  bool get hasDiscount => percentOff > 0 || amountOff > 0;
}

class ProductPriceTierRangeModel {
  final ProductPriceModel regularPrice;
  final ProductPriceModel finalPrice;
  final ProductDiscountModel discount;

  const ProductPriceTierRangeModel({
    this.regularPrice = const ProductPriceModel(),
    this.finalPrice = const ProductPriceModel(),
    this.discount = const ProductDiscountModel(),
  });

  factory ProductPriceTierRangeModel.fromJson(Map<String, dynamic>? json) {
    return ProductPriceTierRangeModel(
      regularPrice: ProductPriceModel.fromJson(
        json?['regular_price'] as Map<String, dynamic>?,
      ),
      finalPrice: ProductPriceModel.fromJson(
        json?['final_price'] as Map<String, dynamic>?,
      ),
      discount: ProductDiscountModel.fromJson(
        json?['discount'] as Map<String, dynamic>?,
      ),
    );
  }
}

class ProductPriceRangeModel {
  final ProductPriceTierRangeModel minimumPrice;
  final ProductPriceTierRangeModel maximumPrice;

  const ProductPriceRangeModel({
    this.minimumPrice = const ProductPriceTierRangeModel(),
    this.maximumPrice = const ProductPriceTierRangeModel(),
  });

  factory ProductPriceRangeModel.fromJson(Map<String, dynamic>? json) {
    return ProductPriceRangeModel(
      minimumPrice: ProductPriceTierRangeModel.fromJson(
        json?['minimum_price'] as Map<String, dynamic>?,
      ),
      maximumPrice: ProductPriceTierRangeModel.fromJson(
        json?['maximum_price'] as Map<String, dynamic>?,
      ),
    );
  }
}

/// A "buy N, pay this each" row from `price_tiers`.
class ProductPriceTierModel {
  final double quantity;
  final ProductPriceModel finalPrice;
  final ProductDiscountModel discount;

  const ProductPriceTierModel({
    required this.quantity,
    required this.finalPrice,
    required this.discount,
  });

  factory ProductPriceTierModel.fromJson(Map<String, dynamic> json) {
    return ProductPriceTierModel(
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0,
      finalPrice: ProductPriceModel.fromJson(
        json['final_price'] as Map<String, dynamic>?,
      ),
      discount: ProductDiscountModel.fromJson(
        json['discount'] as Map<String, dynamic>?,
      ),
    );
  }
}
