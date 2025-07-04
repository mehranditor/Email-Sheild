import 'package:flutter/material.dart';
import '../l10n/app_translations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = AppTranslations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(translations.translate('privacyPolicy')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              translations.translate('privacyPolicyTitle'),
              translations.translate('privacyPolicyContent'),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              translations.translate('dataCollectionTitle'),
              translations.translate('dataCollectionContent'),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              translations.translate('dataUsageTitle'),
              translations.translate('dataUsageContent'),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              translations.translate('dataSecurityTitle'),
              translations.translate('dataSecurityContent'),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              translations.translate('userRightsTitle'),
              translations.translate('userRightsContent'),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              translations.translate('contactUsTitle'),
              translations.translate('contactUsContent'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
