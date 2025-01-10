import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/data/models/enhanced_review_model.dart';
import 'package:wulflex_admin/data/models/product_model.dart';
import 'package:wulflex_admin/features/products/presentation/widgets/view_products_screen_widgets.dart';
import 'package:wulflex_admin/features/reviews/bloc/review_bloc/review_bloc.dart';
import 'package:wulflex_admin/shared/widgets/animated_price_container_widget.dart';
import 'package:wulflex_admin/shared/widgets/appbar_with_back_button_widget.dart';

class ScreenViewProducts extends StatefulWidget {
  final ProductModel productModel;
  const ScreenViewProducts({super.key, required this.productModel});

  @override
  State<ScreenViewProducts> createState() => _ScreenViewProductsState();
}

class _ScreenViewProductsState extends State<ScreenViewProducts> {
  // Track expand or collapse of the description
  bool isExpanded = false;

  @override
  void initState() {
    context
        .read<ReviewBloc>()
        .add(FetchProductReviewsEvent(productId: widget.productModel.id!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();

    return Scaffold(
        backgroundColor: AppColors.lightGreyThemeColor,
        appBar: AppbarWithbackbuttonWidget(
            appBarTitle: widget.productModel.brandName),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //! ITEM IMAGE WITH SLIDER (PAGEVIEW)
              ViewProductsScreenWidgets.buildItemImageSlider(
                  context, pageController, widget.productModel),
              SizedBox(height: 4),
              ViewProductsScreenWidgets.buildPageIndicator(
                  pageController, context, widget.productModel),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                    color: AppColors.whiteThemeColor),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      ViewProductsScreenWidgets.buildProductHeadingText(
                          context, widget.productModel),
                      SizedBox(height: 14),
                      ViewProductsScreenWidgets.buildCategoryText(context),
                      SizedBox(height: 2),
                      ViewProductsScreenWidgets.buildCategoryDisply(
                          context, widget.productModel),
                      SizedBox(height: 20),
                      ViewProductsScreenWidgets.buildRatingsContainer(),
                      SizedBox(height: 20),
                      ViewProductsScreenWidgets.buildSizeAndSizeChartText(
                          widget.productModel, context),
                      Visibility(
                          visible: widget.productModel.sizes.isNotEmpty,
                          child: SizedBox(height: 8)),
                      ViewProductsScreenWidgets.buildSize(widget.productModel),
                      ViewProductsScreenWidgets.buildiWeightText(
                          widget.productModel, context),
                      Visibility(
                          visible: widget.productModel.weights.isNotEmpty,
                          child: SizedBox(height: 8)),
                      ViewProductsScreenWidgets.buildWeight(
                          widget.productModel),
                      SizedBox(height: 24),
                      AnimatedPriceContainer(product: widget.productModel),
                      SizedBox(height: 24),
                      ViewProductsScreenWidgets.buildDescriptionTitle(context),
                      SizedBox(height: 6),
                      ViewProductsScreenWidgets.buildDescription(
                          context,
                          isExpanded,
                          widget.productModel,
                          () => setState(() {
                                isExpanded = !isExpanded;
                              })),
                      ViewProductsScreenWidgets.buildReammoreAndReadlessButton(
                          isExpanded,
                          () => setState(() {
                                isExpanded = !isExpanded;
                              }),
                          context),
                      SizedBox(height: 24),
                      ViewProductsScreenWidgets.buildReviewsHeading(),
                      SizedBox(height: 6),
                      BlocBuilder<ReviewBloc, ReviewState>(
                          builder: (context, state) {
                        if (state is ReviewLoading) {
                          return Center(child: CircularProgressIndicator());
                        } else if (state is ReviewError) {
                          return Center(child: Text('Failed to load reviews.'));
                        } else if (state is ReviewsLoaded) {
                          //! Sort reviews by date in descendin order (latest first)
                          final enhancedReviews =
                              List<EnhancedReviewModel>.from(state.reviews)
                                ..sort((a, b) => b.review.createdAt
                                    .compareTo(a.review.createdAt));
                          if (enhancedReviews.isNotEmpty) {
                            //! GETTING TOTAL RATINGS
                            final double averageRating = enhancedReviews
                                    .map((enhancedReview) =>
                                        enhancedReview.review.rating)
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
                            final percentageOfOnestar =
                                (countOfOnestar / totalReviews) * 100;
                            final percentageOfTwostar =
                                (countOfTwostar / totalReviews) * 100;
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

                            return Column(
                              children: [
                                ViewProductsScreenWidgets.buildReviewMetrics(
                                    roundedRating,
                                    enhancedReviews,
                                    context,
                                    roundedPercentageOfFiveStar,
                                    roundedPercentageOfFourStar,
                                    roundedPercentageOfThreeStar,
                                    roundedPercentageOfTwoStar,
                                    roundedPercentageOfOneStar),
                                SizedBox(height: 20),
                                ViewProductsScreenWidgets.buildAllUserReviews(
                                    enhancedReviews)
                              ],
                            );
                          } else {
                            return ViewProductsScreenWidgets
                                .buildEmptyReviewsDisplay();
                          }
                        }
                        return Center(child: Text("Something went wrong"));
                      }),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
