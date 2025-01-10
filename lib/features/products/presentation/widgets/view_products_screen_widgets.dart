import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/core/config/text_styles.dart';
import 'package:wulflex_admin/data/models/enhanced_review_model.dart';
import 'package:wulflex_admin/data/models/product_model.dart';
import 'package:wulflex_admin/features/products/presentation/screens/image_viewer_screen.dart';
import 'package:wulflex_admin/features/products/presentation/screens/size_chart_screen.dart';
import 'package:wulflex_admin/features/reviews/bloc/review_bloc/review_bloc.dart';
import 'package:wulflex_admin/shared/widgets/custom_weightandsize_selector_container_widget.dart';
import 'package:wulflex_admin/shared/widgets/navigation_helper_widget.dart';

class ViewProductsScreenWidgets {
  static Widget buildItemImageSlider(BuildContext context,
      PageController pageController, ProductModel product) {
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
                          value:
                              downloadProgress.progress, // Shows the progress
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

  static Widget buildPageIndicator(PageController pageController,
      BuildContext context, ProductModel product) {
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

  static Widget buildProductHeadingText(
      BuildContext context, ProductModel product) {
    return Text("${product.brandName} ${product.name}",
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.viewProductMainHeading);
  }

  static Widget buildRatingsContainer() {
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

  static Widget buildSizeAndSizeChartText(
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

  static Widget buildSize(ProductModel product) {
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

  static Widget buildiWeightText(
      ProductModel productModel, BuildContext context) {
    return Visibility(
      visible: productModel.weights.isNotEmpty,
      child: Text(
        'WEIGHT',
        style: AppTextStyles.viewProductTitleText,
      ),
    );
  }

  static Widget buildWeight(ProductModel product) {
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

  static Widget buildDescriptionTitle(BuildContext context) {
    return Text("DESCRIPTION", style: AppTextStyles.viewProductTitleText);
  }

  static Widget buildCategoryText(BuildContext context) {
    return Text("CATEGORY ▼", style: AppTextStyles.viewProductTitleText);
  }

  static Widget buildCategoryDisply(
      BuildContext context, ProductModel product) {
    return Text(product.category, style: AppTextStyles.reviewUsernameText);
  }

  static Widget buildDescription(BuildContext context, bool isExpanded,
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

  static Widget buildReammoreAndReadlessButton(
      bool isExpanded, VoidCallback onTap, BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Align(
          alignment: Alignment.topRight,
          child: Text(isExpanded ? "Read Less" : "Read more",
              style: AppTextStyles.readmoreAndreadLessText)),
    );
  }

  static Widget customReviewProgressPercentageIndicator(BuildContext context,
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

  static Widget buildReviewsHeading() {
    return Text("RATINGS & REVIEWS", style: AppTextStyles.viewProductTitleText);
  }

  static Widget buildReviewMetrics(
      double roundedRating,
      List<EnhancedReviewModel> enhancedReviews,
      BuildContext context,
      String roundedPercentageOfFiveStar,
      String roundedPercentageOfFourStar,
      String roundedPercentageOfThreeStar,
      String roundedPercentageOfTwoStar,
      String roundedPercentageOfOneStar) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(roundedRating.toString(),
                  style: AppTextStyles.viewRatingBigRatingText),
              SizedBox(height: 1.5),
              RatingBar(
                  itemPadding: EdgeInsets.symmetric(horizontal: 2),
                  itemSize: 24,
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
              SizedBox(height: 6),
              Text(
                '${enhancedReviews.length} REVIEWS',
                style: AppTextStyles.buildTotalReviewsText,
              )
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ViewProductsScreenWidgets.customReviewProgressPercentageIndicator(
                context,
                '5',
                roundedPercentageOfFiveStar,
                convertPercentageToDecimal(roundedPercentageOfFiveStar)),
            ViewProductsScreenWidgets.customReviewProgressPercentageIndicator(
                context,
                '4',
                roundedPercentageOfFourStar,
                convertPercentageToDecimal(roundedPercentageOfFourStar)),
            ViewProductsScreenWidgets.customReviewProgressPercentageIndicator(
                context,
                '3',
                roundedPercentageOfThreeStar,
                convertPercentageToDecimal(roundedPercentageOfThreeStar)),
            ViewProductsScreenWidgets.customReviewProgressPercentageIndicator(
                context,
                '2',
                roundedPercentageOfTwoStar,
                convertPercentageToDecimal(roundedPercentageOfTwoStar)),
            ViewProductsScreenWidgets.customReviewProgressPercentageIndicator(
                context,
                '1',
                roundedPercentageOfOneStar,
                convertPercentageToDecimal(roundedPercentageOfOneStar)),
          ],
        )
      ],
    );
  }

  //! Function to convert the percentage string to a decimal value
  static double convertPercentageToDecimal(String percentageString) {
    // Remove the '%' sign and convert to double
    double percentage = double.parse(percentageString.replaceAll('%', ''));
    // convert to a value between 0 and 1
    return percentage / 100.0;
  }

  static Widget buildAllUserReviews(List<EnhancedReviewModel> enhancedReviews) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return SizedBox(height: 8);
      },
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: enhancedReviews.length,
      itemBuilder: (context, index) {
        final reviews = enhancedReviews[index];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
              color: AppColors.whiteThemeColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.appBarLightGreyThemeColor)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  reviews.userImageUrl != null
                      ?
                      // User image
                      SizedBox(
                          height: 46,
                          width: 46,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              imageUrl: reviews.userImageUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) {
                                return Image.asset(
                                    'assets/wulflex_logo_nobg.png');
                              },
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 28,
                          width: 28,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child:
                                  Image.asset('assets/wulflex_logo_nobg.png')),
                        ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Username and date
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 2),
                            Text(reviews.userName,
                                style: AppTextStyles.reviewUsernameText),
                            Text(
                                DateFormat('MMMM d yyyy')
                                    .format(reviews.review.createdAt),
                                style: AppTextStyles.reviewDateText)
                          ],
                        ),
                        // ratings section
                        Row(
                          children: [
                            Text(
                              reviews.review.rating.round().toString(),
                              style: AppTextStyles
                                  .linearProgressIndicatorLeadingText,
                            ),
                            SizedBox(width: 3),
                            RatingBar(
                                itemSize: 17,
                                allowHalfRating: true,
                                initialRating: reviews.review.rating,
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
                                        color: AppColors
                                            .appBarLightGreyThemeColor)),
                                onRatingUpdate: (value) {}),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Visibility(
                  visible: reviews.review.selectedSizeOrWeight.isNotEmpty,
                  child: SizedBox(height: 9)),
              Visibility(
                visible: reviews.review.selectedSizeOrWeight.isNotEmpty,
                child: Text(
                    reviews.review.selectedSizeOrWeight.contains('KG')
                        ? 'Ordered weight: ${reviews.review.selectedSizeOrWeight}'
                        : 'Ordered size: ${reviews.review.selectedSizeOrWeight}',
                    style: AppTextStyles.reviewOrderdSizeorweightText),
              ),
              Visibility(
                  visible: reviews.review.tags.isNotEmpty,
                  child: SizedBox(height: 11)),
              //! Display review tags
              Visibility(
                visible: reviews.review.tags.isNotEmpty,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: reviews.review.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.lightGreyThemeColor,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.sell_rounded,
                              size: 13.5, color: AppColors.darkishGrey),
                          SizedBox(width: 5),
                          Text(tag,
                              style: AppTextStyles.rateScreenSupermini.copyWith(
                                color: AppColors.blackThemeColor,
                              )),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              Visibility(
                  visible: reviews.review.reviewText.isNotEmpty,
                  child: SizedBox(height: 12)),
              Visibility(
                  visible: reviews.review.reviewText.isNotEmpty,
                  child: Text(
                    " \"${reviews.review.reviewText}\" ",
                    style: AppTextStyles.descriptionText,
                  ))
            ],
          ),
        );
      },
    );
  }

  static Widget buildEmptyReviewsDisplay() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset('assets/lottie/no_reviews_lottie.json', width: 200),
          Text(
            'No reviews yet. Check back later\nfor customer insights.',
            textAlign: TextAlign.center,
            style: AppTextStyles.emptySectionText,
          )
        ],
      ),
    );
  }
}
