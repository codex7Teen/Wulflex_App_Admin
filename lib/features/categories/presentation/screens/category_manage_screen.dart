import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wulflex_admin/features/categories/bloc/category_bloc/category_bloc.dart';
import 'package:wulflex_admin/features/categories/presentation/widgets/category_manage_screen_widgets.dart';
import 'package:wulflex_admin/shared/widgets/appbar_with_back_button_widget.dart';
import 'package:wulflex_admin/shared/widgets/custom_snacbar.dart';

class ScreenCategoryManage extends StatelessWidget {
  final String screenTitle;
  const ScreenCategoryManage({super.key, required this.screenTitle});

  @override
  Widget build(BuildContext context) {
    context.read<CategoryBloc>().add(LoadCategoryDetailsEvent());
    return Scaffold(
      appBar: AppbarWithbackbuttonWidget(appBarTitle: screenTitle),
      body: Padding(
          padding: EdgeInsets.only(left: 18, right: 18, top: 15, bottom: 15),
          child: BlocConsumer<CategoryBloc, CategoryState>(
            listener: (context, state) {
              if (state is CategoyDeleteSuccess) {
                CustomSnackbar.showCustomSnackBar(
                    context, "Category deleted successfully... 🎉🎉🎉");
              }
            },
            buildWhen: (previous, current) {
              return current is CategoryLoading ||
                  current is CategoyDeleteSuccess ||
                  current is CategoryDetailsLoaded;
            },
            builder: (context, state) {
              if (state is CategoryLoading || state is CategoyDeleteSuccess) {
                return Center(child: CircularProgressIndicator());
              } else if (state is CategoryError) {
                return Center(child: Text('Category loading error: retry'));
              } else if (state is CategoryDetailsLoaded) {
                // Filter the custom categories from all category details
                final customCategories = state.categoryDetails;

                if (customCategories.isEmpty) {
                  return Center(
                    child: Text('No custom categories found!'),
                  );
                }

                return CategoryManageScreenWidgets.buildCategoriesList(
                    customCategories,
                    screenTitle: screenTitle);
              }
              return Center(child: Text('Something went wrong'));
            },
          )),
    );
  }
}
