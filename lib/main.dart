import 'package:flutter/material.dart';
import 'frames/login.dart';
import 'frames/signup.dart';
import 'frames/homepage.dart';
import 'frames/settings.dart';
import 'frames/search.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/*void main() {
  runApp(const MyApp());
}*/

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/login', // Start with the login screen
      routes: {
        '/login': (context) => const LoginScreen(), // Login route
        '/signup': (context) => const SignUpScreen(), // SignUp route
        '/homepage': (context) => const HomeScreen(), // Home Screen route
        '/search': (context) => const SearchScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
