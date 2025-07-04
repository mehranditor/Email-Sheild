import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../l10n/app_translations.dart';
import 'privacy_policy_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'app_customization_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _autoScanEnabled = true;
  double _scanSensitivity = 0.7;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final translations = AppTranslations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(translations.translate('settings')),
      ),
      body: ListView(
        children: [
          _buildAppearanceSection(context, translations),
          _buildSection(
            translations.translate('securityTips'),
            [
              ListTile(
                leading: Icon(Icons.password),
                title: Text(translations.translate('checkPasswordStrength')),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _showPasswordStrengthDialog,
              ),
              ListTile(
                leading: Icon(Icons.help_outline),
                title: Text(translations.translate('faqHelp')),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _showFaqDialog,
              ),
            ],
          ),
          _buildSection(
            translations.translate('about'),
            [
              ListTile(
                title: Text(translations.translate('version')),
                subtitle: const Text('1.0.0'),
              ),
              ListTile(
                leading: Icon(Icons.group_add),
                title: Text(translations.translate('inviteFriends')),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _inviteFriends,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection(
      BuildContext context, AppTranslations translations) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              translations.translate('appearance'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(translations.translate('darkMode')),
              subtitle: Text(translations.translate('enableDarkTheme')),
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
            ),
            ListTile(
              title: Text(translations.translate('language')),
              subtitle: Text(languageProvider.getLanguageName(
                languageProvider.currentLocale.languageCode,
              )),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showLanguageDialog(context, languageProvider),
            ),
          ],
        ),
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

  String _getSensitivityLabel(double value, AppTranslations translations) {
    if (value <= 0.2) return translations.translate('veryLow');
    if (value <= 0.4) return translations.translate('low');
    if (value <= 0.6) return translations.translate('medium');
    if (value <= 0.8) return translations.translate('high');
    return translations.translate('veryHigh');
  }

  void _showLanguageDialog(
      BuildContext context, LanguageProvider languageProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppTranslations.of(context).translate('language')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLanguageOption(
                    context, 'English', 'en', languageProvider),
                _buildLanguageOption(
                    context, 'Spanish', 'es', languageProvider),
                _buildLanguageOption(context, 'French', 'fr', languageProvider),
                _buildLanguageOption(context, 'German', 'de', languageProvider),
                _buildLanguageOption(
                    context, 'Chinese', 'zh', languageProvider),
                _buildLanguageOption(
                    context, 'Turkish', 'tr', languageProvider),
                _buildLanguageOption(
                    context, 'Persian', 'fa', languageProvider),
                _buildLanguageOption(context, 'Arabic', 'ar', languageProvider),
                _buildLanguageOption(
                    context, 'Japanese', 'ja', languageProvider),
                _buildLanguageOption(context, 'Korean', 'ko', languageProvider),
                _buildLanguageOption(
                    context, 'Russian', 'ru', languageProvider),
                _buildLanguageOption(
                    context, 'Italian', 'it', languageProvider),
                _buildLanguageOption(
                    context, 'Portuguese', 'pt', languageProvider),
                _buildLanguageOption(context, 'Dutch', 'nl', languageProvider),
                _buildLanguageOption(context, 'Hindi', 'hi', languageProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String languageName,
    String languageCode,
    LanguageProvider languageProvider,
  ) {
    return ListTile(
      title: Text(languageName),
      trailing: languageProvider.currentLocale.languageCode == languageCode
          ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
          : null,
      onTap: () {
        languageProvider.setLanguage(languageCode);
        Navigator.pop(context);
      },
    );
  }

  void _showPasswordStrengthDialog() {
    final translations = AppTranslations.of(context);
    String password = '';
    String strength = '';
    Color strengthColor = Colors.grey;
    String suggestion = '';

    void updateStrength(String value) {
      password = value;
      final result = _calculatePasswordStrength(password);
      strength = result['label'] as String;
      strengthColor = result['color'] as Color;
      suggestion = result['suggestion'] as String;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.password,
                      color: Theme.of(context).colorScheme.primary),
                  SizedBox(width: 8),
                  Text(translations.translate('passwordStrength')),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: translations.translate('enterPassword'),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        updateStrength(value);
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  if (password.isNotEmpty) ...[
                    Row(
                      children: [
                        Text(translations.translate('strength') + ': ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(translations.translate(strength.toLowerCase()),
                            style: TextStyle(
                                color: strengthColor,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: _strengthValue(strength),
                      color: strengthColor,
                      backgroundColor: strengthColor.withOpacity(0.2),
                    ),
                    SizedBox(height: 8),
                    Text(translations.translate(suggestion),
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[700])),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(translations.translate('close')),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Map<String, Object> _calculatePasswordStrength(String password) {
    int score = 0;
    String suggestion = '';
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

    if (password.length < 8) {
      suggestion = 'useAtLeast8Chars';
    } else if (!RegExp(r'[A-Z]').hasMatch(password)) {
      suggestion = 'addUppercaseLetters';
    } else if (!RegExp(r'[a-z]').hasMatch(password)) {
      suggestion = 'addLowercaseLetters';
    } else if (!RegExp(r'[0-9]').hasMatch(password)) {
      suggestion = 'addNumbers';
    } else if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) {
      suggestion = 'addSpecialChars';
    } else {
      suggestion = 'greatPassword';
    }

    if (score <= 2) {
      return {'label': 'weak', 'color': Colors.red, 'suggestion': suggestion};
    } else if (score == 3 || score == 4) {
      return {
        'label': 'medium',
        'color': Colors.orange,
        'suggestion': suggestion
      };
    } else {
      return {
        'label': 'strong',
        'color': Colors.green,
        'suggestion': suggestion
      };
    }
  }

  double _strengthValue(String label) {
    switch (label) {
      case 'weak':
        return 0.33;
      case 'medium':
        return 0.66;
      case 'strong':
        return 1.0;
      default:
        return 0.0;
    }
  }

  void _inviteFriends() {
    final translations = AppTranslations.of(context);
    final inviteLink = 'https://yourapp.link';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.group_add,
                  color: Theme.of(context).colorScheme.primary),
              SizedBox(width: 8),
              Text(translations.translate('inviteFriends')),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(translations.translate('shareAppWithFriends')),
              SizedBox(height: 16),
              SelectableText(inviteLink,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
              SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.copy),
                label: Text(translations.translate('copyLink')),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: inviteLink));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(translations.translate('linkCopied'))),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(translations.translate('close')),
            ),
          ],
        );
      },
    );
  }

  void _showFaqDialog() {
    final translations = AppTranslations.of(context);
    final faqs = [
      {'question': 'whatIsPhishing', 'answer': 'whatIsPhishingAnswer'},
      {
        'question': 'recognizePhishingEmail',
        'answer': 'recognizePhishingEmailAnswer'
      },
      {
        'question': 'suspiciousEmailAction',
        'answer': 'suspiciousEmailActionAnswer'
      },
      {
        'question': 'passwordStrengthChecker',
        'answer': 'passwordStrengthCheckerAnswer'
      },
      {'question': 'tip1Title', 'answer': 'strongPasswordGuide'},
      {'question': 'tip2Title', 'answer': 'twoFactorAuthGuide'},
      {'question': 'tip3Title', 'answer': 'emailVerificationGuide'},
      {'question': 'tip4Title', 'answer': 'softwareUpdateGuide'},
      {'question': 'tip5Title', 'answer': 'safeLinkHandlingGuide'},
      {'question': 'tip6Title', 'answer': 'networkSecurityGuide'},
      {'question': 'tip7Title', 'answer': 'securityAuditGuide'},
      {'question': 'tip8Title', 'answer': 'dataBackupGuide'},
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.help_outline,
                  color: Theme.of(context).colorScheme.primary),
              SizedBox(width: 8),
              Text(translations.translate('faqHelp')),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: faqs.length,
              separatorBuilder: (_, __) => Divider(),
              itemBuilder: (context, index) {
                final faq = faqs[index];
                return ListTile(
                  title: Text(translations.translate(faq['question'] ?? '')),
                  subtitle: Text(translations.translate(faq['answer'] ?? '')),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(translations.translate('close')),
            ),
          ],
        );
      },
    );
  }
}
