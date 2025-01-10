import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wulflex_admin/data/services/category_services.dart';
import 'package:wulflex_admin/data/services/chat_services.dart';
import 'package:wulflex_admin/data/services/order_services.dart';
import 'package:wulflex_admin/data/services/product_services.dart';
import 'package:wulflex_admin/data/services/review_services.dart';
import 'package:wulflex_admin/features/auth/bloc/authentication_bloc/authentication_bloc_bloc.dart';
import 'package:wulflex_admin/features/categories/bloc/category_bloc/category_bloc.dart';
import 'package:wulflex_admin/features/chats/bloc/bloc/chat_bloc.dart';
import 'package:wulflex_admin/features/orders/bloc/order_bloc/order_bloc.dart';
import 'package:wulflex_admin/features/products/bloc/product_bloc/product_bloc.dart';
import 'package:wulflex_admin/features/products/bloc/sales_bloc/sales_bloc.dart';
import 'package:wulflex_admin/features/reviews/bloc/review_bloc/review_bloc.dart';

const String bucket = 'wulflex.firebasestorage.app';

class AppConstants {
  static const String SENDER_ID = '57079492115';
}

//! BLOC PROVIDERS
class AppBlocProviders {
  static final productServices = ProductServices();
  static final imagePicker = ImagePicker();
  static final categoryServices = CategoryServices();
  static final orderServices = OrderServices();
  static final reviewServices = ReviewServices();
  static final chatServices = ChatServices();

  static List<BlocProvider> providers = [
    BlocProvider<AuthenticationBlocBloc>(
      create: (context) => AuthenticationBlocBloc(),
    ),
    BlocProvider<ProductBloc>(
      create: (context) => ProductBloc(productServices, imagePicker),
    ),
    BlocProvider<CategoryBloc>(
      create: (context) => CategoryBloc(categoryServices),
    ),
    BlocProvider<OrderBloc>(
      create: (context) => OrderBloc(orderServices),
    ),
    BlocProvider<ReviewBloc>(
      create: (context) => ReviewBloc(reviewServices),
    ),
    BlocProvider<ChatBloc>(
      create: (context) => ChatBloc(chatServices),
    ),
    BlocProvider<SalesBloc>(
      create: (context) => SalesBloc(orderServices),
    ),
  ];
}
