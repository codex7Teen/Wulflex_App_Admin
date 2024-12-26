import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/core/config/text_styles.dart';
import 'package:wulflex_admin/data/models/product_model.dart';
import 'package:wulflex_admin/features/products/presentation/screens/image_viewer_screen.dart';
import 'package:wulflex_admin/features/products/presentation/screens/size_chart_screen.dart';
import 'package:wulflex_admin/features/reviews/bloc/review_bloc/review_bloc.dart';
import 'package:wulflex_admin/shared/widgets/custom_weightandsize_selector_container_widget.dart';
import 'package:wulflex_admin/shared/widgets/navigation_helper_widget.dart';

Widget buildItemImageSlider(
    BuildContext context, PageController pageController, ProductModel product) {
  return SizedBox(
    height: 300,
    width: MediaQuery.sizeOf(context).width,
    child: PageView.builder(
      controller: pageController,
      itemCount: product.imageUrls.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => NavigationHelper.navigateToWithoutReplacement(context,
              ScreenFullScreenImageViewer(imageUrls: product.imageUrls)),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 250,
                width: 250,
                child: CachedNetworkImage(
                  imageUrl: product.imageUrls[index],
                  fit: BoxFit.contain,
                  progressIndicatorBuilder: (context, url, downloadProgress) {
                    return Center(
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress, // Shows the progress
                      ),
                    );
                  },
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/wulflex_logo_nobg.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget buildPageIndicator(
    PageController pageController, BuildContext context, ProductModel product) {
  return SmoothPageIndicator(
    controller: pageController,
    count: product.imageUrls.length,
    effect: ExpandingDotsEffect(
        activeDotColor: AppColors.blueThemeColor,
        dotColor: AppColors.whiteThemeColor,
        dotHeight: 8,
        dotWidth: 8),
  );
}

Widget buildProductHeadingText(BuildContext context, ProductModel product) {
  return Text("${product.brandName} ${product.name}",
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.viewProductMainHeading);
}

Widget buildRatingsContainer() {
  return IntrinsicWidth(
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGreyThemeColor),
        borderRadius: BorderRadius.circular(25),
      ),
      child: BlocBuilder<ReviewBloc, ReviewState>(
        builder: (context, state) {
          if (state is ReviewLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ReviewError) {
            return Center(child: Text('Review Error'));
          } else if (state is ReviewsLoaded) {
            final enhancedReviews = state.reviews;
            if (enhancedReviews.isNotEmpty) {
              //! GETTING TOTAL RATINGS
              final double averageRating = enhancedReviews
                      .map((enhancedReview) => enhancedReview.review.rating)
                      .reduce((a, b) => a + b) /
                  enhancedReviews.length;
              // rounding off the total ratings
              final roundedRating =
                  double.parse(averageRating.toStringAsFixed(1));
              return Row(
                children: [
                  RatingBar(
                      itemSize: 19,
                      allowHalfRating: true,
                      initialRating: roundedRating,
                      ignoreGestures: true,
                      ratingWidget: RatingWidget(
                          full: Icon(
                            Icons.star_rounded,
                            color: AppColors.blueThemeColor,
                          ),
                          half: Icon(
                            Icons.star_half_rounded,
                            color: AppColors.blueThemeColor,
                          ),
                          empty: Icon(Icons.star_border_rounded,
                              color: AppColors.appBarLightGreyThemeColor)),
                      onRatingUpdate: (value) {}),
                  SizedBox(width: 8),
                  Text(
                    '$roundedRating Ratings',
                    style: AppTextStyles.viewProductratingsText,
                  ),
                ],
              );
            } else {
              return Row(
                children: [
                  RatingBar(
                      itemSize: 19,
                      allowHalfRating: true,
                      initialRating: 0,
                      ignoreGestures: true,
                      ratingWidget: RatingWidget(
                          full: Icon(
                            Icons.star_rounded,
                            color: AppColors.blueThemeColor,
                          ),
                          half: Icon(
                            Icons.star_half_rounded,
                            color: AppColors.blueThemeColor,
                          ),
                          empty: Icon(Icons.star_border_rounded,
                              color: AppColors.greyThemeColor)),
                      onRatingUpdate: (value) {}),
                  SizedBox(width: 8),
                  Text(
                    'No Ratings yet',
                    style: AppTextStyles.viewProductratingsText,
                  ),
                ],
              );
            }
          }
          return Text('Error: Try reloading the page');
        },
      ),
    ),
  );
}

Widget buildSizeAndSizeChartText(
    ProductModel productModel, BuildContext context) {
  return Visibility(
    visible: productModel.sizes.isNotEmpty,
    child: Row(
      children: [
        Text(
          'SIZE',
          style: AppTextStyles.viewProductTitleText,
        ),
        Spacer(),
        GestureDetector(
          onTap: () => NavigationHelper.navigateToWithoutReplacement(
              context, ScreenSizeChart()),
          child: Row(
            children: [
              Icon(
                Icons.straighten_outlined,
                color: AppColors.blueThemeColor,
              ),
              SizedBox(width: 6),
              Text(
                'Size Chart',
                style: AppTextStyles.sizeChartText,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildSize(ProductModel product) {
  return Visibility(
    visible: product.sizes.isNotEmpty,
    child: Row(
      children: product.sizes.map((size) {
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: CustomWeightandsizeSelectorContainerWidget(
            weightOrSize: size,
            isSelected: true,
            onTap: () => (),
          ),
        );
      }).toList(),
    ),
  );
}

Widget buildiWeightText(ProductModel productModel, BuildContext context) {
  return Visibility(
    visible: productModel.weights.isNotEmpty,
    child: Text(
      'WEIGHT',
      style: AppTextStyles.viewProductTitleText,
    ),
  );
}

Widget buildWeight(ProductModel product) {
  return Visibility(
    visible: product.weights.isNotEmpty,
    child: Row(
      children: product.weights.reversed.map((weight) {
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: CustomWeightandsizeSelectorContainerWidget(
            weightOrSize: weight,
            isSelected: true,
            onTap: () => (),
          ),
        );
      }).toList(),
    ),
  );
}

Widget buildDescriptionTitle(BuildContext context) {
  return Text("DESCRIPTION", style: AppTextStyles.viewProductTitleText);
}

Widget buildDescription(BuildContext context, bool isExpanded,
    ProductModel product, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Text(
        textAlign: TextAlign.justify,
        style: AppTextStyles.descriptionText,
        overflow: TextOverflow.fade,
        maxLines: isExpanded ? null : 5,
        product.description),
  );
}

Widget buildReammoreAndReadlessButton(
    bool isExpanded, VoidCallback onTap, BuildContext context) {
  return GestureDetector(
    onTap: onTap,
    child: Align(
        alignment: Alignment.topRight,
        child: Text(isExpanded ? "Read Less" : "Read more",
            style: AppTextStyles.readmoreAndreadLessText)),
  );
}

Widget customReviewProgressPercentageIndicator(BuildContext context,
    String leadingText, String trailingText, double progressValue) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(Icons.star_rounded, color: AppColors.blueThemeColor, size: 25),
      SizedBox(width: 3),
      Text(leadingText,
          style: AppTextStyles.linearProgressIndicatorLeadingText),
      SizedBox(width: 3.5),
      SizedBox(
        width: 130,
        child: LinearProgressIndicator(
          color: AppColors.blueThemeColor,
          backgroundColor: AppColors.appBarLightGreyThemeColor,
          borderRadius: BorderRadius.circular(10),
          minHeight: 10,
          value: progressValue,
        ),
      ),
      SizedBox(width: 3.5),
      Text(trailingText,
          style: AppTextStyles.linearProgressIndicatorTrailingText)
    ],
  );
}
