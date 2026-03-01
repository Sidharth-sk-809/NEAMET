class Order {
  final String id;
  final String customerId;
  final String status;
  final double totalAmount;
  final double deliveryDistance;
  final double deliveryCost;
  final List<OrderItem> items;
  final DateTime createdAt;
  final String? employeeId;
  final String? employeeName;
  final String? employeeCode;
  final String? estimatedDeliveryTime;

  Order({
    required this.id,
    required this.customerId,
    required this.status,
    required this.totalAmount,
    required this.deliveryDistance,
    required this.deliveryCost,
    required this.items,
    required this.createdAt,
    this.employeeId,
    this.employeeName,
    this.employeeCode,
    this.estimatedDeliveryTime,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List? ?? [];
    return Order(
      id: json['id']?.toString() ?? '',
      customerId: json['customer_id']?.toString() ?? '',
      status: json['status'] ?? 'pending',
      totalAmount:
          (json['total_amount'] is int)
              ? (json['total_amount'] as int).toDouble()
              : json['total_amount'] ?? 0.0,
      deliveryDistance:
          (json['delivery_distance'] is int)
              ? (json['delivery_distance'] as int).toDouble()
              : json['delivery_distance'] ?? 0.0,
      deliveryCost:
          (json['delivery_cost'] is int)
              ? (json['delivery_cost'] as int).toDouble()
              : json['delivery_cost'] ?? 0.0,
      items:
          itemsList.map((item) => OrderItem.fromJson(item)).toList(),
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'].toString())
              : DateTime.now(),
      employeeId: json['employee_id']?.toString(),
      employeeName: json['employee_name'],
      employeeCode: json['employee_code'],
      estimatedDeliveryTime: json['estimated_delivery_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'status': status,
      'total_amount': totalAmount,
      'delivery_distance': deliveryDistance,
      'delivery_cost': deliveryCost,
      'items': items.map((item) => item.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'employee_id': employeeId,
      'employee_name': employeeName,
      'employee_code': employeeCode,
      'estimated_delivery_time': estimatedDeliveryTime,
    };
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final String shopName;
  final double price;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.shopName,
    required this.price,
    required this.quantity,
  });

  double get subtotal => price * quantity;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product_id']?.toString() ?? '',
      productName: json['product_name'] ?? '',
      shopName: json['shop_name'] ?? '',
      price:
          (json['price'] is int)
              ? (json['price'] as int).toDouble()
              : json['price'] ?? 0.0,
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'shop_name': shopName,
      'price': price,
      'quantity': quantity,
    };
  }
}

class AvailableOrder {
  final String id;
  final List<String> shops;
  final int productCount;
  final double totalDistance;
  final double earnings;

  AvailableOrder({
    required this.id,
    required this.shops,
    required this.productCount,
    required this.totalDistance,
    required this.earnings,
  });

  factory AvailableOrder.fromJson(Map<String, dynamic> json) {
    var shopsList = (json['shops'] as List?)?.cast<String>() ?? [];
    return AvailableOrder(
      id: json['id']?.toString() ?? '',
      shops: shopsList,
      productCount: json['product_count'] ?? 0,
      totalDistance:
          (json['total_distance'] is int)
              ? (json['total_distance'] as int).toDouble()
              : json['total_distance'] ?? 0.0,
      earnings:
          (json['earnings'] is int)
              ? (json['earnings'] as int).toDouble()
              : json['earnings'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shops': shops,
      'product_count': productCount,
      'total_distance': totalDistance,
      'earnings': earnings,
    };
  }
}
