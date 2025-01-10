import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wulflex_admin/core/config/app_constants.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/features/auth/presentation/screens/splash_screen_1.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDMzuQfFMY4pScI7ihyfVFV5fsT0pcsATI",
            authDomain: "wulflex.firebaseapp.com",
            projectId: "wulflex",
            storageBucket: "wulflex.firebasestorage.app",
            messagingSenderId: "57079492115",
            appId: "1:57079492115:web:5e3e9dca571031603fd9e6"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBlocProviders.providers,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Wulflex Admin',
          theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch()
                  .copyWith(primary: AppColors.blueThemeColor)),
          home: const ScreenSplash1()),
    );
  }
}
