import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wulflex_admin/features/categories/bloc/category_bloc/category_bloc.dart';
import 'package:wulflex_admin/features/categories/presentation/screens/add_edit_category_screen.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/shared/widgets/alert_boxes_widgets.dart';
import 'package:wulflex_admin/shared/widgets/appbar_with_back_button_widget.dart';
import 'package:wulflex_admin/shared/widgets/custom_snacbar.dart';
import 'package:wulflex_admin/shared/widgets/navigation_helper_widget.dart';

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
            builder: (context, state) {
              if (state is CategoryLoading ||
                  state is CategoyDeleteSuccess ||
                  state is CategoryEditSuccess) {
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

                return ListView.separated(
                    itemBuilder: (context, index) {
                      final category = customCategories[index];
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(13),
                            width:
                                MediaQuery.of(context).size.width, // Full width
                            decoration: BoxDecoration(
                              color: AppColors.lightGreyThemeColor,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              children: [
                                // Product Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: SizedBox(
                                    height: 84,
                                    width: MediaQuery.of(context).size.width *
                                        0.21,
                                    child: category['image_url'].isEmpty
                                        ? Image.asset(
                                            'assets/wulflex_logo_nobg.png') // Fallback for empty URLs
                                        : (category['image_url']
                                                .startsWith('assets/')
                                            ? Image.asset(category['image_url'],
                                                fit: BoxFit.cover)
                                            : CachedNetworkImage(
                                                imageUrl: category['image_url'],
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) {
                                                  return SizedBox(
                                                      width: 16,
                                                      height: 16,
                                                      child: Image.asset(
                                                          'assets/wulflex_logo_nobg.png'));
                                                },
                                              )),
                                  ),
                                ),

                                SizedBox(width: 14),

                                // Product Details
                                Expanded(
                                  child: Text(
                                    category['name'],
                                    style: GoogleFonts.robotoCondensed(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.blackThemeColor,
                                      fontSize: 19,
                                      letterSpacing: 1,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                // Action Column
                                Column(
                                  children: [
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: AppColors.darkishGrey,
                                      size: 19,
                                    ),
                                    SizedBox(height: 8),
                                    Visibility(
                                      visible: !category['image_url']
                                          .startsWith('assets/'),
                                      child: PopupMenuButton<int>(
                                        onSelected: (value) {
                                          if (value == 0) {
                                            // Handle Edit action
                                            NavigationHelper
                                                .navigateToWithoutReplacement(
                                                    context,
                                                    ScreenAddCategory(
                                                        screenTitle:
                                                            screenTitle,
                                                        isEditMode: true,
                                                        existingCategory:
                                                            category));
                                          } else if (value == 1) {
                                            // Delete
                                            CustomAlertBox
                                                .showDeleteConfirmationDialog(
                                                    context,
                                                    productName:
                                                        category['name'],
                                                    onDeleteConfirmed: () {
                                              // Handle Delete action
                                              context.read<CategoryBloc>().add(
                                                  DeleteCategoryEvent(
                                                      categoryId:
                                                          category['id']));
                                            });
                                          }
                                        },
                                        icon: Icon(
                                          Icons.more_vert_rounded,
                                          color: AppColors.darkishGrey,
                                          size: 24,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            value: 0,
                                            child: Row(
                                              children: [
                                                Icon(Icons.edit,
                                                    color:
                                                        AppColors.darkishGrey),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Edit',
                                                  style: GoogleFonts
                                                      .robotoCondensed(
                                                    color: AppColors
                                                        .blackThemeColor,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 1,
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete,
                                                    color: Colors.red),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Delete',
                                                  style: GoogleFonts
                                                      .robotoCondensed(
                                                    color: AppColors
                                                        .blackThemeColor,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Visibility(
                                    visible: category['image_url']
                                        .startsWith('assets/'),
                                    child: SizedBox(
                                      width: 16,
                                    ))
                              ],
                            ),
                          )
                        ],
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemCount: customCategories.length);
              }
              return Center(child: Text('Something went wrong'));
            },
          )),
    );
  }
}
