
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controllers/carroController.dart';
import 'firebase_options.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  DaoCarro.inicializa();
  runApp(Login());
}
