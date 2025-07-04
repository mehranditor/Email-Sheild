import 'package:flutter/material.dart'; // Flutter ana paketi içe aktarılıyor
import 'package:flutter_localizations/flutter_localizations.dart'; // Flutter yerelleştirme paketleri içe aktarılıyor
import 'package:provider/provider.dart'; // Provider durumu yönetimi paketi içe aktarılıyor
import 'screens/welcome_screen.dart'; // WelcomeScreen dosyası içe aktarılıyor
import 'screens/email_analysis_screen.dart'; // EmailAnalysisScreen dosyası içe aktarılıyor
import 'screens/education_screen.dart'; // EducationScreen dosyası içe aktarılıyor
import 'screens/dashboard_screen.dart'; // DashboardScreen dosyası içe aktarılıyor
import 'screens/settings_screen.dart'; // SettingsScreen dosyası içe aktarılıyor
import 'screens/chat_screen.dart'; // ChatScreen dosyası içe aktarılıyor
import 'screens/phishing_simulator_screen.dart'; // PhishingSimulatorScreen dosyası içe aktarılıyor
import 'providers/theme_provider.dart'; // Tema sağlayıcı dosyası içe aktarılıyor
import 'providers/language_provider.dart'; // Dil sağlayıcı dosyası içe aktarılıyor
import 'l10n/app_translations.dart'; // Uygulama çeviri dosyası içe aktarılıyor
import 'phishing_email_detector.dart'; // PhishingEmailDetector uygulama dosyası içe aktarılıyor

void main() {
  // Ana fonksiyon, uygulamanın başlangıç noktası
  WidgetsFlutterBinding.ensureInitialized(); // Flutter bağlamı başlatılıyor
  runApp(
    // Uygulama başlatılıyor
    MultiProvider(
      // Çoklu sağlayıcı başlatılıyor
      providers: [
        // Sağlayıcılar listesi başlatılıyor
        ChangeNotifierProvider(
            create: (_) => ThemeProvider()), // Tema sağlayıcı ekleniyor
        ChangeNotifierProvider(
            create: (_) => LanguageProvider()), // Dil sağlayıcı ekleniyor
      ], // Sağlayıcılar listesi bitiyor
      child: const MyApp(), // Ana uygulama widget'ı ekleniyor
    ), // MultiProvider bitiyor
  ); // runApp bitiyor
} // main fonksiyonu bitiyor

class MyApp extends StatelessWidget {
  // MyApp sınıfı başlatılıyor, StatelessWidget'tan türetiliyor
  const MyApp({super.key}); // Yapıcı fonksiyon, anahtar parametresi ile

  @override // build fonksiyonu override ediliyor
  Widget build(BuildContext context) {
    // build fonksiyonu başlatılıyor
    return Consumer2<ThemeProvider, LanguageProvider>(
      // İki sağlayıcıyı dinleyen widget başlatılıyor
      builder: (context, themeProvider, languageProvider, child) {
        // builder fonksiyonu başlatılıyor
        return MaterialApp(
          // MaterialApp widget'ı başlatılıyor
          title: 'Email Shield', // Uygulama başlığı ayarlanıyor
          debugShowCheckedModeBanner: false, // Debug banner gizleniyor
          locale: languageProvider.currentLocale, // Uygulama dili ayarlanıyor
          localizationsDelegates: [
            // Yerelleştirme delegeleri başlatılıyor
            GlobalMaterialLocalizations
                .delegate, // Material yerelleştirme delegesi
            GlobalWidgetsLocalizations
                .delegate, // Widget yerelleştirme delegesi
            GlobalCupertinoLocalizations
                .delegate, // Cupertino yerelleştirme delegesi
            _AppLocalizationsDelegate(), // Özel yerelleştirme delegesi
          ], // Delegeler listesi bitiyor
          supportedLocales: const [
            // Desteklenen diller listesi başlatılıyor
            Locale('en'), // İngilizce
            Locale('es'), // İspanyolca
            Locale('fr'), // Fransızca
            Locale('de'), // Almanca
            Locale('zh'), // Çince
            Locale('tr'), // Türkçe
            Locale('fa'), // Farsça
            Locale('ar'), // Arapça
            Locale('ja'), // Japonca
            Locale('ko'), // Korece
            Locale('ru'), // Rusça
            Locale('it'), // İtalyanca
            Locale('pt'), // Portekizce
            Locale('nl'), // Hollandaca
            Locale('hi'), // Hintçe
          ], // Desteklenen diller listesi bitiyor
          theme: ThemeData(
            // Açık tema başlatılıyor
            colorScheme: ColorScheme.fromSeed(
              // Renk şeması ayarlanıyor
              seedColor: const Color(0xFF2C3E50), // Ana renk
              primary: const Color(0xFF2C3E50), // Birincil renk
              secondary: const Color(0xFF3498DB), // İkincil renk
              background: Colors.grey[50], // Arka plan rengi
              onPrimary: Colors.white, // Birincil üzerindeki renk
              onSecondary: Colors.white, // İkincil üzerindeki renk
              onBackground:
                  const Color(0xFF2C3E50), // Arka plan üzerindeki renk
            ), // ColorScheme bitiyor
            useMaterial3: true, // Material 3 kullanılıyor
            scaffoldBackgroundColor:
                Colors.grey[50], // Scaffold arka plan rengi
            cardTheme: CardTheme(
              // Kart teması başlatılıyor
              elevation: 4, // Kart gölgesi
              shape: RoundedRectangleBorder(
                // Kart köşe şekli
                borderRadius:
                    BorderRadius.circular(12), // Kart köşe yuvarlaklığı
              ), // RoundedRectangleBorder bitiyor
            ), // CardTheme bitiyor
            appBarTheme: const AppBarTheme(
              // AppBar teması başlatılıyor
              backgroundColor: Color(0xFF2C3E50), // AppBar arka plan rengi
              foregroundColor: Colors.white, // AppBar yazı rengi
              elevation: 0, // AppBar gölgesi yok
            ), // AppBarTheme bitiyor
            textTheme: const TextTheme(
              // Yazı teması başlatılıyor
              bodyLarge: TextStyle(
                  color: Color(0xFF2C3E50)), // Büyük gövde yazısı rengi
              bodyMedium: TextStyle(
                  color: Color(0xFF2C3E50)), // Orta gövde yazısı rengi
              titleLarge: TextStyle(
                  color: Color(0xFF2C3E50)), // Büyük başlık yazısı rengi
              titleMedium: TextStyle(
                  color: Color(0xFF2C3E50)), // Orta başlık yazısı rengi
            ), // TextTheme bitiyor
          ), // ThemeData bitiyor
          darkTheme: ThemeData(
            // Koyu tema başlatılıyor
            colorScheme: ColorScheme.fromSeed(
              // Renk şeması ayarlanıyor
              seedColor: const Color(0xFF2C3E50), // Ana renk
              brightness: Brightness.dark, // Koyu mod
              primary: const Color(0xFF3498DB), // Birincil renk
              secondary: const Color(0xFF2C3E50), // İkincil renk
              background: const Color(0xFF1A1A1A), // Arka plan rengi
              onPrimary: Colors.white, // Birincil üzerindeki renk
              onSecondary: Colors.white, // İkincil üzerindeki renk
              onBackground: Colors.white, // Arka plan üzerindeki renk
            ), // ColorScheme bitiyor
            useMaterial3: true, // Material 3 kullanılıyor
            scaffoldBackgroundColor:
                const Color(0xFF1A1A1A), // Scaffold arka plan rengi
            cardTheme: CardTheme(
              // Kart teması başlatılıyor
              elevation: 4, // Kart gölgesi
              shape: RoundedRectangleBorder(
                // Kart köşe şekli
                borderRadius:
                    BorderRadius.circular(12), // Kart köşe yuvarlaklığı
              ), // RoundedRectangleBorder bitiyor
            ), // CardTheme bitiyor
            appBarTheme: const AppBarTheme(
              // AppBar teması başlatılıyor
              backgroundColor: Color(0xFF2C3E50), // AppBar arka plan rengi
              foregroundColor: Colors.white, // AppBar yazı rengi
              elevation: 0, // AppBar gölgesi yok
            ), // AppBarTheme bitiyor
            textTheme: const TextTheme(
              // Yazı teması başlatılıyor
              bodyLarge:
                  TextStyle(color: Colors.white), // Büyük gövde yazısı rengi
              bodyMedium:
                  TextStyle(color: Colors.white), // Orta gövde yazısı rengi
              titleLarge:
                  TextStyle(color: Colors.white), // Büyük başlık yazısı rengi
              titleMedium:
                  TextStyle(color: Colors.white), // Orta başlık yazısı rengi
            ), // TextTheme bitiyor
          ), // ThemeData bitiyor
          themeMode: themeProvider.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light, // Tema modu seçiliyor
          initialRoute: '/', // Başlangıç rotası ayarlanıyor
          routes: {
            // Rotalar başlatılıyor
            '/': (context) => const WelcomeScreen(), // Ana ekran rotası
            '/dashboard': (context) =>
                const DashboardScreen(), // Dashboard ekranı rotası
            '/analysis': (context) =>
                const EmailAnalysisScreen(), // Analiz ekranı rotası
            '/education': (context) =>
                const EducationScreen(), // Eğitim ekranı rotası
            '/settings': (context) =>
                const SettingsScreen(), // Ayarlar ekranı rotası
            '/chat': (context) => const ChatScreen(), // Sohbet ekranı rotası
            '/simulator': (context) =>
                const PhishingSimulatorScreen(), // Simülatör ekranı rotası
          }, // Rotalar bitiyor
        ); // MaterialApp bitiyor
      }, // builder fonksiyonu bitiyor
    ); // Consumer2 bitiyor
  } // build fonksiyonu bitiyor
} // MyApp sınıfı bitiyor

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppTranslations> {
  // Yerelleştirme delegesi sınıfı başlatılıyor
  const _AppLocalizationsDelegate(); // Sabit yapıcı fonksiyon

  @override // isSupported fonksiyonu override ediliyor
  bool isSupported(Locale locale) {
    // isSupported fonksiyonu başlatılıyor
    return [
      // Desteklenen diller listesi başlatılıyor
      'en', // İngilizce
      'es', // İspanyolca
      'fr', // Fransızca
      'de', // Almanca
      'zh', // Çince
      'tr', // Türkçe
      'fa', // Farsça
      'ar', // Arapça
      'ja', // Japonca
      'ko', // Korece
      'ru', // Rusça
      'it', // İtalyanca
      'pt', // Portekizce
      'nl', // Hollandaca
      'hi' // Hintçe
    ].contains(locale.languageCode); // Dil kodu kontrol ediliyor
  } // isSupported fonksiyonu bitiyor

  @override // load fonksiyonu override ediliyor
  Future<AppTranslations> load(Locale locale) async {
    // load fonksiyonu başlatılıyor
    return AppTranslations(locale); // AppTranslations nesnesi döndürülüyor
  } // load fonksiyonu bitiyor

  @override // shouldReload fonksiyonu override ediliyor
  bool shouldReload(_AppLocalizationsDelegate old) =>
      false; // Yeniden yükleme gerekmiyor
} // _AppLocalizationsDelegate sınıfı bitiyor
