import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/order.dart';

// Interface for order actions
abstract class IOrderActions {
  Widget buildActions();
}

// Implementation for new orders
class NewOrderActions implements IOrderActions {
  final VoidCallback? onAccept;
  final VoidCallback? onCancel;
  final VoidCallback? onDetails;
  final VoidCallback? onProductDetails;
  final VoidCallback? onContactCustomer;
  final String? documentName;
  final String? documentUrl;

  NewOrderActions({
    this.onAccept,
    this.onCancel,
    this.onDetails,
    this.onProductDetails,
    this.onContactCustomer,
    this.documentName,
    this.documentUrl,
  });

  @override
  Widget buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Contact Customer button
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 4),
            child: OutlinedButton(
              onPressed: onContactCustomer,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                side: const BorderSide(color: Colors.blue),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              ),
              child: const Text('التواصل مع العميل',
                  style: TextStyle(fontSize: 12)),
            ),
          ),
        ),

        // Show Details button
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: OutlinedButton(
              onPressed: onDetails,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                side: const BorderSide(color: Colors.blue),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              ),
              child: const Text('عرض التفاصيل', style: TextStyle(fontSize: 12)),
            ),
          ),
        ),

        // Accept Order button (green)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              onPressed: onAccept,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              ),
              child: const Text('تغيير حالة الطلب', style: TextStyle(fontSize: 12)),
            ),
          ),
        ),

        // Reject Order button (red)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              onPressed: onCancel,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              ),
              child: const Text('رفض الطلب', style: TextStyle(fontSize: 12)),
            ),
          ),
        ),

        // Document button
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: OutlinedButton.icon(
              onPressed: documentUrl != null
                  ? () async {
                      // Open PDF in browser
                      final url = Uri.parse(documentUrl!);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      }
                    }
                  : null,
              icon: const Icon(Icons.insert_drive_file,
                  color: Colors.red, size: 16),
              label: Text(documentName ?? 'PDF',
                  style: const TextStyle(fontSize: 10)),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.blue),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Implementation for in-progress orders
class InProgressOrderActions implements IOrderActions {
  final VoidCallback? onDetails;
  final VoidCallback? onProductDetails;
  final VoidCallback? onContactCustomer;

  InProgressOrderActions({
    this.onDetails,
    this.onProductDetails,
    this.onContactCustomer,
  });

  @override
  Widget buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (onContactCustomer != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: OutlinedButton(
                onPressed: onContactCustomer,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                ),
                child: const Text('التواصل مع العميل',
                    style: TextStyle(fontSize: 12)),
              ),
            ),
          ),
        if (onDetails != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: OutlinedButton(
                onPressed: onDetails,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                ),
                child:
                    const Text('عرض التفاصيل', style: TextStyle(fontSize: 12)),
              ),
            ),
          ),
      ],
    );
  }
}

// Implementation for completed orders
class CompletedOrderActions implements IOrderActions {
  final VoidCallback? onDetails;
  final VoidCallback? onProductDetails;
  final VoidCallback? onContactCustomer;

  CompletedOrderActions({
    this.onDetails,
    this.onProductDetails,
    this.onContactCustomer,
  });

  @override
  Widget buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (onContactCustomer != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: OutlinedButton(
                onPressed: onContactCustomer,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                ),
                child: const Text('التواصل مع العميل',
                    style: TextStyle(fontSize: 12)),
              ),
            ),
          ),
        if (onDetails != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: OutlinedButton(
                onPressed: onDetails,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                ),
                child:
                    const Text('عرض التفاصيل', style: TextStyle(fontSize: 12)),
              ),
            ),
          ),
      ],
    );
  }
}

// Factory for creating appropriate actions based on order status
class OrderActions extends StatelessWidget {
  final OrderStatus orderStatus;
  final VoidCallback? onAccept;
  final VoidCallback? onCancel;
  final VoidCallback? onDetails;
  final VoidCallback? onProductDetails;
  final VoidCallback? onContactCustomer;
  final String? documentName;
  final String? documentUrl;

  const OrderActions({
    super.key,
    required this.orderStatus,
    this.onAccept,
    this.onCancel,
    this.onDetails,
    this.onProductDetails,
    this.onContactCustomer,
    this.documentName,
    this.documentUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Apply the Factory pattern to create the appropriate actions
    IOrderActions actions;

    switch (orderStatus) {
      case OrderStatus.new_order:
        actions = NewOrderActions(
          onAccept: onAccept,
          onCancel: onCancel,
          onDetails: onDetails,
          onProductDetails: onProductDetails,
          onContactCustomer: onContactCustomer,
          documentName: documentName,
          documentUrl: documentUrl,
        );
        break;
      case OrderStatus.in_progress:
        actions = InProgressOrderActions(
          onDetails: onDetails,
          onProductDetails: onProductDetails,
          onContactCustomer: onContactCustomer,
        );
        break;
      case OrderStatus.completed:
      case OrderStatus.cancelled:
        actions = CompletedOrderActions(
          onDetails: onDetails,
          onProductDetails: onProductDetails,
          onContactCustomer: onContactCustomer,
        );
        break;
      case OrderStatus.ongoing:
        // TODO: Handle this case.
        throw UnimplementedError();
    }

    return actions.buildActions();
  }
}
