import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'date_time_screen.dart'; // Импорт DateTimeScreen
import 'create_request_page.dart'; // Импорт CreateRequestPage
import 'statistics_page.dart'; // Импорт StatisticsPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Приложение',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color.fromARGB(255, 73, 76, 212),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 73, 76, 212),
          foregroundColor: Colors.white, // Белый цвет текста заголовка AppBar
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 73, 76, 212), // Зеленые кнопки
            foregroundColor: Colors.white, // Белый текст кнопок
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color.fromARGB(255, 73, 76, 212), // Зеленая граница для кнопок
            side: const BorderSide(color: Color.fromARGB(255, 73, 76, 212)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color.fromARGB(255, 73, 76, 212),
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.white, // Белый цвет заголовков
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            color: Colors.white, // Белый цвет основного текста
            fontSize: 16,
          ),
          bodyMedium: TextStyle(
            color: Colors.white70, // Белый с прозрачностью для второстепенного текста
          ),
        ),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 73, 76, 212)),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color.fromARGB(255, 73, 76, 212)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color.fromARGB(255, 73, 76, 212)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
          ),
          labelStyle: const TextStyle(color: Color.fromARGB(255, 73, 76, 212)),
        ),
      ),
      supportedLocales: const [
        Locale('en', ''), // Английский
        Locale('ru', ''), // Русский
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, // Для iOS-стилей
      ],
      locale: const Locale('ru', ''), // Установите русский как язык по умолчанию
      initialRoute: '/', // Устанавливаем стартовый маршрут
      routes: {
        '/': (context) => const DateTimeScreen(), // Главная страница
        '/create_request': (context) => const CreateRequestPage(), // Создание заявки
        '/statistics': (context) => const StatisticsPage(), // Статистика
      },
    );
  }
}