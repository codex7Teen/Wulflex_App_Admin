import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wulflex_admin/blocs/category_bloc/category_bloc.dart';
import 'package:wulflex_admin/utils/consts/text_styles.dart';
import 'package:wulflex_admin/widgets/appbar_with_back_button_widget.dart';
import 'package:wulflex_admin/widgets/blue_button_widget.dart';
import 'package:wulflex_admin/widgets/custom_add_fields_widget.dart';
import 'package:wulflex_admin/widgets/custom_snacbar.dart';

class ScreenAddCategory extends StatefulWidget {
  final String screenTitle;
  const ScreenAddCategory({super.key, required this.screenTitle});

  @override
  State<ScreenAddCategory> createState() => _ScreenAddCategoryState();
}

class _ScreenAddCategoryState extends State<ScreenAddCategory> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _categoryNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _categoryNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWithbackbuttonWidget(appBarTitle: widget.screenTitle),
      body: BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CategoryError) {
            CustomSnackbar.showCustomSnackBar(
              context,
              state.message,
              icon: Icons.error,
            );
          } else if (state is CategoriesLoaded) {
            CustomSnackbar.showCustomSnackBar(
              context,
              'Category added successfully... 🎉🎉🎉',
              icon: Icons.check_circle_outline_rounded,
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Category Name',
                        style: AppTextStyles.headLineMediumSmall),
                    SizedBox(height: 8),
                    CustomAddFieldsWidget(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a category name';
                        }
                        return null;
                      },
                      controller: _categoryNameController,
                    ),
                    SizedBox(height: 25),
                    GestureDetector(onTap: () async {
                      if (formKey.currentState!.validate()) {
                        //! add category to fb
                        context.read<CategoryBloc>().add(AddCategoryEvent(
                            _categoryNameController.text.trim()));
                      }
                    }, child: BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        return BlueButtonWidget(
                          buttonText: 'Add Category',
                          isLoading: state is CategoryLoading,
                        );
                      },
                    ))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
