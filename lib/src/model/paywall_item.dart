import 'package:purchases_flutter/purchases_flutter.dart'; // EKLENDİ

class PaywallItem {
  final String id;
  final String title;
  final String priceString;
  final String? subPriceString;
  final bool isBestValue;
  final Package? rcPackage;

  PaywallItem({
    required this.id,
    required this.title,
    required this.priceString,
    this.subPriceString,
    this.isBestValue = false,
    this.rcPackage,
  });
}
