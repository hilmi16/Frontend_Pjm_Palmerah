import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pjm_palmerah/screen/menu.dart';
import 'package:flutter/services.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MaterialApp(
    home: Menu(),
    debugShowCheckedModeBanner: false,
  ));
}
