import 'package:flutter/material.dart';
import '../services/email_analyzer.dart';

class EmailAnalysisScreen extends StatefulWidget {
  const EmailAnalysisScreen({super.key});

  @override
  State<EmailAnalysisScreen> createState() => _EmailAnalysisScreenState();
}

class _EmailAnalysisScreenState extends State<EmailAnalysisScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  final _senderController = TextEditingController();
  final _emailAnalyzer = EmailAnalyzer();

  AnalysisResult? _analysisResult;
  bool _isAnalyzing = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _bodyController.dispose();
    _senderController.dispose();
    super.dispose();
  }

  Future<void> _analyzeEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isAnalyzing = true;
      _analysisResult = null;
    });

    try {
      final result = await _emailAnalyzer.analyzeEmail(
        subject: _subjectController.text,
        body: _bodyController.text,
        sender: _senderController.text,
      );

      setState(() {
        _analysisResult = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error analyzing email: $e')),
      );
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  Color _getRiskLevelColor(String riskLevel) {
    switch (riskLevel) {
      case EmailAnalyzer.HIGH_RISK:
        return Colors.red;
      case EmailAnalyzer.MEDIUM_RISK:
        return Colors.orange;
      case EmailAnalyzer.LOW_RISK:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final exampleEmails = [
      {
        'label': ' PayPal Account Suspended',
        'sender': 'support@secure-paypal.com',
        'subject': 'Urgent: Your Account Has Been Suspended',
        'body':
            '''Dear Customer,\n\nWe have detected unusual activity in your PayPal account. Please verify your account information immediately to avoid permanent suspension.\n\nClick here to verify: http://bit.ly/paypal-verify\n\nIf you do not respond within 24 hours, your account will be permanently locked.\n\nThank you,\nPayPal Security Team''',
      },
      {
        'label': ' Password Expiry Notification',
        'sender': 'it-support@company-security.com',
        'subject': 'Action Required: Password Expiry Notification',
        'body':
            '''Dear User,\n\nYour password is set to expire today. Please click the link below to reset your password and avoid losing access to your account.\n\nReset Password: http://tinyurl.com/reset-now\n\nIf you do not act now, your account will be deactivated.\n\nBest regards,\nIT Support''',
      },
      {
        'label': ' Welcome to the Team',
        'sender': 'hr@yourcompany.com',
        'subject': 'Welcome to the Team!',
        'body':
            '''Hi John,\n\nWelcome to the company! We're excited to have you on board. Please let us know if you have any questions.\n\nBest,\nHR Team''',
      },
      {
        'label': ' Apple Security Alert',
        'sender': 'info@apple-support.com',
        'subject': 'Security Alert: Unusual Login Attempt',
        'body':
            '''Dear Apple User,\n\nWe noticed an unusual login attempt to your Apple account. Please confirm your identity by providing your password and security questions.\n\nConfirm here: http://apple-login-security.com/verify\n\nIf you do not respond, your account will be suspended.\n\nApple Support''',
      },
      {
        'label': ' GitHub Email Verification',
        'sender': 'noreply@github.com',
        'subject': '[GitHub] Please verify your email address',
        'body':
            '''Hi there,\n\nPlease verify your email address by clicking the link below:\n\nhttps://github.com/users/verify\n\nIf you did not sign up for this account, you can ignore this email.\n\nThanks,\nThe GitHub Team''',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Analysis'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Example emails section
              Card(
                color: Colors.blueGrey[50],
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Try Example Emails:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...exampleEmails.map((email) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.content_copy, size: 18),
                              label: Text(email['label']!),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey[100],
                                foregroundColor: Colors.black87,
                                minimumSize: const Size(0, 36),
                              ),
                              onPressed: () {
                                setState(() {
                                  _senderController.text = email['sender']!;
                                  _subjectController.text = email['subject']!;
                                  _bodyController.text = email['body']!;
                                });
                              },
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              TextFormField(
                controller: _senderController,
                decoration: const InputDecoration(
                  labelText: 'Sender Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the sender email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  labelText: 'Email Subject',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the email subject';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(
                  labelText: 'Email Body',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the email body';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isAnalyzing ? null : _analyzeEmail,
                child: _isAnalyzing
                    ? const CircularProgressIndicator()
                    : const Text('Analyze Email'),
              ),
              if (_analysisResult != null) ...[
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getRiskLevelColor(
                                    _analysisResult!.riskLevel),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                _analysisResult!.riskLevel.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_analysisResult!.riskLevel ==
                                EmailAnalyzer.HIGH_RISK ||
                            _analysisResult!.riskLevel ==
                                EmailAnalyzer.MEDIUM_RISK) ...[
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: _analysisResult!.riskLevel ==
                                      EmailAnalyzer.HIGH_RISK
                                  ? Colors.red[100]
                                  : Colors.orange[100],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _analysisResult!.riskLevel ==
                                        EmailAnalyzer.HIGH_RISK
                                    ? Colors.red
                                    : Colors.orange,
                                width: 1.5,
                              ),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: _analysisResult!.riskLevel ==
                                          EmailAnalyzer.HIGH_RISK
                                      ? Colors.red
                                      : Colors.orange,
                                  size: 28,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _analysisResult!.riskLevel ==
                                            EmailAnalyzer.HIGH_RISK
                                        ? 'Warning: This email is highly suspicious and may be a phishing attempt. Do not click any links or provide personal information.'
                                        : 'Caution: This email shows signs of being suspicious. Please review carefully before taking any action.',
                                    style: TextStyle(
                                      color: _analysisResult!.riskLevel ==
                                              EmailAnalyzer.HIGH_RISK
                                          ? Colors.red[900]
                                          : Colors.orange[900],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (_analysisResult!.warnings.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Text(
                            'Warnings:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ..._analysisResult!.warnings.map((warning) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.warning_amber_rounded,
                                      color: Colors.orange,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(warning),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                        if (_analysisResult!.details['links'] != null) ...[
                          const SizedBox(height: 16),
                          const Text(
                            'Link Analysis:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...(_analysisResult!.details['links'] as List)
                              .map((link) {
                            final isSuspicious = link['is_suspicious'] as bool;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    isSuspicious
                                        ? Icons.dangerous
                                        : Icons.check_circle,
                                    color: isSuspicious
                                        ? Colors.red
                                        : Colors.green,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          link['url'],
                                          style: TextStyle(
                                            color: isSuspicious
                                                ? Colors.red
                                                : Colors.green,
                                          ),
                                        ),
                                        if (isSuspicious)
                                          Text(
                                            link['reason'],
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 12,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
