import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'state_update.dart';
import 'themes.dart';
import 'global.dart';
import 'home.dart';
import 'firebase.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  final theme = prefs.getString('theme');
  if (theme != null) appSettings['theme'] = theme;

  final search = prefs.getStringList('searchHistory');
  if (search != null) searchHistory.history = search;

  await Firebase.initializeApp();
  AuthService().sign();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChangeNavigation()),
        ChangeNotifierProvider(
          create: (context) => ChangeTheme(),
          builder: (BuildContext context, _) {
            context.watch<ChangeTheme>().getTheme;
            return MaterialApp(
              title: 'SwapWork',
              themeMode:
                  AppThemes().getMode(context.watch<ChangeTheme>().getTheme),
              theme: AppThemes().light(),
              darkTheme: AppThemes().dark(),
              home: const HomePage(),
            );
          },
        ),
      ],
    );
  }
}
