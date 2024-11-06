
class InvoiceModel {
  final String id;
  final String invoiceNumber;
  final DateTime date;
  final String partyName;
  final List<InvoiceItem> items;
  final double totalQuantity;
  final double totalValue;

  InvoiceModel({
    required this.id,
    required this.invoiceNumber,
    required this.date,
    required this.partyName,
    required this.items,
    required this.totalQuantity,
    required this.totalValue,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'] as String,
      invoiceNumber: json['invoiceNumber'] as String,
      date: DateTime.parse(json['date'] as String),
      partyName: json['partyName'] as String,
      items: (json['items'] as List)
          .map((item) => InvoiceItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalQuantity: (json['totalQuantity'] as num).toDouble(),
      totalValue: (json['totalValue'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceNumber': invoiceNumber,
      'date': date.toIso8601String(),
      'partyName': partyName,
      'items': items.map((item) => item.toJson()).toList(),
      'totalQuantity': totalQuantity,
      'totalValue': totalValue,
    };
  }
}

class InvoiceItem {
  final String itemName;
  final double quantity;
  final double rate;
  final double value;

  InvoiceItem({
    required this.itemName,
    required this.quantity,
    required this.rate,
    required this.value,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      itemName: json['itemName'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      rate: (json['rate'] as num).toDouble(),
      value: (json['value'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'quantity': quantity,
      'rate': rate,
      'value': value,
    };
  }
}