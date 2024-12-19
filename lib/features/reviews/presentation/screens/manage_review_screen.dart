import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wulflex_admin/features/products/bloc/product_bloc/product_bloc.dart';
import 'package:wulflex_admin/data/models/product_model.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/features/reviews/presentation/screens/view_review_screen.dart';
import 'package:wulflex_admin/shared/widgets/appbar_with_back_button_widget.dart';
import 'package:wulflex_admin/shared/widgets/navigation_helper_widget.dart';

class ScreenManageReviews extends StatefulWidget {
  final String screenTitle;
  const ScreenManageReviews({super.key, required this.screenTitle});

  @override
  State<ScreenManageReviews> createState() => _ScreenManageReviewsState();
}

class _ScreenManageReviewsState extends State<ScreenManageReviews> {
  List<ProductModel> _filteredProducts = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load all products initially
    context.read<ProductBloc>().add(LoadProducts());
  }

  // Filter products
  void _filterProducts(List<ProductModel> products) {
    if (_searchQuery.isEmpty) {
      _filteredProducts = products;
    } else {
      _filteredProducts = products.where((product) {
        return product.brandName
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            product.description
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            product.category.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppbarWithbackbuttonWidget(appBarTitle: widget.screenTitle),
      backgroundColor: AppColors.whiteThemeColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 18, right: 18, top: 15),
          child: Column(
            children: [
              // Search Container
              Container(
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
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                          // Get current products from bloc state and filter
                          if (context.read<ProductBloc>().state
                              is ProductLoaded) {
                            final products = (context.read<ProductBloc>().state
                                    as ProductLoaded)
                                .products;
                            _filterProducts(products);
                          }
                        },
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
              ),

              SizedBox(height: 22),

              // Products List
              BlocBuilder<ProductBloc, ProductState>(
                buildWhen: (previous, current) =>
                    current is ProductLoading ||
                    current is ProductLoaded ||
                    current is ProductError,
                builder: (context, state) {
                  if (state is ProductLoading && _filteredProducts.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is ProductError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else if (state is ProductLoaded) {
                    if (_searchQuery.isEmpty) {
                      _filteredProducts = state.products;
                    }

                    if (_filteredProducts.isEmpty) {
                      return Center(
                        child: Text(
                          'No products found! 😔',
                          style: GoogleFonts.robotoCondensed(
                            fontSize: 20,
                            color: AppColors.blackThemeColor,
                            letterSpacing: 1,
                          ),
                        ),
                      );
                    }

                    // Show product card
                    return Expanded(
                      child: ListView.separated(
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          return buildItemCard(
                              context, _filteredProducts[index]);
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 15);
                        },
                      ),
                    );
                  }
                  return Center(
                    child: Text(
                      'Start searching for products...',
                      style: GoogleFonts.robotoCondensed(
                        fontSize: 20,
                        color: AppColors.blackThemeColor,
                        letterSpacing: 1,
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  // Build Item Card Widget
  Widget buildItemCard(BuildContext context, ProductModel product) {
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
                  Column(
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
