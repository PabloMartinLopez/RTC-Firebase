import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:untitled/features/CrearEncuesta/CrearEncuesta_screen.dart';
import 'package:untitled/features/menuEncuestas/MenuEncuestas_screen.dart';
import 'package:untitled/features/votaciones/Votaciones_screen.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: MenuencuestasScreen(),
      routes: {
        '/':(context) => MenuencuestasScreen(),
        '/votaciones':(context) => VotacionesScreen(),
        '/createEncuestas':(context) => CrearencuestaScreen(),
      },
    );
  }
}
