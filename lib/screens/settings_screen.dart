import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../providers/settings_provider.dart';
import '../providers/auth_provider.dart';
import '../config/app_config.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _baseUrlController = TextEditingController();
  final _userInfoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    _baseUrlController.text = settingsProvider.baseUrl;
    _userInfoController.text = settingsProvider.userInfo ?? '';
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    _userInfoController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null && mounted) {
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
      await settingsProvider.updateUserLogo(image.path);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logo updated successfully')),
        );
      }
    }
  }

  Future<void> _saveSettings() async {
    if (_formKey.currentState!.validate()) {
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

      await settingsProvider.updateBaseUrl(_baseUrlController.text.trim());
      await settingsProvider.updateUserInfo(_userInfoController.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings saved successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          if (authProvider.isAuthenticated)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveSettings,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConfig.defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Server Configuration Section
              _SectionHeader(
                icon: Icons.cloud,
                title: 'Server Configuration',
              ),
              const SizedBox(height: 16),
              Card(
                elevation: AppConfig.cardElevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConfig.defaultBorderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppConfig.defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _baseUrlController,
                        decoration: InputDecoration(
                          labelText: 'Base URL',
                          hintText: 'http://localhost:8000',
                          prefixIcon: const Icon(Icons.link),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConfig.defaultBorderRadius),
                          ),
                          helperText: 'Enter the backend API base URL',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a base URL';
                          }
                          if (!value.startsWith('http://') && !value.startsWith('https://')) {
                            return 'URL must start with http:// or https://';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                _baseUrlController.text = AppConfig.defaultBaseUrl;
                                await _saveSettings();
                              },
                              icon: const Icon(Icons.refresh, size: 18),
                              label: const Text('Reset to Default'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[200],
                                foregroundColor: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // User Personalization Section
              _SectionHeader(
                icon: Icons.person,
                title: 'Personalization',
              ),
              const SizedBox(height: 16),
              Card(
                elevation: AppConfig.cardElevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConfig.defaultBorderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppConfig.defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo
                      Text(
                        'Company Logo',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Consumer<SettingsProvider>(
                        builder: (context, settingsProvider, child) {
                          return Row(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: settingsProvider.userLogo != null &&
                                        settingsProvider.userLogo!.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          File(settingsProvider.userLogo!),
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Icon(Icons.business, size: 40);
                                          },
                                        ),
                                      )
                                    : const Icon(Icons.business, size: 40),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: _pickImage,
                                    icon: const Icon(Icons.upload, size: 18),
                                    label: const Text('Upload Logo'),
                                  ),
                                  const SizedBox(height: 8),
                                  if (settingsProvider.userLogo != null)
                                    TextButton.icon(
                                      onPressed: () async {
                                        await settingsProvider.clearUserLogo();
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Logo removed')),
                                          );
                                        }
                                      },
                                      icon: const Icon(Icons.delete, size: 18),
                                      label: const Text('Remove'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // User Info
                      TextFormField(
                        controller: _userInfoController,
                        decoration: InputDecoration(
                          labelText: 'Additional Information',
                          hintText: 'Company name, department, etc.',
                          prefixIcon: const Icon(Icons.info),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConfig.defaultBorderRadius),
                          ),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Account Section
              if (authProvider.isAuthenticated) ...[
                _SectionHeader(
                  icon: Icons.account_circle,
                  title: 'Account',
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: AppConfig.cardElevation,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConfig.defaultBorderRadius),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppConfig.defaultPadding),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text('Username'),
                          subtitle: Text(authProvider.username ?? 'Not logged in'),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.logout, color: Colors.red),
                          title: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.red),
                          ),
                          onTap: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Logout'),
                                content: const Text('Are you sure you want to logout?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Logout'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true && context.mounted) {
                              await authProvider.logout();
                              if (context.mounted) {
                                Navigator.of(context).pushReplacementNamed('/login');
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),

              // App Information
              _SectionHeader(
                icon: Icons.info,
                title: 'App Information',
              ),
              const SizedBox(height: 16),
              Card(
                elevation: AppConfig.cardElevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConfig.defaultBorderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppConfig.defaultPadding),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.apps),
                        title: const Text('App Name'),
                        subtitle: const Text(AppConfig.appName),
                      ),
                      const ListTile(
                        leading: Icon(Icons.code),
                        title: Text('Version'),
                        subtitle: Text('1.0.0+1'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
