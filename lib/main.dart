import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'app/routes/app_routes.dart';
import 'presentation/providers/theme/theme_provider.dart';
import 'presentation/screens/error_handler_screen.dart';
import 'service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await dotenv.load();

  setupServiceLocator();

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
            builder: (context, child) => ErrorHandlerBuilder(child: child),
          );
        },
      ),
    );
  }
}
