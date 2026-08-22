class OrderItemEntity {
  final String id;
  final String title;
  final String size;
  final double price;
  final String image;
  final String status; // 'In Transit', 'Picked', 'Packing', 'Delivered', etc.
  final bool isCompleted;
  final DateTime orderDate;

  const OrderItemEntity({
    required this.id,
    required this.title,
    required this.size,
    required this.price,
    required this.image,
    required this.status,
    this.isCompleted = false,
    required this.orderDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'size': size,
        'price': price,
        'image': image,
        'status': status,
        'isCompleted': isCompleted,
        'orderDate': orderDate.toIso8601String(),
      };

  factory OrderItemEntity.fromJson(Map<String, dynamic> json) => OrderItemEntity(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        size: json['size'] as String? ?? 'M',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        image: json['image'] as String? ?? '',
        status: json['status'] as String? ?? 'In Transit',
        isCompleted: json['isCompleted'] as bool? ?? false,
        orderDate: json['orderDate'] != null
            ? DateTime.tryParse(json['orderDate'] as String) ?? DateTime.now()
            : DateTime.now(),
      );
}
