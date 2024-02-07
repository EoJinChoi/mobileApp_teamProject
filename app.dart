import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';

class ShrineApp extends StatelessWidget {
  const ShrineApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shrine',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => const LoginPage(),
        '/Home': (BuildContext context) => const HomePage(),
      },
      theme: ThemeData.light(useMaterial3: true),
    );
  }
}
