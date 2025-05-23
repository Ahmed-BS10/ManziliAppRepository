import 'package:flutter/material.dart';

class Order {
  final String id;
  
  final String customerName;
  final String customerAvatar;
  final String customerEmail; 
  final String customerAddress;
  final String customerPhone;
  final List<OrderItem> items;
  final OrderStatus status;
  final DateTime date;
  final String notes;
  final String? documentUrl; 

  Order({
    required this.id,
    required this.customerName,
    required this.customerAvatar,
    required this.customerEmail,
    required this.customerAddress,
    required this.customerPhone,
    required this.items,
    required this.status,
    required this.date,
    required this.notes,
    this.documentUrl, 
  });

  double get totalPrice => items.fold(
      0, (previousValue, item) => previousValue + (item.price * item.quantity));

  int get totalQuantity =>
      items.fold(0, (previousValue, item) => previousValue + item.quantity);

  Order copyWith({required OrderStatus status}) {
    return Order(
      id: id,
      customerName: customerName,
      customerAvatar: customerAvatar,
      customerEmail: customerEmail,
      customerAddress: customerAddress,
      customerPhone: customerPhone,
      items: items,
      status: status,
      date: date,
      notes: notes,
      documentUrl: documentUrl,
    );
  }
}

class OrderItem {
  final String id;
  final String name;
  final double price;
  final int quantity;

  OrderItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });
}

enum OrderStatus {
  new_order,
  in_progress,
  completed,
  ongoing,
  cancelled,
}

extension OrderStatusExtension on OrderStatus {
  String get arabicName {
    switch (this) {
      case OrderStatus.new_order:
        return 'طلب جديد';
      case OrderStatus.in_progress:
        return 'قيد التنفيذ';
      case OrderStatus.completed:
        return 'مكتمل';
      case OrderStatus.cancelled:
        return 'ملغي';
      case OrderStatus.ongoing:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.new_order:
        return Colors.blue;
      case OrderStatus.in_progress:
        return Colors.orange;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
      case OrderStatus.ongoing:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
