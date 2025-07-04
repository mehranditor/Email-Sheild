import 'package:flutter/material.dart'; // Flutter ana paketi içe aktarılıyor
import 'screens/dashboard_screen.dart'; // Dashboard ekranı dosyası içe aktarılıyor
import 'screens/email_analysis_screen.dart'; // Email analiz ekranı dosyası içe aktarılıyor
import 'screens/education_screen.dart'; // Eğitim ekranı dosyası içe aktarılıyor

class PhishingDetectorApp extends StatelessWidget {
  // PhishingDetectorApp sınıfı başlatılıyor, StatelessWidget'tan türetiliyor
  const PhishingDetectorApp(
      {super.key}); // Yapıcı fonksiyon, anahtar parametresi ile

  @override // build fonksiyonu override ediliyor
  Widget build(BuildContext context) {
    // build fonksiyonu başlatılıyor
    return MaterialApp(
      // MaterialApp widget'ı başlatılıyor
      title: 'Phishing Email Detector', // Uygulama başlığı ayarlanıyor
      theme: ThemeData(
        // Tema başlatılıyor
        colorScheme: ColorScheme.fromSeed(
          // Renk şeması ayarlanıyor
          seedColor: const Color(0xFF2C3E50), // Ana renk
          primary: const Color(0xFF2C3E50), // Birincil renk
          secondary: const Color(0xFF3498DB), // İkincil renk
          background: Colors.grey[50], // Arka plan rengi
        ), // ColorScheme bitiyor
        useMaterial3: true, // Material 3 kullanılıyor
        scaffoldBackgroundColor: Colors.grey[50], // Scaffold arka plan rengi
        cardTheme: CardTheme(
          // Kart teması başlatılıyor
          elevation: 4, // Kart gölgesi
          shape: RoundedRectangleBorder(
            // Kart köşe şekli
            borderRadius: BorderRadius.circular(12), // Kart köşe yuvarlaklığı
          ), // RoundedRectangleBorder bitiyor
        ), // CardTheme bitiyor
        appBarTheme: const AppBarTheme(
          // AppBar teması başlatılıyor
          backgroundColor: Color(0xFF2C3E50), // AppBar arka plan rengi
          foregroundColor: Colors.white, // AppBar yazı rengi
          elevation: 0, // AppBar gölgesi yok
        ), // AppBarTheme bitiyor
      ), // ThemeData bitiyor
      home:
          const DashboardScreen(), // Ana ekran olarak DashboardScreen ayarlanıyor
      routes: {
        // Rotalar başlatılıyor
        '/dashboard': (context) =>
            const DashboardScreen(), // Dashboard ekranı rotası
        '/analysis': (context) =>
            const EmailAnalysisScreen(), // Email analiz ekranı rotası
        '/education': (context) =>
            const EducationScreen(), // Eğitim ekranı rotası
      }, // Rotalar bitiyor
    ); // MaterialApp bitiyor
  } // build fonksiyonu bitiyor
} // PhishingDetectorApp sınıfı bitiyor

// Email analysis model // EmailAnalysis sınıfı başlatılıyor
class EmailAnalysis {
  // EmailAnalysis sınıfı başlatılıyor
  final String subject; // Email konusu değişkeni
  final String body; // Email gövdesi değişkeni
  final double riskScore; // Risk skoru değişkeni
  final List<RiskIndicator> indicators; // Risk göstergeleri listesi
  final List<String> recommendations; // Öneriler listesi

  EmailAnalysis({
    // Yapıcı fonksiyon başlatılıyor
    required this.subject, // Zorunlu subject parametresi
    required this.body, // Zorunlu body parametresi
    required this.riskScore, // Zorunlu riskScore parametresi
    required this.indicators, // Zorunlu indicators parametresi
    required this.recommendations, // Zorunlu recommendations parametresi
  }); // Yapıcı fonksiyon bitiyor
} // EmailAnalysis sınıfı bitiyor

class RiskIndicator {
  // RiskIndicator sınıfı başlatılıyor
  final String type; // Tür değişkeni
  final String description; // Açıklama değişkeni
  final int severity; // 1-3 (Düşük, Orta, Yüksek) // Şiddet değişkeni
  final String location; // Emailde bulunduğu yer değişkeni

  RiskIndicator({
    // Yapıcı fonksiyon başlatılıyor
    required this.type, // Zorunlu type parametresi
    required this.description, // Zorunlu description parametresi
    required this.severity, // Zorunlu severity parametresi
    required this.location, // Zorunlu location parametresi
  }); // Yapıcı fonksiyon bitiyor
} // RiskIndicator sınıfı bitiyor

// Chatbot message model // Chatbot mesaj modeli başlatılıyor
class ChatMessage {
  // ChatMessage sınıfı başlatılıyor
  final String message; // Mesaj metni değişkeni
  final bool isUser; // Kullanıcıdan mı değişkeni
  final DateTime timestamp; // Zaman damgası değişkeni

  ChatMessage({
    // Yapıcı fonksiyon başlatılıyor
    required this.message, // Zorunlu message parametresi
    required this.isUser, // Zorunlu isUser parametresi
    required this.timestamp, // Zorunlu timestamp parametresi
  }); // Yapıcı fonksiyon bitiyor
} // ChatMessage sınıfı bitiyor

// Sample phishing indicators // Örnek phishing göstergeleri
final List<String> phishingIndicators = [
  // phishingIndicators listesi başlatılıyor
  'Urgency', // Aciliyet
  'Suspicious Links', // Şüpheli Bağlantılar
  'Poor Grammar', // Kötü Dilbilgisi
  'Generic Greeting', // Genel Selamlama
  'Request for Personal Information', // Kişisel Bilgi Talebi
  'Mismatched URLs', // Eşleşmeyen URL'ler
  'Unusual Sender', // Alışılmadık Gönderen
  'Suspicious Attachments', // Şüpheli Ekler
]; // phishingIndicators listesi bitiyor

// Sample prevention tips // Örnek önleme ipuçları
final List<String> preventionTips = [
  // preventionTips listesi başlatılıyor
  'Always verify the sender\'s email address', // Gönderenin e-posta adresini her zaman doğrulayın
  'Check for HTTPS in URLs', // URL\'lerde HTTPS olup olmadığını kontrol edin
  'Don\'t click on suspicious links', // Şüpheli bağlantılara tıklamayın
  'Keep your software updated', // Yazılımınızı güncel tutun
  'Use strong, unique passwords', // Güçlü, benzersiz şifreler kullanın
  'Enable two-factor authentication', // İki faktörlü kimlik doğrulamayı etkinleştirin
  'Be cautious with attachments', // Eklere karşı dikkatli olun
  'Report suspicious emails', // Şüpheli e-postaları bildirin
]; // preventionTips listesi bitiyor

// Sample chatbot responses // Örnek chatbot yanıtları
final Map<String, String> chatbotResponses = {
  // chatbotResponses haritası başlatılıyor
  'greeting': // Selamlama
      'Hello! I\'m your phishing detection assistant. How can I help you today?', // Selamlama mesajı
  'risk_explanation': // Risk açıklaması
      'The risk score is calculated based on multiple factors including suspicious links, urgency indicators, and sender verification.', // Risk açıklama mesajı
  'verify_sender': // Göndereni doğrulama
      'To verify a sender, check the email domain, look for official signatures, and contact the organization directly through their official channels.', // Gönderen doğrulama mesajı
  'suspicious_link': // Şüpheli bağlantı
      'If you find a suspicious link, don\'t click it. Instead, hover over it to see the actual URL and report it if it looks suspicious.', // Şüpheli bağlantı mesajı
  'report_phishing': // Phishing bildirimi
      'To report a phishing email, use the "Report" button in the app. This will help protect others from similar threats.', // Phishing bildirim mesajı
}; // chatbotResponses haritası bitiyor
