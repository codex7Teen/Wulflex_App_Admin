import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/core/config/text_styles.dart';
import 'package:wulflex_admin/data/models/product_model.dart';
import 'package:wulflex_admin/features/reviews/bloc/review_bloc/review_bloc.dart';
import 'package:wulflex_admin/features/reviews/presentation/widgets/view_review_screen_widgets.dart';
import 'package:wulflex_admin/shared/widgets/appbar_with_back_button_widget.dart';
import 'package:wulflex_admin/shared/widgets/custom_snacbar.dart';

class ScreenViewReview extends StatelessWidget {
  final ProductModel product;
  const ScreenViewReview({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    context
        .read<ReviewBloc>()
        .add(FetchProductReviewsEvent(productId: product.id!));
    return Scaffold(
      appBar: AppbarWithbackbuttonWidget(appBarTitle: ''),
      body: BlocConsumer<ReviewBloc, ReviewState>(
        listener: (context, state) {
          if (state is ReviewDeletedSuccess) {
            CustomSnackbar.showCustomSnackBar(
                context, 'Review deleted success...',
                appearFromTop: true);
          }
        },
        builder: (context, state) {
          if (state is ReviewLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ReviewError) {
            return Center(child: Text('Review loading error'));
          } else if (state is ReviewDeletedSuccess) {
            return Center(child: CircularProgressIndicator());
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

              //! GETTING THE PERCENTAGE OF STARS
              // Count number of ratings in each range
              int countOfOnestar = 0;
              int countOfTwostar = 0;
              int countOfThreestar = 0;
              int countOfFourstar = 0;
              int countOfFiveStar = 0;

              for (var enhancedReview in enhancedReviews) {
                if (enhancedReview.review.rating >= 1.0 &&
                    enhancedReview.review.rating <= 1.9) {
                  countOfOnestar++;
                } else if (enhancedReview.review.rating >= 2.0 &&
                    enhancedReview.review.rating <= 2.9) {
                  countOfTwostar++;
                } else if (enhancedReview.review.rating >= 3.0 &&
                    enhancedReview.review.rating <= 3.9) {
                  countOfThreestar++;
                } else if (enhancedReview.review.rating >= 4.0 &&
                    enhancedReview.review.rating <= 4.9) {
                  countOfFourstar++;
                } else if (enhancedReview.review.rating == 5.0) {
                  countOfFiveStar++;
                }
              }
              // Calculate the percentages
              final totalReviews = enhancedReviews.length;
              final percentageOfOnestar = (countOfOnestar / totalReviews) * 100;
              final percentageOfTwostar = (countOfTwostar / totalReviews) * 100;
              final percentageOfThreestar =
                  (countOfThreestar / totalReviews) * 100;
              final percentageOfFourstar =
                  (countOfFourstar / totalReviews) * 100;
              final percentageOfFivestar =
                  (countOfFiveStar / totalReviews) * 100;
              // Rounded percentages in string
              String roundedPercentageOfOneStar =
                  "${percentageOfOnestar.round().toString()}%";
              String roundedPercentageOfTwoStar =
                  "${percentageOfTwostar.round().toString()}%";
              String roundedPercentageOfThreeStar =
                  "${percentageOfThreestar.round().toString()}%";
              String roundedPercentageOfFourStar =
                  "${percentageOfFourstar.round().toString()}%";
              String roundedPercentageOfFiveStar =
                  "${percentageOfFivestar.round().toString()}%";

              //! Function to convert the percentage string to a decimal value
              double convertPercentageToDecimal(String percentageString) {
                // Remove the '%' sign and convert to double
                double percentage =
                    double.parse(percentageString.replaceAll('%', ''));
                // convert to a value between 0 and 1
                return percentage / 100.0;
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 18, right: 18, top: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Reviews',
                          style: AppTextStyles.screenSubHeading),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('12', style: AppTextStyles.reviewsNumberBigText),
                          SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text('Reviews...',
                                style: AppTextStyles.reviewsText),
                          )
                        ],
                      ),
                      SizedBox(height: 14),
                      Text('PRODUCT DETAILS',
                          style: AppTextStyles.screenSubHeading),
                      SizedBox(width: 6),
                      Container(
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.21,
                                  child: CachedNetworkImage(
                                    imageUrl: product.imageUrls[0],
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

                            SizedBox(width: 14),

                            // Product Details
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
                                    "₹${product.offerPrice.round()}",
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
                          ],
                        ),
                      ),
                      SizedBox(height: 14),
                      Text('REVIEWS', style: AppTextStyles.screenSubHeading),

                      //! ALL REVIEWS
                      //! GETTING TOTAL RATINGS

                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(roundedRating.toString(),
                                        style: AppTextStyles
                                            .viewRatingBigRatingText),
                                    SizedBox(height: 1.5),
                                    RatingBar(
                                        itemPadding:
                                            EdgeInsets.symmetric(horizontal: 2),
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
                                            empty: Icon(
                                                Icons.star_border_rounded,
                                                color: AppColors
                                                    .lightGreyThemeColor)),
                                        onRatingUpdate: (value) {}),
                                    SizedBox(height: 6),
                                    Text(
                                      '${enhancedReviews.length} REVIEWS',
                                      style:
                                          AppTextStyles.buildTotalReviewsText,
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customReviewProgressPercentageIndicator(
                                      context,
                                      '5',
                                      roundedPercentageOfFiveStar,
                                      convertPercentageToDecimal(
                                          roundedPercentageOfFiveStar)),
                                  customReviewProgressPercentageIndicator(
                                      context,
                                      '4',
                                      roundedPercentageOfFourStar,
                                      convertPercentageToDecimal(
                                          roundedPercentageOfFourStar)),
                                  customReviewProgressPercentageIndicator(
                                      context,
                                      '3',
                                      roundedPercentageOfThreeStar,
                                      convertPercentageToDecimal(
                                          roundedPercentageOfThreeStar)),
                                  customReviewProgressPercentageIndicator(
                                      context,
                                      '2',
                                      roundedPercentageOfTwoStar,
                                      convertPercentageToDecimal(
                                          roundedPercentageOfTwoStar)),
                                  customReviewProgressPercentageIndicator(
                                      context,
                                      '1',
                                      roundedPercentageOfOneStar,
                                      convertPercentageToDecimal(
                                          roundedPercentageOfOneStar)),
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 12),
                          ListView.separated(
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 8);
                            },
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: enhancedReviews.length,
                            itemBuilder: (context, index) {
                              final reviews = enhancedReviews[index];
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(
                                    color: AppColors.whiteThemeColor,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                        color: AppColors.lightGreyThemeColor)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        // User image
                                        SizedBox(
                                          height: 46,
                                          width: 46,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: CachedNetworkImage(
                                              imageUrl: reviews.userImageUrl!,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) {
                                                return Image.asset(
                                                    'assets/wulflex_logo_nobg.png');
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Username and date
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 2),
                                                  Text(reviews.userName,
                                                      style: AppTextStyles
                                                          .reviewUsernameText),
                                                  Text(
                                                      DateFormat('MMMM d yyyy')
                                                          .format(reviews.review
                                                              .createdAt),
                                                      style: AppTextStyles
                                                          .reviewDateText)
                                                ],
                                              ),
                                              // ratings section
                                              Row(
                                                children: [
                                                  Text(
                                                    reviews.review.rating
                                                        .round()
                                                        .toString(),
                                                    style: AppTextStyles
                                                        .linearProgressIndicatorLeadingText,
                                                  ),
                                                  SizedBox(width: 3),
                                                  RatingBar(
                                                      itemSize: 17,
                                                      allowHalfRating: true,
                                                      initialRating:
                                                          reviews.review.rating,
                                                      ignoreGestures: true,
                                                      ratingWidget:
                                                          RatingWidget(
                                                              full: Icon(
                                                                Icons
                                                                    .star_rounded,
                                                                color: AppColors
                                                                    .blueThemeColor,
                                                              ),
                                                              half: Icon(
                                                                Icons
                                                                    .star_half_rounded,
                                                                color: AppColors
                                                                    .blueThemeColor,
                                                              ),
                                                              empty: Icon(
                                                                  Icons
                                                                      .star_border_rounded,
                                                                  color: AppColors
                                                                      .lightGreyThemeColor)),
                                                      onRatingUpdate:
                                                          (value) {}),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Visibility(
                                        visible: reviews.review
                                            .selectedSizeOrWeight.isNotEmpty,
                                        child: SizedBox(height: 9)),
                                    Visibility(
                                      visible: reviews.review
                                          .selectedSizeOrWeight.isNotEmpty,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              reviews.review
                                                      .selectedSizeOrWeight
                                                      .contains('KG')
                                                  ? 'Ordered weight: ${reviews.review.selectedSizeOrWeight}'
                                                  : 'Ordered size: ${reviews.review.selectedSizeOrWeight}',
                                              style: AppTextStyles
                                                  .reviewOrderdSizeorweightText),
                                          //! DELETE BUTTON
                                          PopupMenuButton<int>(
                                            onSelected: (value) {
                                              if (value == 0) {
                                                // Handle Delete action
                                                context.read<ReviewBloc>().add(
                                                    DeleteReviewEvent(
                                                        reviewId:
                                                            reviews.review.id!,
                                                        productId:
                                                            product.id!));
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
                                                    Icon(Icons.delete,
                                                        color: AppColors
                                                            .darkishGrey),
                                                    SizedBox(width: 8),
                                                    Text(
                                                      'Delete Review',
                                                      style: GoogleFonts
                                                          .robotoCondensed(
                                                        color: AppColors
                                                            .blackThemeColor,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
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
                                        children:
                                            reviews.review.tags.map((tag) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6, horizontal: 16),
                                            decoration: BoxDecoration(
                                              color:
                                                  AppColors.lightGreyThemeColor,
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.sell_rounded,
                                                    size: 13.5,
                                                    color:
                                                        AppColors.darkishGrey),
                                                SizedBox(width: 5),
                                                Text(
                                                  tag,
                                                  style: AppTextStyles
                                                      .rateScreenSupermini
                                                      .copyWith(
                                                          color: AppColors
                                                              .blackThemeColor),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    Visibility(
                                        visible: reviews
                                            .review.reviewText.isNotEmpty,
                                        child: SizedBox(height: 12)),
                                    Visibility(
                                        visible: reviews
                                            .review.reviewText.isNotEmpty,
                                        child: Text(
                                          " \"${reviews.review.reviewText}\" ",
                                          style: AppTextStyles.descriptionText,
                                        ))
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/lottie/no_reviews_lottie.json',
                        width: 200),
                    Text(
                      'No reviews yet. Check back later\nfor customer insights.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.emptySectionText,
                    ),
                    SizedBox(height: 80)
                  ],
                ),
              );
            }
          }
          return Center(
              child: Text('Unknown error has occured. reload the page'));
        },
      ),
    );
  }
}
