import 'package:flutter/material.dart'; // Flutter ana paketi içe aktarılıyor
import 'package:fl_chart/fl_chart.dart'; // fl_chart paketi içe aktarılıyor
import '../l10n/app_translations.dart'; // Uygulama çeviri dosyası içe aktarılıyor

class DashboardScreen extends StatefulWidget {
  // DashboardScreen sınıfı başlatılıyor, StatefulWidget'tan türetiliyor
  const DashboardScreen(
      {super.key}); // Yapıcı fonksiyon, anahtar parametresi ile

  @override // createState fonksiyonu override ediliyor
  State<DashboardScreen> createState() =>
      _DashboardScreenState(); // State oluşturuluyor
} // DashboardScreen sınıfı bitiyor

class _DashboardScreenState extends State<DashboardScreen> {
  // _DashboardScreenState sınıfı başlatılıyor
  @override // build fonksiyonu override ediliyor
  Widget build(BuildContext context) {
    // build fonksiyonu başlatılıyor
    final translations = AppTranslations.of(context); // Çeviri nesnesi alınıyor

    // Example emails for risk distribution calculation // Risk dağılımı için örnek e-postalar
    final exampleEmails = [
      // exampleEmails listesi başlatılıyor
      {
        'sender': 'support@secure-paypal.com', // Gönderen
        'subject': 'Urgent: Your Account Has Been Suspended', // Konu
        'body':
            '''Dear Customer,\n\nWe have detected unusual activity in your PayPal account. Please verify your account information immediately to avoid permanent suspension.\n\nClick here to verify: http://bit.ly/paypal-verify\n\nIf you do not respond within 24 hours, your account will be permanently locked.\n\nThank you,\nPayPal Security Team''', // Gövde
      }, // İlk e-posta bitiyor

      {
        'sender': 'it-support@company-security.com', // Gönderen
        'subject': 'Action Required: Password Expiry Notification', // Konu
        'body':
            '''Dear User,\n\nYour password is set to expire today. Please click the link below to reset your password and avoid losing access to your account.\n\nReset Password: http://tinyurl.com/reset-now\n\nIf you do not act now, your account will be deactivated.\n\nBest regards,\nIT Support''', // Gövde
      },
      {
        'sender': 'hr@yourcompany.com', // Gönderen
        'subject': 'Welcome to the Team!', // Konu
        'body':
            '''Hi John,\n\nWelcome to the company! We're excited to have you on board. Please let us know if you have any questions.\n\nBest,\nHR Team''', // Gövde
      },
      {
        'sender': 'info@apple-support.com', // Gönderen
        'subject': 'Security Alert: Unusual Login Attempt', // Konu
        'body':
            '''Dear Apple User,\n\nWe noticed an unusual login attempt to your Apple account. Please confirm your identity by providing your password and security questions.\n\nConfirm here: http://apple-login-security.com/verify\n\nIf you do not respond, your account will be suspended.\n\nApple Support''', // Gövde
      },
      {
        'sender': 'noreply@github.com', // Gönderen
        'subject': '[GitHub] Please verify your email address', // Konu
        'body':
            '''Hi there,\n\nPlease verify your email address by clicking the link below:\n\nhttps://github.com/users/verify\n\nIf you did not sign up for this account, you can ignore this email.\n\nThanks,\nThe GitHub Team''', // Gövde
      },
    ]; // exampleEmails listesi bitiyor

    // Risk calculation logic (copied from EmailAnalyzer) // Risk hesaplama mantığı
    int getRiskScore(Map<String, dynamic> details) {
      // getRiskScore fonksiyonu başlatılıyor
      int riskScore = 0; // riskScore değişkeni başlatılıyor
      if (details['urgent_language'] == true)
        riskScore += 2; // Acil dil varsa risk artırılıyor
      if (details['poor_grammar'] == true)
        riskScore += 1; // Kötü dilbilgisi varsa risk artırılıyor
      if (details['generic_greeting'] == true)
        riskScore += 1; // Genel selamlama varsa risk artırılıyor
      if (details['mismatched_urls'] == true)
        riskScore += 3; // Eşleşmeyen URL varsa risk artırılıyor
      if (details['links'] != null) {
        // Linkler varsa
        final links = details['links'] as List; // links listesi alınıyor
        riskScore +=
            links.where((link) => link['is_suspicious'] == true).length *
                2; // Şüpheli linkler için risk artırılıyor
      }
      return riskScore; // riskScore döndürülüyor
    } // getRiskScore fonksiyonu bitiyor

    String getRiskLevel(Map<String, dynamic> details) {
      // getRiskLevel fonksiyonu başlatılıyor
      final riskScore = getRiskScore(details); // riskScore hesaplanıyor
      if (riskScore >= 5) return 'high'; // Yüksek risk
      if (riskScore >= 2) return 'medium'; // Orta risk
      return 'low'; // Düşük risk
    } // getRiskLevel fonksiyonu bitiyor

    // Simple local analyzer for dashboard (matches EmailAnalyzer logic) // Basit yerel analizci
    Map<String, dynamic> analyzeEmail(
        {required String subject,
        required String body,
        required String sender}) {
      // analyzeEmail fonksiyonu başlatılıyor
      Map<String, dynamic> details = {}; // details haritası başlatılıyor
      // Urgent language // Acil dil kontrolü
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
      ]; // urgentWords listesi bitiyor
      if (urgentWords.any((word) =>
          subject.toLowerCase().contains(word) ||
          body.toLowerCase().contains(word))) {
        details['urgent_language'] = true; // Acil dil bulundu
      }
      // Suspicious links // Şüpheli linkler kontrolü
      final urlRegex = RegExp(
          r'https?://(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
          caseSensitive: false); // URL regex
      final links = urlRegex
          .allMatches(body)
          .map((m) => m.group(0)!)
          .toList(); // Linkler çıkarılıyor
      if (links.isNotEmpty) {
        List<Map<String, dynamic>> linkAnalysis =
            []; // linkAnalysis listesi başlatılıyor
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
        ]; // suspiciousDomains listesi bitiyor
        for (final link in links) {
          bool isSuspicious = suspiciousDomains.any((domain) =>
              link.toLowerCase().contains(domain)); // Şüpheli domain kontrolü
          linkAnalysis.add({
            'url': link,
            'is_suspicious': isSuspicious,
            'reason': isSuspicious ? 'Suspicious domain detected' : ''
          }); // linkAnalysis elemanı ekleniyor
        }
        details['links'] = linkAnalysis; // linkAnalysis details'a ekleniyor
      }
      // Poor grammar // Kötü dilbilgisi kontrolü
      final grammarMistakes = [
        'your account is been',
        'your account has been',
      ]; // grammarMistakes listesi bitiyor
      if (grammarMistakes.any((m) => body.toLowerCase().contains(m))) {
        details['poor_grammar'] = true; // Kötü dilbilgisi bulundu
      }
      // Generic greeting // Genel selamlama kontrolü
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
      ]; // genericGreetings listesi bitiyor
      if (genericGreetings.any((g) => body.toLowerCase().contains(g))) {
        details['generic_greeting'] = true; // Genel selamlama bulundu
      }
      // Mismatched URLs (not implemented in dashboard for simplicity) // Eşleşmeyen URL'ler (basitlik için eklenmedi)
      // ...
      return details; // details döndürülüyor
    } // analyzeEmail fonksiyonu bitiyor

    // Calculate risk distribution from example emails // Örnek e-postalardan risk dağılımı hesaplanıyor
    int high = 0, medium = 0, low = 0; // Risk seviyeleri başlatılıyor
    for (final email in exampleEmails) {
      // Her e-posta için
      final details = analyzeEmail(
          subject: email['subject']!,
          body: email['body']!,
          sender: email['sender']!); // E-posta analiz ediliyor
      final level = getRiskLevel(details); // Risk seviyesi alınıyor
      if (level == 'high')
        high++; // Yüksek riskli ise artır
      else if (level == 'medium')
        medium++; // Orta riskli ise artır
      else
        low++; // Düşük riskli ise artır
    } // for döngüsü bitiyor

    return Scaffold(
      // Scaffold widget'ı başlatılıyor
      appBar: AppBar(
        // AppBar başlatılıyor
        title: Text(translations.translate('dashboard')), // Başlık ayarlanıyor
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          )
        ], // Ayarlar butonu
      ), // AppBar bitiyor
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _buildRiskSummary(
                context, translations, high, medium, low), // Risk özeti
            const SizedBox(height: 24), // Boşluk
            _buildQuickActions(context, translations), // Hızlı aksiyonlar
            const SizedBox(height: 24), // Boşluk
            Text(translations.translate('securityTips'),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge), // Security tips title
            const SizedBox(height: 16), // Spacing
            _buildSecurityTip(
                context,
                translations.translate('tip1Title'),
                translations.translate('tip1Content'),
                Icons.lock,
                translations), // Tip 1
            const SizedBox(height: 8), // Spacing
            _buildSecurityTip(
                context,
                translations.translate('tip2Title'),
                translations.translate('tip2Content'),
                Icons.security,
                translations), // Tip 2
            const SizedBox(height: 8), // Spacing
            _buildSecurityTip(
                context,
                translations.translate('tip3Title'),
                translations.translate('tip3Content'),
                Icons.mark_email_read,
                translations), // Tip 3
            const SizedBox(height: 8), // Spacing
            _buildSecurityTip(
                context,
                translations.translate('tip4Title'),
                translations.translate('tip4Content'),
                Icons.system_update,
                translations), // Tip 4
            const SizedBox(height: 8), // Spacing
            _buildSecurityTip(
                context,
                translations.translate('tip5Title'),
                translations.translate('tip5Content'),
                Icons.link,
                translations), // Tip 5
            const SizedBox(height: 8), // Spacing
            _buildSecurityTip(
                context,
                translations.translate('tip6Title'),
                translations.translate('tip6Content'),
                Icons.wifi_lock,
                translations), // Tip 6
            const SizedBox(height: 8), // Spacing
            _buildSecurityTip(
                context,
                translations.translate('tip7Title'),
                translations.translate('tip7Content'),
                Icons.security_update,
                translations), // Tip 7
            const SizedBox(height: 8), // Spacing
            _buildSecurityTip(
                context,
                translations.translate('tip8Title'),
                translations.translate('tip8Content'),
                Icons.backup,
                translations), // Tip 8
          ])), // SingleChildScrollView ve Column bitiyor
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.dashboard),
                label:
                    translations.translate('dashboard')), // Dashboard sekmesi
            BottomNavigationBarItem(
                icon: const Icon(Icons.search),
                label: translations.translate('analyze')), // Analiz sekmesi
            BottomNavigationBarItem(
                icon: const Icon(Icons.school),
                label: translations.translate('learn')), // Eğitim sekmesi
          ],
          onTap: (index) {
            switch (index) {
              case 1:
                Navigator.pushNamed(context, '/analysis');
                break;
              case 2:
                Navigator.pushNamed(context, '/education');
                break;
            }
          }), // Alt gezinme çubuğu
    ); // Scaffold bitiyor
  } // build fonksiyonu bitiyor

  Widget _buildRiskSummary(BuildContext context, AppTranslations translations,
      int high, int medium, int low) {
    // Risk özeti widget'ı başlatılıyor
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(translations.translate('riskDistribution'),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge), // Risk dağılımı başlığı
              const SizedBox(height: 24), // Boşluk
              SizedBox(
                  height: 130,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                            child: _buildRiskItem(
                                context,
                                translations.translate('highRisk'),
                                high.toString(),
                                Colors.red)), // Yüksek risk
                        Expanded(
                            child: _buildRiskItem(
                                context,
                                translations.translate('mediumRisk'),
                                medium.toString(),
                                Colors.orange)), // Orta risk
                        Expanded(
                            child: _buildRiskItem(
                                context,
                                translations.translate('lowRisk'),
                                low.toString(),
                                Colors.green)), // Düşük risk
                      ])), // Row ve SizedBox bitiyor
            ]))); // Card, Padding ve Column bitiyor
  } // _buildRiskSummary fonksiyonu bitiyor

  Widget _buildRiskItem(
      BuildContext context, String label, String count, Color color) {
    // Risk öğesi widget'ı başlatılıyor
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: color.withOpacity(0.3),
                      width: 2))), // Daire ve kenar
          const SizedBox(height: 12), // Boşluk
          SizedBox(
              height: 40,
              child: Center(
                  child: Text(label,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w500)))), // Etiket
        ]); // Column bitiyor
  } // _buildRiskItem fonksiyonu bitiyor

  Widget _buildQuickActions(
      BuildContext context, AppTranslations translations) {
    // Hızlı aksiyonlar widget'ı başlatılıyor
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(translations.translate('quickActions'),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge), // Hızlı aksiyonlar başlığı
              const SizedBox(height: 16), // Boşluk
              Row(children: [
                Expanded(
                    child: _buildActionButton(
                        context,
                        translations.translate('analyzeEmail'),
                        Icons.email,
                        () => Navigator.pushNamed(context, '/analysis')))
              ]), // Analiz butonu
              const SizedBox(height: 16), // Boşluk
              Row(children: [
                Expanded(
                    child: _buildActionButton(
                        context,
                        translations.translate('chatAssistant'),
                        Icons.chat,
                        () => Navigator.pushNamed(
                            context, '/chat'))), // Sohbet butonu
                const SizedBox(width: 16), // Boşluk
                Expanded(
                    child: _buildActionButton(
                        context,
                        translations.translate('phishingSimulator'),
                        Icons.science,
                        () => Navigator.pushNamed(
                            context, '/simulator'))), // Simülatör butonu
              ]), // Row bitiyor
            ]))); // Card, Padding ve Column bitiyor
  } // _buildQuickActions fonksiyonu bitiyor

  Widget _buildActionButton(
      BuildContext context, String label, IconData icon, VoidCallback onTap) {
    // Aksiyon butonu widget'ı başlatılıyor
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium)
          ],
        ),
      ),
    ); // InkWell, Container ve Column bitiyor
  } // _buildActionButton fonksiyonu bitiyor

  Widget _buildSecurityTip(BuildContext context, String title, String content,
      IconData icon, AppTranslations translations) {
    // Güvenlik ipucu widget'ı başlatılıyor
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading:
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
        title: Text(title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child:
                Text(content, style: Theme.of(context).textTheme.bodyMedium)),
        trailing: Icon(Icons.arrow_forward_ios,
            size: 16, color: Theme.of(context).colorScheme.primary),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Row(children: [
                Icon(icon,
                    color: Theme.of(context).colorScheme.primary, size: 28),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(title,
                        style: Theme.of(context).textTheme.titleLarge)),
              ]),
              content:
                  Text(content, style: Theme.of(context).textTheme.bodyLarge),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(translations.translate('close'),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary))),
              ],
            ),
          );
        },
      ),
    ); // Card ve ListTile bitiyor
  } // _buildSecurityTip fonksiyonu bitiyor
} // _DashboardScreenState sınıfı bitiyor
