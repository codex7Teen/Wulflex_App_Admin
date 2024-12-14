import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wulflex_admin/blocs/authentication_bloc/authentication_bloc_bloc.dart';
import 'package:wulflex_admin/blocs/category_bloc/category_bloc.dart';
import 'package:wulflex_admin/blocs/order_bloc/order_bloc.dart';
import 'package:wulflex_admin/blocs/product_bloc/product_bloc.dart';
import 'package:wulflex_admin/services/category_services.dart';
import 'package:wulflex_admin/services/order_services.dart';
import 'package:wulflex_admin/services/product_services.dart';
import 'package:wulflex_admin/utils/consts/app_colors.dart';
import 'package:wulflex_admin/screens/splash_screens/splash_screen_1.dart';

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
    final productServices = ProductServices();
    final imagePicker = ImagePicker();
    final categoryServices = CategoryServices();
    final orderServices = OrderServices();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationBlocBloc(),
        ),
        BlocProvider(
          create: (context) => ProductBloc(productServices, imagePicker),
        ),
        BlocProvider(
          create: (context) => CategoryBloc(categoryServices),
        ),
        BlocProvider(
          create: (context) => OrderBloc(orderServices),
        ),
      ],
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
