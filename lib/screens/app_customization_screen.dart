import 'package:flutter/material.dart';
import '../l10n/app_translations.dart';

class AppCustomizationScreen extends StatefulWidget {
  const AppCustomizationScreen({super.key});

  @override
  State<AppCustomizationScreen> createState() => _AppCustomizationScreenState();
}

class _AppCustomizationScreenState extends State<AppCustomizationScreen> {
  String _selectedTheme = 'default';
  bool _enableAnimations = true;

  @override
  Widget build(BuildContext context) {
    final translations = AppTranslations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(translations.translate('customizeApp')),
      ),
      body: ListView(
        children: [
          _buildSection(
            translations.translate('themeSettings'),
            [
              ListTile(
                leading: const Icon(Icons.color_lens),
                title: Text(translations.translate('appTheme')),
                subtitle: Text(_selectedTheme),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _showThemeDialog,
              ),
              SwitchListTile(
                secondary: const Icon(Icons.animation),
                title: Text(translations.translate('enableAnimations')),
                value: _enableAnimations,
                onChanged: (value) {
                  setState(() {
                    _enableAnimations = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppTranslations.of(context).translate('appTheme')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeOption('default', 'Default'),
              _buildThemeOption('blue', 'Ocean Blue'),
              _buildThemeOption('green', 'Forest Green'),
              _buildThemeOption('purple', 'Royal Purple'),
              _buildThemeOption('orange', 'Sunset Orange'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(String theme, String displayName) {
    return ListTile(
      title: Text(displayName),
      onTap: () {
        setState(() {
          _selectedTheme = theme;
        });
        Navigator.pop(context);
      },
    );
  }
}
