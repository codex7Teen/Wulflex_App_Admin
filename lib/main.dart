import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wulflex_admin/data/services/chat_services.dart';
import 'package:wulflex_admin/data/services/review_services.dart';
import 'package:wulflex_admin/features/auth/bloc/authentication_bloc/authentication_bloc_bloc.dart';
import 'package:wulflex_admin/features/categories/bloc/category_bloc/category_bloc.dart';
import 'package:wulflex_admin/features/chats/bloc/bloc/chat_bloc.dart';
import 'package:wulflex_admin/features/orders/bloc/order_bloc/order_bloc.dart';
import 'package:wulflex_admin/features/products/bloc/product_bloc/product_bloc.dart';
import 'package:wulflex_admin/data/services/category_services.dart';
import 'package:wulflex_admin/data/services/order_services.dart';
import 'package:wulflex_admin/data/services/product_services.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/features/auth/presentation/screens/splash_screen_1.dart';
import 'package:wulflex_admin/features/products/bloc/sales_bloc/sales_bloc.dart';
import 'package:wulflex_admin/features/reviews/bloc/review_bloc/review_bloc.dart';

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
    final reviewServices = ReviewServices();
    final chatServices = ChatServices();
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
        BlocProvider(
          create: (context) => ReviewBloc(reviewServices),
        ),
        BlocProvider(
          create: (context) => ChatBloc(chatServices),
        ),
        BlocProvider(
          create: (context) => SalesBloc(orderServices),
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
