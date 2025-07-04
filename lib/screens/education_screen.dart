import 'package:flutter/material.dart';
import '../l10n/app_translations.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = AppTranslations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(translations.translate('securityTips')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTipCard(
            context,
            translations.translate('tip1Title'),
            translations.translate('tip1Content'),
            Icons.lock,
            translations,
          ),
          const SizedBox(height: 16),
          _buildTipCard(
            context,
            translations.translate('tip2Title'),
            translations.translate('tip2Content'),
            Icons.security,
            translations,
          ),
          const SizedBox(height: 16),
          _buildTipCard(
            context,
            translations.translate('tip3Title'),
            translations.translate('tip3Content'),
            Icons.mark_email_read,
            translations,
          ),
          const SizedBox(height: 16),
          _buildTipCard(
            context,
            translations.translate('tip4Title'),
            translations.translate('tip4Content'),
            Icons.system_update,
            translations,
          ),
          const SizedBox(height: 16),
          _buildTipCard(
            context,
            translations.translate('tip5Title'),
            translations.translate('tip5Content'),
            Icons.link,
            translations,
          ),
          const SizedBox(height: 16),
          _buildTipCard(
            context,
            translations.translate('tip6Title'),
            translations.translate('tip6Content'),
            Icons.wifi_lock,
            translations,
          ),
          const SizedBox(height: 16),
          _buildTipCard(
            context,
            translations.translate('tip7Title'),
            translations.translate('tip7Content'),
            Icons.security_update,
            translations,
          ),
          const SizedBox(height: 16),
          _buildTipCard(
            context,
            translations.translate('tip8Title'),
            translations.translate('tip8Content'),
            Icons.backup,
            translations,
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(
    BuildContext context,
    String title,
    String content,
    IconData icon,
    AppTranslations translations,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
