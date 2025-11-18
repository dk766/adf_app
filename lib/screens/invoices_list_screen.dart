import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/invoice_provider.dart';
import '../models/invoice.dart';
import '../widgets/pie_chart_widget.dart';
import '../config/app_config.dart';
import 'invoice_detail_screen.dart';

class InvoicesListScreen extends StatefulWidget {
  const InvoicesListScreen({super.key});

  @override
  State<InvoicesListScreen> createState() => _InvoicesListScreenState();
}

class _InvoicesListScreenState extends State<InvoicesListScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _showAnalytics = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InvoiceProvider>().loadInvoices(refresh: true);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
        context.read<InvoiceProvider>().loadInvoices();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoices'),
        actions: [
          IconButton(
            icon: Icon(_showAnalytics ? Icons.list : Icons.analytics),
            onPressed: () {
              setState(() {
                _showAnalytics = !_showAnalytics;
              });
            },
            tooltip: _showAnalytics ? 'Show List' : 'Show Analytics',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filter',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(AppConfig.defaultPadding),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search invoices...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<InvoiceProvider>().searchInvoices('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConfig.defaultBorderRadius),
                ),
              ),
              onSubmitted: (value) {
                context.read<InvoiceProvider>().searchInvoices(value);
              },
            ),
          ),

          // Content
          Expanded(
            child: _showAnalytics ? _buildAnalyticsView() : _buildListView(),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return Consumer<InvoiceProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.invoices.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null && provider.invoices.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(provider.error!),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.loadInvoices(refresh: true),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (provider.invoices.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No invoices found'),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.loadInvoices(refresh: true),
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(AppConfig.defaultPadding),
            itemCount: provider.invoices.length + (provider.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == provider.invoices.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final invoice = provider.invoices[index];
              return _buildInvoiceCard(invoice);
            },
          ),
        );
      },
    );
  }

  Widget _buildInvoiceCard(Invoice invoice) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: invoice.isOverdue
                ? Colors.red.withOpacity(0.1)
                : Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.receipt,
            color: invoice.isOverdue ? Colors.red : Colors.green,
          ),
        ),
        title: Text(
          invoice.invoiceId,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(invoice.sellerName ?? 'Unknown Seller'),
            Text(
              invoice.issueDate != null
                  ? dateFormat.format(invoice.issueDate!)
                  : 'No date',
              style: const TextStyle(fontSize: 12),
            ),
            if (invoice.isOverdue)
              const Text(
                'OVERDUE',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        trailing: Text(
          invoice.formattedAmount,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: invoice.isOverdue ? Colors.red : Colors.green,
              ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InvoiceDetailScreen(invoice: invoice),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnalyticsView() {
    return Consumer<InvoiceProvider>(
      builder: (context, provider, child) {
        final analytics = provider.analytics;

        if (analytics == null) {
          return const Center(child: Text('No analytics available'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppConfig.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Cards
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _buildSummaryCard(
                    'Total Invoices',
                    analytics.totalInvoices.toString(),
                    Icons.receipt_long,
                    Colors.blue,
                  ),
                  _buildSummaryCard(
                    'Total Amount',
                    _formatCurrency(analytics.totalAmount),
                    Icons.attach_money,
                    Colors.green,
                  ),
                  _buildSummaryCard(
                    'Average',
                    _formatCurrency(analytics.averageAmount),
                    Icons.trending_up,
                    Colors.orange,
                  ),
                  _buildSummaryCard(
                    'Overdue',
                    analytics.overdueCount.toString(),
                    Icons.warning,
                    Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Invoice Types Pie Chart
              if (analytics.byType.isNotEmpty) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConfig.defaultPadding),
                    child: PieChartWidget(
                      data: analytics.byType.map((k, v) => MapEntry(k, v.toDouble())),
                      title: 'Invoices by Type',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Top Suppliers
              if (analytics.bySupplier.isNotEmpty) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConfig.defaultPadding),
                    child: PieChartWidget(
                      data: analytics.bySupplier,
                      title: 'Top Suppliers by Amount',
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(2)}M RON';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(2)}K RON';
    } else {
      return '${value.toStringAsFixed(2)} RON';
    }
  }

  void _showFilterDialog() {
    // TODO: Implement filter dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filter dialog coming soon')),
    );
  }
}
