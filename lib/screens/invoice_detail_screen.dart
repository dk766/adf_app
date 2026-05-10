import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/invoice.dart';
import '../config/app_config.dart';

class InvoiceDetailScreen extends StatelessWidget {
  final Invoice invoice;

  const InvoiceDetailScreen({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice ${invoice.invoiceId}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConfig.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner
            if (invoice.isOverdue)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This invoice is ${invoice.daysUntilDue!.abs()} days overdue',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            // Invoice Information
            _buildSection(
              'Invoice Information',
              [
                _buildInfoRow('Invoice ID', invoice.invoiceId),
                _buildInfoRow('Type', invoice.invoiceType ?? 'N/A'),
                _buildInfoRow(
                  'Issue Date',
                  invoice.issueDate != null ? dateFormat.format(invoice.issueDate!) : 'N/A',
                ),
                _buildInfoRow(
                  'Due Date',
                  invoice.dueDate != null ? dateFormat.format(invoice.dueDate!) : 'N/A',
                ),
                if (invoice.downloadId != null)
                  _buildInfoRow('Download ID', invoice.downloadId!),
              ],
            ),

            const SizedBox(height: 24),

            // Seller Information
            _buildSection(
              'Seller',
              [
                _buildInfoRow('Name', invoice.sellerName ?? 'N/A'),
                _buildInfoRow('Tax ID', invoice.sellerCompanyTaxId ?? 'N/A'),
              ],
            ),

            const SizedBox(height: 24),

            // Buyer Information
            _buildSection(
              'Buyer',
              [
                _buildInfoRow('Name', invoice.buyerName ?? 'N/A'),
                _buildInfoRow('Tax ID', invoice.buyerCompanyTaxId ?? 'N/A'),
              ],
            ),

            const SizedBox(height: 24),

            // Financial Information
            _buildSection(
              'Financial Details',
              [
                _buildInfoRow('Amount (ex. VAT)', invoice.formattedTaxExclusive),
                _buildInfoRow('VAT', invoice.tax ?? 'N/A'),
                _buildInfoRow(
                  'Total Amount',
                  invoice.formattedAmount,
                  valueStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConfig.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: valueStyle ?? const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
