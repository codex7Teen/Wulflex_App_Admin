import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/data/models/product_model.dart';
import 'package:wulflex_admin/features/reviews/presentation/screens/view_review_screen.dart';
import 'package:wulflex_admin/shared/widgets/navigation_helper_widget.dart';

class ManageReviewScreenWidgets {
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
                hintText: 'Search by product or category',
                hintStyle: GoogleFonts.robotoCondensed(
                  fontSize: 18,
                  color: AppColors.darkishGrey,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build Item Card Widget
  static Widget buildItemCard(BuildContext context, ProductModel product) {
    return GestureDetector(
      onTap: () => NavigationHelper.navigateToWithoutReplacement(
          context, ScreenViewReview(product: product)),
      child: Container(
        padding: EdgeInsets.all(13),
        width: MediaQuery.of(context).size.width, // Full width
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

            SizedBox(width: 14),

            // Product Details
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
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
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 19, color: AppColors.greyThemeColor)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
