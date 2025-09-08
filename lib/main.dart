import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'app/routes/app_routes.dart';
import 'app/database/app_database.dart';
import 'app/locale/app_locale.dart';
import 'presentation/providers/theme/theme_provider.dart';
import 'presentation/screens/error_handler_screen.dart';
import 'service_locator.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Heavy tasks async to avoid UI blocking
  await Future.wait([
    Firebase.initializeApp(
      name: DefaultFirebaseOptions.currentPlatform.projectId,
      options: DefaultFirebaseOptions.currentPlatform,
    ),
    AppDatabase().init(),
    dotenv.load(),
    initializeDateFormatting(),
  ]);

  // Ensure Firebase persistence cleared
  await FirebaseFirestore.instance.clearPersistence();

  // Setup service locator
  setupServiceLocator();

  // Lock orientation & System UI
  SystemChrome.setPreferredOrientations([]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Selector<ThemeProvider, ThemeData>(
        selector: (context, provider) => provider.theme,
        builder: (context, theme, _) {
          return MaterialApp.router(
            title: 'Flutter POS',
            theme: theme,
            debugShowCheckedModeBanner: false,
            routerConfig: AppRoutes.router,
            locale: AppLocale.defaultLocale,
            supportedLocales: AppLocale.supportedLocales,
            localizationsDelegates: AppLocale.localizationsDelegates,
            builder: (context, child) => ErrorHandlerBuilder(child: child),
          );
        },
      ),
    );
  }
}
