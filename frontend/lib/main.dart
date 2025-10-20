import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'generated/app_localizations.dart';
import 'screens/home_screen.dart';
import 'screens/result_screen.dart';
import 'services/api_service.dart';
import 'services/language_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final languageService = LanguageService();
  await languageService.initialize();
  runApp(MyApp(languageService: languageService));
}

class MyApp extends StatelessWidget {
  final LanguageService languageService;

  const MyApp({super.key, required this.languageService});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: languageService,
      child: Consumer<LanguageService>(
        builder: (context, langService, child) {
          return MaterialApp(
            onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
            debugShowCheckedModeBanner: false,
            locale: langService.currentLocale,
            theme: ThemeData(
              primaryColor: const Color(0xFF00E5FF), // Neon Cyan
              scaffoldBackgroundColor: const Color(0xFF0B0D14), // Deep Space
              useMaterial3: true,
              textTheme: GoogleFonts.plusJakartaSansTextTheme(),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF00E5FF),
                brightness: Brightness.dark,
                primary: const Color(0xFF00E5FF), // Neon Cyan
                secondary: const Color(0xFFFF6B9D), // Sakura Pink (softer)
                tertiary: const Color(0xFF9D4EDD), // Electric Purple
                surface: const Color(0xFF0B0D14), // Deep Space
                error: const Color(0xFFFF6B9D), // Sakura Pink for errors
                onPrimary: Colors.black,
                onSecondary: Colors.white,
                onSurface: Colors.white,
                onError: Colors.white,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  elevation: 8,
                  shadowColor: const Color(0xFF00E5FF).withOpacity(0.3),
                ),
              ),
            ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('tr'),
              Locale('ja'),
            ],
            home: const HomeScreen(),
            onGenerateRoute: (settings) {
              if (settings.name == '/result') {
                final result = settings.arguments as RecognitionResult;
                return MaterialPageRoute(
                  builder: (context) => ResultScreen(result: result),
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}