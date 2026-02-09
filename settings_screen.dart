import 'package:deen_connect/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:deen_connect/features/notifications/notifications_screen.dart';
import 'package:deen_connect/services/database_service.dart';
import 'package:deen_connect/services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Settings state variables
  bool _notificationsEnabled = true;
  bool _darkMode = false;
  String _prayerCalculationMethod = 'Karachi';
  String _language = 'English';
  bool _hapticFeedback = true;
  bool _showTasbihReminders = true;

  final List<String> _calculationMethods = [
    'Karachi',
    'Muslim World League',
    'Islamic Society of North America',
    'Umm Al-Qura University',
    'Egyptian General Authority',
    'University of Islamic Sciences',
  ];

  final List<String> _languages = ['English', 'Urdu', 'Arabic'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await DatabaseService().getPreferences();
    setState(() {
      _notificationsEnabled = prefs['notifications'] ?? true;
      _darkMode = prefs['darkMode'] ?? false;
      _prayerCalculationMethod = prefs['calculationMethod'] ?? 'Karachi';
      _language = prefs['language'] ?? 'English';
      _hapticFeedback = prefs['hapticFeedback'] ?? true;
      _showTasbihReminders = prefs['tasbihReminders'] ?? true;
    });
  }

  Future<void> _saveSettings() async {
    await DatabaseService().savePreferences({
      'notifications': _notificationsEnabled,
      'darkMode': _darkMode,
      'calculationMethod': _prayerCalculationMethod,
      'language': _language,
      'hapticFeedback': _hapticFeedback,
      'tasbihReminders': _showTasbihReminders,
    });

    // Apply dark mode
    if (_darkMode) {
      // Implement dark mode logic
    }

    // Update notification settings
    if (_notificationsEnabled) {
      NotificationService().scheduleAllPrayerTimes;
    } else {
      await NotificationService().cancelAllNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: ListView(
        children: [
          // User Profile Section
          _buildProfileSection(),

          // Notification Settings
          _buildSectionHeader('Notifications'),
          _buildNotificationSettings(),

          // Prayer Settings
          _buildSectionHeader('Prayer Settings'),
          _buildPrayerSettings(),

          // App Preferences
          _buildSectionHeader('App Preferences'),
          _buildAppPreferences(),

          // Advanced Settings
          _buildSectionHeader('Advanced'),
          _buildAdvancedSettings(),

          // Action Buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primary,
            child: Icon(
              Icons.person,
              size: 30,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Name',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'user@email.com',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.primary),
            onPressed: () {
              // Navigate to profile edit screen
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Enable Notifications'),
            subtitle: const Text('Get prayer time reminders'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
              _saveSettings();
            },
            activeThumbColor: AppColors.primary,
          ),
          if (_notificationsEnabled) ...[
            const Divider(height: 1),
            ListTile(
              title: const Text('Notification Settings'),
              subtitle: const Text('Customize notification preferences'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsScreen(),
                  ),
                );
              },
            ),
            const Divider(height: 1),
            SwitchListTile(
              title: const Text('Tasbih Reminders'),
              subtitle: const Text('Daily tasbih completion reminders'),
              value: _showTasbihReminders,
              onChanged: (value) {
                setState(() {
                  _showTasbihReminders = value;
                });
                _saveSettings();
              },
              activeThumbColor: AppColors.primary,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPrayerSettings() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          ListTile(
            title: const Text('Calculation Method'),
            subtitle: Text(_prayerCalculationMethod),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showCalculationMethodDialog();
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Location'),
            subtitle: const Text('Auto-detect location'),
            trailing: const Icon(Icons.location_on, color: AppColors.primary),
            onTap: () {
              // Implement location picker
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppPreferences() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _darkMode,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
              });
              _saveSettings();
            },
            activeThumbColor: AppColors.primary,
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Language'),
            subtitle: Text(_language),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showLanguageDialog();
            },
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text('Haptic Feedback'),
            subtitle: const Text('Vibrate on button press'),
            value: _hapticFeedback,
            onChanged: (value) {
              setState(() {
                _hapticFeedback = value;
              });
              _saveSettings();
            },
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSettings() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          ListTile(
            title: const Text('Clear Cache'),
            subtitle: const Text('Clear temporary data'),
            trailing: const Icon(Icons.delete_outline, color: Colors.red),
            onTap: () {
              _showClearCacheDialog();
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Export Data'),
            subtitle: const Text('Export your tasbih and prayer data'),
            trailing: const Icon(Icons.file_download, color: AppColors.primary),
            onTap: () {
              // Implement data export
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('About'),
            subtitle: const Text('Version 1.0.0'),
            trailing: const Icon(Icons.info_outline, color: AppColors.primary),
            onTap: () {
              _showAboutDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: _saveSettings,
            icon: const Icon(Icons.save),
            label: const Text('Save Settings'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () {
              // Implement sign out logic
            },
            icon: const Icon(Icons.logout),
            label: const Text('Sign Out'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              side: const BorderSide(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showCalculationMethodDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Calculation Method'),
        content: SingleChildScrollView(
          child: ListBody(
            children: _calculationMethods
                .map((method) => RadioListTile<String>(
                      title: Text(method),
                      value: method,
                      groupValue: _prayerCalculationMethod,
                      onChanged: (value) {
                        setState(() {
                          _prayerCalculationMethod = value!;
                        });
                        _saveSettings();
                        Navigator.pop(context);
                      },
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: SingleChildScrollView(
          child: ListBody(
            children: _languages
                .map((lang) => RadioListTile<String>(
                      title: Text(lang),
                      value: lang,
                      groupValue: _language,
                      onChanged: (value) {
                        setState(() {
                          _language = value!;
                        });
                        _saveSettings();
                        Navigator.pop(context);
                      },
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text(
            'Are you sure you want to clear cache? This will remove temporary data.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement clear cache logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared successfully')),
              );
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Deen Connect',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.mosque, color: AppColors.primaryLight),
      children: [
        const SizedBox(height: 20),
        const Text(
            'An Islamic application for Muslims to stay connected with their faith.'),
        const SizedBox(height: 10),
        const Text('Features include:'),
        const SizedBox(height: 5),
        const Text('• Prayer Times & Qibla'),
        const Text('• Quran with Translation'),
        const Text('• Tasbih Counter'),
        const Text('• Daily Duas & Notifications'),
      ],
    );
  }
}
