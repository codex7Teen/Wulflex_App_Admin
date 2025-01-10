import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 18, right: 18, top: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ViewReviewScreenWidgets.buildTotalReviewsText(),
                      ViewReviewScreenWidgets.buildTotalReviews(),
                      SizedBox(height: 14),
                      ViewReviewScreenWidgets.buildProductDetailsText(),
                      SizedBox(width: 6),
                      ViewReviewScreenWidgets.buildProductDetailsCard(
                          context, product),
                      SizedBox(height: 17),
                      Text('REVIEWS', style: AppTextStyles.screenSubHeading),
                      SizedBox(height: 4),
                      //! ALL REVIEWS
                      //! GETTING TOTAL RATINGS
                      Column(
                        children: [
                          ViewReviewScreenWidgets.buildReviewMetrics(
                              context,
                              roundedRating,
                              enhancedReviews,
                              roundedPercentageOfFiveStar,
                              roundedPercentageOfFourStar,
                              roundedPercentageOfThreeStar,
                              roundedPercentageOfTwoStar,
                              roundedPercentageOfOneStar),
                          SizedBox(height: 12),
                          ViewReviewScreenWidgets.buildAllUserreviews(
                              enhancedReviews, product)
                        ],
                      )
                    ],
                  ),
                ),
              );
            } else {
              return ViewReviewScreenWidgets.buildEmptyReviewDisplay();
            }
          }
          return Center(
              child: Text('Unknown error has occured. reload the page!'));
        },
      ),
    );
  }
}
