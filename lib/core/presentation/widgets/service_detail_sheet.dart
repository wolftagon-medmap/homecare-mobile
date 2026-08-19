import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';

class ServiceDetailSheet extends StatelessWidget {
  final ServiceEntity service;

  const ServiceDetailSheet({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final description = service.description?.trim();
    final hasDescription = description != null && description.isNotEmpty;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              service.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 4,
              children: [
                Text(
                  '\$${service.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Const.aqua,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (service.durationMinutes != null)
                  Text(
                    '${service.durationMinutes} minutes',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              hasDescription
                  ? description
                  : 'No additional details for this service yet.',
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: hasDescription ? Colors.black87 : Colors.grey.shade600,
                fontStyle: hasDescription ? FontStyle.normal : FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showServiceDetailSheet(BuildContext context, ServiceEntity service) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => ServiceDetailSheet(service: service),
  );
}
