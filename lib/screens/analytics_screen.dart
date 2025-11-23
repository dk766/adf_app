import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/analytics_provider.dart';
import '../providers/company_provider.dart';
import '../widgets/pie_chart_widget.dart';
import '../widgets/stat_card.dart';
import '../config/app_config.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAnalytics();
    });
  }

  void _loadAnalytics() {
    final companyProvider = context.read<CompanyProvider>();
    final analyticsProvider = context.read<AnalyticsProvider>();

    if (companyProvider.selectedCompany != null) {
      analyticsProvider.loadAnalytics(companyProvider.selectedCompany!.cif);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: Consumer2<AnalyticsProvider, CompanyProvider>(
        builder: (context, analyticsProvider, companyProvider, child) {
          if (companyProvider.selectedCompany == null) {
            return const Center(child: Text('No company selected'));
          }

          if (analyticsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (analyticsProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(analyticsProvider.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadAnalytics,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final analytics = analyticsProvider.analytics;
          final topPartners = analyticsProvider.topPartners;

          if (analytics == null) {
            return const Center(child: Text('No analytics data available'));
          }

          return RefreshIndicator(
            onRefresh: () async => _loadAnalytics(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConfig.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Financial Metrics
                  Text(
                    'Financial Overview',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.1,
                    children: [
                      StatCard(
                        title: 'Total Revenue',
                        value: _formatCurrency(analytics.financialMetrics.totalRevenue),
                        icon: Icons.trending_up,
                        color: Colors.green,
                      ),
                      StatCard(
                        title: 'Total Expenses',
                        value: _formatCurrency(analytics.financialMetrics.totalExpenses),
                        icon: Icons.trending_down,
                        color: Colors.red,
                      ),
                      StatCard(
                        title: 'Net Profit',
                        value: _formatCurrency(analytics.financialMetrics.netProfit),
                        icon: Icons.account_balance,
                        color: Colors.blue,
                      ),
                      StatCard(
                        title: 'Profit Margin',
                        value: '${analytics.financialMetrics.profitMargin.toStringAsFixed(1)}%',
                        icon: Icons.percent,
                        color: Colors.purple,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Growth Indicator
                  if (analytics.financialMetrics.revenueGrowth != 0) ...[
                    Card(
                      color: analytics.financialMetrics.revenueGrowth > 0
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(AppConfig.defaultPadding),
                        child: Row(
                          children: [
                            Icon(
                              analytics.financialMetrics.revenueGrowth > 0
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: analytics.financialMetrics.revenueGrowth > 0
                                  ? Colors.green
                                  : Colors.red,
                              size: 32,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Month-over-Month Growth',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '${analytics.financialMetrics.revenueGrowth.toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: analytics.financialMetrics.revenueGrowth > 0
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Invoice Metrics
                  Text(
                    'Invoice Statistics',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.1,
                    children: [
                      StatCard(
                        title: 'Total Invoices',
                        value: analytics.invoiceMetrics.totalInvoices.toString(),
                        icon: Icons.receipt_long,
                        color: Colors.blue,
                      ),
                      StatCard(
                        title: 'Paid',
                        value: analytics.invoiceMetrics.paidInvoices.toString(),
                        icon: Icons.check_circle,
                        color: Colors.green,
                      ),
                      StatCard(
                        title: 'Pending',
                        value: analytics.invoiceMetrics.pendingInvoices.toString(),
                        icon: Icons.pending,
                        color: Colors.orange,
                      ),
                      StatCard(
                        title: 'Overdue',
                        value: analytics.invoiceMetrics.overdueInvoices.toString(),
                        icon: Icons.warning,
                        color: Colors.red,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Top Suppliers
                  if (topPartners != null && topPartners.topSuppliers.isNotEmpty) ...[
                    Text(
                      'Top Suppliers',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppConfig.defaultPadding),
                        child: PieChartWidget(
                          data: Map.fromIterable(
                            topPartners.topSuppliers,
                            key: (e) => e.name,
                            value: (e) => e.totalAmount,
                          ),
                          title: 'Spending Distribution',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...topPartners.topSuppliers.take(5).map((supplier) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(supplier.name.substring(0, 1).toUpperCase()),
                          ),
                          title: Text(supplier.name),
                          subtitle: Text('${supplier.transactionCount} transactions'),
                          trailing: Text(
                            _formatCurrency(supplier.totalAmount),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                  ],

                  // Top Customers
                  if (topPartners != null && topPartners.topCustomers.isNotEmpty) ...[
                    Text(
                      'Top Customers',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppConfig.defaultPadding),
                        child: PieChartWidget(
                          data: Map.fromIterable(
                            topPartners.topCustomers,
                            key: (e) => e.name,
                            value: (e) => e.totalAmount,
                          ),
                          title: 'Revenue Distribution',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...topPartners.topCustomers.take(5).map((customer) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(customer.name.substring(0, 1).toUpperCase()),
                          ),
                          title: Text(customer.name),
                          subtitle: Text('${customer.transactionCount} transactions'),
                          trailing: Text(
                            _formatCurrency(customer.totalAmount),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(2)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(2)}K';
    } else {
      return value.toStringAsFixed(2);
    }
  }
}
