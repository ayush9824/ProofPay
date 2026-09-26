import 'package:flutter/material.dart';
import '../models/invoice.dart';
import '../theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final InvoiceStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    switch (status) {
      case InvoiceStatus.draft:
        color = AppColors.statusDraft;
        text = 'Draft';
        break;
      case InvoiceStatus.upcoming:
        color = AppColors.statusUpcoming;
        text = 'Upcoming';
        break;
      case InvoiceStatus.dueSoon:
        color = AppColors.statusDueSoon;
        text = 'Due Soon';
        break;
      case InvoiceStatus.due:
        color = AppColors.statusDue;
        text = 'Due';
        break;
      case InvoiceStatus.overdue:
        color = AppColors.statusOverdue;
        text = 'Overdue';
        break;
      case InvoiceStatus.paid:
        color = AppColors.statusPaid;
        text = 'Paid';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
