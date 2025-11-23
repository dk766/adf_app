import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/company_provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/stat_card.dart';
import '../widgets/monthly_chart.dart';
import '../config/app_config.dart';
import '../models/company.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboardData();
    });
  }

  Future<void> _loadDashboardData() async {
    final companyProvider = Provider.of<CompanyProvider>(context, listen: false);
    final dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);

    if (companyProvider.selectedCompany != null) {
      await dashboardProvider.loadDashboardData(
        companyProvider.selectedCompany!.cif,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          // Company Selector
          Consumer<CompanyProvider>(
            builder: (context, companyProvider, child) {
              return PopupMenuButton<Company>(
                icon: const Icon(Icons.business),
                tooltip: 'Select Company',
                onSelected: (Company company) async {
                  await companyProvider.selectCompany(company);
                  await _loadDashboardData();
                },
                itemBuilder: (BuildContext context) {
                  if (companyProvider.companies.isEmpty) {
                    return [
                      PopupMenuItem<Company>(
                        enabled: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'No companies available',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Please check your connection',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              icon: const Icon(Icons.refresh, size: 16),
                              label: const Text('Retry'),
                              onPressed: () {
                                Navigator.pop(context);
                                companyProvider.loadCompanies();
                              },
                            ),
                          ],
                        ),
                      ),
                    ];
                  }

                  return companyProvider.companies.map((Company company) {
                    return PopupMenuItem<Company>(
                      value: company,
                      child: Row(
                        children: [
                          if (company.cif == companyProvider.selectedCompany?.cif)
                            const Icon(Icons.check, size: 16)
                          else
                            const SizedBox(width: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  company.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'CIF: ${company.cif}',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList();
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () {
              Navigator.of(context).pushNamed('/analytics');
            },
            tooltip: 'Analytics',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed('/settings');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      body: Consumer2<CompanyProvider, DashboardProvider>(
        builder: (context, companyProvider, dashboardProvider, child) {
          // Show company loading error
          if (companyProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load companies',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      companyProvider.error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await companyProvider.loadCompanies();
                      if (companyProvider.selectedCompany != null) {
                        await _loadDashboardData();
                      }
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (companyProvider.selectedCompany == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.business_center, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No company selected'),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap the business icon above to select a company',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Icon(
                    Icons.arrow_upward,
                    size: 32,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            );
          }

          if (dashboardProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (dashboardProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading dashboard',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      dashboardProvider.error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _loadDashboardData,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadDashboardData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppConfig.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company Info Card
                  Card(
                    elevation: AppConfig.cardElevation,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConfig.defaultBorderRadius),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppConfig.defaultPadding),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.business,
                              color: Theme.of(context).primaryColor,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  companyProvider.selectedCompany!.name,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'CIF: ${companyProvider.selectedCompany!.cif}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                if (companyProvider.selectedCompany!.license != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        companyProvider.selectedCompany!.license!,
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
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

                  // Statistics Cards
                  if (dashboardProvider.stats != null) ...[
                    Text(
                      'Key Statistics',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.1,
                      children: [
                        StatCard(
                          title: 'Monthly Total',
                          value: _formatCurrency(dashboardProvider.stats!.monthlyTotal),
                          icon: Icons.calendar_today,
                          color: Colors.blue,
                        ),
                        StatCard(
                          title: 'Yearly Total',
                          value: _formatCurrency(dashboardProvider.stats!.yearlyTotal),
                          icon: Icons.calendar_month,
                          color: Colors.green,
                        ),
                        StatCard(
                          title: 'Total Invoices',
                          value: '${dashboardProvider.stats!.totalInvoices?.toInt() ?? 0}',
                          icon: Icons.receipt,
                          color: Colors.orange,
                          onTap: () {
                            Navigator.of(context).pushNamed('/invoices');
                          },
                        ),
                        StatCard(
                          title: 'Documents',
                          value: '-',
                          icon: Icons.folder,
                          color: Colors.purple,
                          onTap: () {
                            Navigator.of(context).pushNamed('/documents');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],

                  // Charts
                  if (dashboardProvider.monthlySales != null &&
                      dashboardProvider.monthlySales!.dataPoints.isNotEmpty) ...[
                    MonthlyChart(
                      data: dashboardProvider.monthlySales!,
                      title: 'Monthly Sales',
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 32),
                  ],

                  if (dashboardProvider.monthlyExpenses != null &&
                      dashboardProvider.monthlyExpenses!.dataPoints.isNotEmpty) ...[
                    MonthlyChart(
                      data: dashboardProvider.monthlyExpenses!,
                      title: 'Monthly Expenses',
                      color: Colors.red,
                    ),
                    const SizedBox(height: 32),
                  ],

                  if (dashboardProvider.monthlyProfit != null &&
                      dashboardProvider.monthlyProfit!.dataPoints.isNotEmpty) ...[
                    MonthlyChart(
                      data: dashboardProvider.monthlyProfit!,
                      title: 'Monthly Profit',
                      color: Colors.green,
                    ),
                    const SizedBox(height: 32),
                  ],

                  // Quick Actions
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _QuickActionChip(
                        icon: Icons.analytics,
                        label: 'Analytics',
                        onTap: () {
                          Navigator.of(context).pushNamed('/analytics');
                        },
                      ),
                      _QuickActionChip(
                        icon: Icons.receipt_long,
                        label: 'View Invoices',
                        onTap: () {
                          Navigator.of(context).pushNamed('/invoices');
                        },
                      ),
                      _QuickActionChip(
                        icon: Icons.folder_open,
                        label: 'Documents',
                        onTap: () {
                          Navigator.of(context).pushNamed('/documents');
                        },
                      ),
                      _QuickActionChip(
                        icon: Icons.upload_file,
                        label: 'Upload Document',
                        onTap: () {
                          // TODO: Implement document upload
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Document upload coming soon')),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatCurrency(double? value) {
    if (value == null) return '-';
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(2)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(2)}K';
    } else {
      return value.toStringAsFixed(2);
    }
  }
}

class _QuickActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
      labelStyle: TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
