import 'package:flutter/material.dart';

class PhishingSimulatorScreen extends StatefulWidget {
  const PhishingSimulatorScreen({super.key});

  @override
  State<PhishingSimulatorScreen> createState() =>
      _PhishingSimulatorScreenState();
}

class _PhishingSimulatorScreenState extends State<PhishingSimulatorScreen> {
  final List<Map<String, dynamic>> _simulations = [
    {
      'sender': 'support@secure-paypal.com',
      'subject': 'Urgent: Your Account Has Been Suspended',
      'body':
          '''Dear Customer,\n\nWe have detected unusual activity in your PayPal account. Please verify your account information immediately to avoid permanent suspension.\n\nClick here to verify: http://bit.ly/paypal-verify\n\nIf you do not respond within 24 hours, your account will be permanently locked.\n\nThank you,\nPayPal Security Team''',
      'isPhishing': true,
      'explanation':
          'This email uses urgent language, a suspicious link, and requests personal information. These are common phishing tactics.'
    },
    {
      'sender': 'hr@yourcompany.com',
      'subject': 'Welcome to the Team!',
      'body':
          '''Hi John,\n\nWelcome to the company! We're excited to have you on board. Please let us know if you have any questions.\n\nBest,\nHR Team''',
      'isPhishing': false,
      'explanation':
          'This is a typical welcome email from HR. There are no suspicious elements.'
    },
    {
      'sender': 'security@bankofamerica.com',
      'subject': 'Account Locked: Immediate Action Required',
      'body':
          '''Dear Customer,\n\nYour Bank of America account has been locked due to suspicious activity. Please login here to restore access: http://bofa-security-alert.com\n\nIf you do not act within 48 hours, your account will be permanently closed.''',
      'isPhishing': true,
      'explanation':
          'The sender address is suspicious, the link is not an official bank domain, and the message uses urgency.'
    },
    {
      'sender': 'noreply@github.com',
      'subject': '[GitHub] Please verify your email address',
      'body':
          '''Hi there,\n\nPlease verify your email address by clicking the link below:\n\nhttps://github.com/users/verify\n\nIf you did not sign up for this account, you can ignore this email.\n\nThanks,\nThe GitHub Team''',
      'isPhishing': false,
      'explanation': 'This is a legitimate verification email from GitHub.'
    },
    {
      'sender': 'appleid@apple.com',
      'subject': 'Your Apple ID has been used to sign in',
      'body':
          '''Dear User,\n\nYour Apple ID was used to sign in to iCloud via a web browser. If this was you, you can safely disregard this email. If not, please reset your password immediately at https://appleid.apple.com.''',
      'isPhishing': false,
      'explanation':
          'This is a standard Apple security notification with a legitimate link.'
    },
    {
      'sender': 'it-support@company-security.com',
      'subject': 'Action Required: Password Expiry Notification',
      'body':
          '''Dear User,\n\nYour password is set to expire today. Please click the link below to reset your password and avoid losing access to your account.\n\nReset Password: http://tinyurl.com/reset-now\n\nIf you do not act now, your account will be deactivated.\n\nBest regards,\nIT Support''',
      'isPhishing': true,
      'explanation':
          'The link is a URL shortener, and the message uses urgency and generic greeting.'
    },
  ];

  int _currentIndex = 0;
  bool? _userAnsweredPhishing;
  bool _showFeedback = false;

  void _answer(bool isPhishing) {
    setState(() {
      _userAnsweredPhishing = isPhishing;
      _showFeedback = true;
    });
  }

  void _nextSimulation() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _simulations.length;
      _userAnsweredPhishing = null;
      _showFeedback = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sim = _simulations[_currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phishing Simulator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('From: ${sim['sender']}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Subject: ${sim['subject']}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Divider(height: 24),
                      Text(sim['body'], style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (!_showFeedback) ...[
                ElevatedButton.icon(
                  icon: const Icon(Icons.warning, color: Colors.white),
                  label: const Text('Phishing'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 48),
                  ),
                  onPressed: () => _answer(true),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.verified_user, color: Colors.white),
                  label: const Text('Legitimate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 48),
                  ),
                  onPressed: () => _answer(false),
                ),
              ] else ...[
                Icon(
                  (_userAnsweredPhishing == sim['isPhishing'])
                      ? Icons.check_circle
                      : Icons.cancel,
                  color: (_userAnsweredPhishing == sim['isPhishing'])
                      ? Colors.green
                      : Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  (_userAnsweredPhishing == sim['isPhishing'])
                      ? 'Correct!'
                      : 'Incorrect.',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: (_userAnsweredPhishing == sim['isPhishing'])
                        ? Colors.green
                        : Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  sim['explanation'],
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Another'),
                  onPressed: _nextSimulation,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
