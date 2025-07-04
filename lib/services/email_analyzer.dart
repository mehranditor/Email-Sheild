import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AnalysisResult {
  final String riskLevel;
  final List<String> warnings;
  final Map<String, dynamic> details;

  AnalysisResult({
    required this.riskLevel,
    required this.warnings,
    required this.details,
  });
}

class EmailAnalyzer {
  // Risk levels
  static const String HIGH_RISK = 'high';
  static const String MEDIUM_RISK = 'medium';
  static const String LOW_RISK = 'low';

  // Analyze email content
  Future<AnalysisResult> analyzeEmail({
    required String subject,
    required String body,
    required String sender,
  }) async {
    List<String> warnings = [];
    Map<String, dynamic> details = {};

    // Check for urgent language
    if (_containsUrgentLanguage(subject) || _containsUrgentLanguage(body)) {
      warnings.add('Email contains urgent language');
      details['urgent_language'] = true;
    }

    // Check for suspicious links
    List<String> links = _extractLinks(body);
    if (links.isNotEmpty) {
      List<Map<String, dynamic>> linkAnalysis = await _analyzeLinks(links);
      details['links'] = linkAnalysis;

      for (var link in linkAnalysis) {
        if (link['is_suspicious']) {
          warnings.add('Suspicious link detected: ${link['url']}');
        }
      }
    }

    // Check for poor grammar
    if (_hasPoorGrammar(body)) {
      warnings.add('Email contains poor grammar or spelling mistakes');
      details['poor_grammar'] = true;
    }

    // Check for generic greetings
    if (_hasGenericGreeting(body)) {
      warnings.add('Email uses generic greeting');
      details['generic_greeting'] = true;
    }

    // Check for mismatched URLs
    if (_hasMismatchedUrls(body)) {
      warnings.add('Email contains mismatched URLs');
      details['mismatched_urls'] = true;
    }

    // Determine risk level
    String riskLevel = _determineRiskLevel(warnings, details);

    // Calculate risk score for display
    int riskScore = 0;
    if (details['urgent_language'] == true) riskScore += 2;
    if (details['poor_grammar'] == true) riskScore += 1;
    if (details['generic_greeting'] == true) riskScore += 1;
    if (details['mismatched_urls'] == true) riskScore += 3;
    if (details['links'] != null) {
      final links = details['links'] as List;
      riskScore +=
          links.where((link) => link['is_suspicious'] == true).length * 2;
    }
    details['riskScore'] = riskScore;

    return AnalysisResult(
      riskLevel: riskLevel,
      warnings: warnings,
      details: details,
    );
  }

  bool _containsUrgentLanguage(String text) {
    final urgentWords = [
      'urgent',
      'immediate',
      'action required',
      'verify now',
      'account suspended',
      'security alert',
      'verify your account',
      'unusual activity',
      'suspicious login',
      'verify your identity',
    ];

    return urgentWords
        .any((word) => text.toLowerCase().contains(word.toLowerCase()));
  }

  List<String> _extractLinks(String text) {
    final urlRegex = RegExp(
      r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
      caseSensitive: false,
    );

    return urlRegex.allMatches(text).map((match) => match.group(0)!).toList();
  }

  Future<List<Map<String, dynamic>>> _analyzeLinks(List<String> links) async {
    List<Map<String, dynamic>> results = [];

    for (String link in links) {
      bool isSuspicious = false;
      String reason = '';

      // Check for common phishing domains
      if (_isSuspiciousDomain(link)) {
        isSuspicious = true;
        reason = 'Suspicious domain detected';
      }

      // Check for mismatched URLs
      if (_hasMismatchedUrl(link)) {
        isSuspicious = true;
        reason = 'URL appears to be mismatched';
      }

      // Check for shortened URLs
      if (_isShortenedUrl(link)) {
        isSuspicious = true;
        reason = 'URL is shortened';
      }

      results.add({
        'url': link,
        'is_suspicious': isSuspicious,
        'reason': reason,
      });
    }

    return results;
  }

  bool _isSuspiciousDomain(String url) {
    final suspiciousDomains = [
      'bit.ly',
      'tinyurl.com',
      'goo.gl',
      't.co',
      'is.gd',
      'cli.gs',
      'ow.ly',
      'yfrog.com',
      'migre.me',
      'ff.im',
      'tiny.cc',
      'url4.eu',
      'tr.im',
      'twit.ac',
      'su.pr',
      'twurl.nl',
      'snipurl.com',
      'short.to',
      'BudURL.com',
      'ping.fm',
      'post.ly',
      'Just.as',
      'bkite.com',
      'snipr.com',
      'fic.kr',
      'loopt.us',
      'htxt.it',
      'AltURL.com',
      'redir.ec',
      'u.mavrev.com',
      'kl.am',
      'wp.me',
      'u.nu',
      'rubyurl.com',
      'om.ly',
      'to.ly',
      'bit.do',
      't.co',
      'lnkd.in',
      'db.tt',
      'qr.ae',
      'adf.ly',
      'goo.gl',
      'bitly.com',
      'cur.lv',
      'tinyurl.com',
      'ow.ly',
      'bit.ly',
      'adcrun.ch',
      'ity.im',
      'q.gs',
      'is.gd',
      'po.st',
      'bc.vc',
      'twitthis.com',
      'ht.ly',
      'u.bb',
      'yourls.org',
      'x.co',
      'prettylinkpro.com',
      'viralurl.biz',
      'adcrun.ch',
      'qr.net',
      '1url.com',
      'tweez.me',
      'v.gd',
      'tr.im',
      'link.zip.net',
    ];

    try {
      final uri = Uri.parse(url);
      return suspiciousDomains.any(
          (domain) => uri.host.toLowerCase().contains(domain.toLowerCase()));
    } catch (e) {
      return true; // If URL parsing fails, consider it suspicious
    }
  }

  bool _hasMismatchedUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final host = uri.host.toLowerCase();

      // Check if the URL appears to be from a well-known service
      final commonServices = [
        'google.com',
        'microsoft.com',
        'apple.com',
        'amazon.com',
        'facebook.com',
        'twitter.com',
        'linkedin.com',
        'paypal.com',
        'bankofamerica.com',
        'wellsfargo.com',
        'chase.com',
      ];

      // If the URL contains a common service name but the domain doesn't match
      return commonServices.any((service) =>
          url.toLowerCase().contains(service) && !host.contains(service));
    } catch (e) {
      return true; // If URL parsing fails, consider it suspicious
    }
  }

  bool _isShortenedUrl(String url) {
    final shortenedServices = [
      'bit.ly',
      'tinyurl.com',
      'goo.gl',
      't.co',
      'is.gd',
      'cli.gs',
      'ow.ly',
      'yfrog.com',
      'migre.me',
      'ff.im',
      'tiny.cc',
      'url4.eu',
      'tr.im',
      'twit.ac',
      'su.pr',
      'twurl.nl',
      'snipurl.com',
      'short.to',
      'BudURL.com',
      'ping.fm',
      'post.ly',
      'Just.as',
      'bkite.com',
      'snipr.com',
      'fic.kr',
      'loopt.us',
      'htxt.it',
      'AltURL.com',
      'redir.ec',
      'u.mavrev.com',
      'kl.am',
      'wp.me',
      'u.nu',
      'rubyurl.com',
      'om.ly',
      'to.ly',
      'bit.do',
      't.co',
      'lnkd.in',
      'db.tt',
      'qr.ae',
      'adf.ly',
      'goo.gl',
      'bitly.com',
      'cur.lv',
      'tinyurl.com',
      'ow.ly',
      'bit.ly',
      'adcrun.ch',
      'ity.im',
      'q.gs',
      'is.gd',
      'po.st',
      'bc.vc',
      'twitthis.com',
      'ht.ly',
      'u.bb',
      'yourls.org',
      'x.co',
      'prettylinkpro.com',
      'viralurl.biz',
      'adcrun.ch',
      'qr.net',
      '1url.com',
      'tweez.me',
      'v.gd',
      'tr.im',
      'link.zip.net',
    ];

    try {
      final uri = Uri.parse(url);
      return shortenedServices.any(
          (service) => uri.host.toLowerCase().contains(service.toLowerCase()));
    } catch (e) {
      return true; // If URL parsing fails, consider it suspicious
    }
  }

  bool _hasPoorGrammar(String text) {
    // Simple check for common grammar mistakes
    final grammarMistakes = [
      'your account is been',
      'your account has been',
      'your account is been',
      'your account is been',
      'your account is been',
      'your account is been',
      'your account is been',
      'your account is been',
      'your account is been',
      'your account is been',
    ];

    return grammarMistakes
        .any((mistake) => text.toLowerCase().contains(mistake.toLowerCase()));
  }

  bool _hasGenericGreeting(String text) {
    final genericGreetings = [
      'dear user',
      'dear customer',
      'dear sir',
      'dear madam',
      'dear sir/madam',
      'dear valued customer',
      'dear account holder',
      'dear member',
      'dear friend',
      'dear colleague',
    ];

    return genericGreetings
        .any((greeting) => text.toLowerCase().contains(greeting.toLowerCase()));
  }

  bool _hasMismatchedUrls(String text) {
    final urlRegex = RegExp(
      r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
      caseSensitive: false,
    );

    final matches = urlRegex.allMatches(text);
    if (matches.length < 2) return false;

    final urls = matches.map((match) => match.group(0)!).toList();
    for (int i = 0; i < urls.length - 1; i++) {
      if (_hasMismatchedUrl(urls[i])) return true;
    }

    return false;
  }

  String _determineRiskLevel(
      List<String> warnings, Map<String, dynamic> details) {
    int riskScore = 0;

    // Calculate risk score based on warnings and details
    if (details['urgent_language'] == true) riskScore += 2;
    if (details['poor_grammar'] == true) riskScore += 1;
    if (details['generic_greeting'] == true) riskScore += 1;
    if (details['mismatched_urls'] == true) riskScore += 3;

    // Check for suspicious links
    if (details['links'] != null) {
      final links = details['links'] as List;
      riskScore +=
          links.where((link) => link['is_suspicious'] == true).length * 2;
    }

    // Determine risk level based on score
    if (riskScore >= 5) return HIGH_RISK;
    if (riskScore >= 2) return MEDIUM_RISK;
    return LOW_RISK;
  }
}
