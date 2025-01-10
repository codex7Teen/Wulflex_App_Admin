import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/core/config/text_styles.dart';
import 'package:wulflex_admin/data/models/product_model.dart';
import 'package:wulflex_admin/features/products/bloc/product_bloc/product_bloc.dart';
import 'package:wulflex_admin/features/products/presentation/screens/edit_product_screen.dart';
import 'package:wulflex_admin/features/products/presentation/screens/view_product_screen.dart';
import 'package:wulflex_admin/shared/widgets/alert_boxes_widgets.dart';
import 'package:wulflex_admin/shared/widgets/navigation_helper_widget.dart';

class CategoryProductsScreenWidgets {
  static Widget buildSearchBar(double screenWidth, ValueChanged onChanged,
      BuildContext context, Function filterProducts) {
    return Container(
      height: 50,
      width: screenWidth * 0.92,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: AppColors.lightGreyThemeColor,
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Image.asset(
            'assets/Search.png',
            scale: 28,
            color: AppColors.darkishGrey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: GoogleFonts.robotoCondensed(
                fontSize: 18,
                color: AppColors.blackThemeColor,
              ),
              decoration: InputDecoration(
                hintText: 'Search by product...',
                hintStyle: GoogleFonts.robotoCondensed(
                  fontSize: 18,
                  color: AppColors.greyThemeColor,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static // Build Item Card Widget
      Widget buildItemCard(BuildContext context, ProductModel product) {
    return Container(
      padding: EdgeInsets.all(13),
      width: MediaQuery.of(context).size.width, // Full width
      decoration: BoxDecoration(
        color: AppColors.lightGreyThemeColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          // Product Image
          GestureDetector(
            onTap: () => NavigationHelper.navigateToWithoutReplacement(
                context, ScreenViewProducts(productModel: product)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                  height: 84, // Fixed height
                  width: MediaQuery.of(context).size.width * 0.21,
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrls[0],
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return SizedBox(
                          width: 16,
                          height: 16,
                          child: Image.asset('assets/wulflex_logo_nobg.png'));
                    },
                  )),
            ),
          ),

          SizedBox(width: 14),

          // Product Details
          Expanded(
            child: GestureDetector(
              onTap: () => NavigationHelper.navigateToWithoutReplacement(
                  context, ScreenViewProducts(productModel: product)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brandName,
                    style: GoogleFonts.robotoCondensed(
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackThemeColor,
                      fontSize: 18,
                      letterSpacing: 1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    product.name,
                    style: GoogleFonts.robotoCondensed(
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkishGrey,
                      fontSize: 13,
                      letterSpacing: 1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 9),
                  Text(
                    "₹${NumberFormat('#,##,###.##').format(product.offerPrice)}",
                    style: GoogleFonts.robotoCondensed(
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackThemeColor,
                      fontSize: 18,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
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
              PopupMenuButton<int>(
                onSelected: (value) {
                  if (value == 0) {
                    // Handle Edit action
                    NavigationHelper.navigateToWithoutReplacement(
                      context,
                      ScreenEditProducts(
                        screenTitle: 'Edit Product',
                        productId: product.id!,
                        brandName: product.brandName,
                        productName: product.name,
                        productDescription: product.description,
                        productCategory: product.category,
                        productWeight: product.weights,
                        productSize: product.sizes,
                        productRetailPrice: product.retailPrice,
                        productOfferPrice: product.offerPrice,
                        productIsOnSale: product.isOnSale,
                        existingImageUrls: product.imageUrls,
                      ),
                    );
                  } else if (value == 1) {
                    // Handle Delete action
                    CustomAlertBox.showDeleteConfirmationDialog(context,
                        productName: product.brandName, onDeleteConfirmed: () {
                      context.read<ProductBloc>().add(
                            DeleteProductEvent(
                              productId: product.id!,
                              imageUrls: product.imageUrls,
                            ),
                          );
                      log('${product.id} DELETE ATTEMPTED');
                    });
                  }
                },
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: AppColors.darkishGrey,
                  size: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 0,
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: AppColors.darkishGrey),
                        SizedBox(width: 8),
                        Text(
                          'Edit',
                          style: GoogleFonts.robotoCondensed(
                            color: AppColors.blackThemeColor,
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
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          'Delete',
                          style: GoogleFonts.robotoCondensed(
                            color: AppColors.blackThemeColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  static Widget buildSearchedProductNotFoundDisplay(
      BuildContext context, bool searchEmpty, String? categoryName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 130),
          Lottie.asset('assets/lottie/search_empty_lottie_white.json',
              width: 190, repeat: false),
          const SizedBox(height: 18),
          Text(
            searchEmpty
                ? 'We couldn’t find what you’re looking for. Please refine your search.'
                : "Oops! No items in '$categoryName' right now. Explore other categories!",
            textAlign: TextAlign.center,
            style: AppTextStyles.emptyScreenText,
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.2)
        ],
      ),
    );
  }
}
