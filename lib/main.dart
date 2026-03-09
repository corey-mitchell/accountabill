import 'package:accountabill/data/repositories/authentication_repository.dart';
import 'package:accountabill/pages/authentication.dart';
import 'package:accountabill/pages/charity_search.dart';
import 'package:accountabill/pages/events.dart';
import 'package:accountabill/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:accountabill/pages/dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => AuthenticationRepository(),
      child: MaterialApp(
        title: 'Account-a-Bill',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: .fromSeed(seedColor: Colors.green),
        ),
        // Create and use stack navigation
        routes: {
          '/dashboard': (BuildContext ctx) => DashboardPage(),
          '/settings': (BuildContext ctx) => SettingsPage(),
          '/settings/charity_search': (BuildContext ctx) => CharitySearchPage(),
          '/events': (BuildContext ctx) => EventsPage(),
        },
        initialRoute: '/',
        // We do not need the home property with stack navigation.
        // UNLESS the route requires data to be passed down
        home: AuthPage(),
      ),
    );
  }
}
