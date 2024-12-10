import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wulflex_admin/blocs/product_bloc/product_bloc.dart';
import 'package:wulflex_admin/models/product_model.dart';
import 'package:wulflex_admin/screens/main_screens/product_screens/inventory_screens/edit_product_screen.dart';
import 'package:wulflex_admin/utils/consts/app_colors.dart';
import 'package:wulflex_admin/widgets/appbar_with_back_button_widget.dart';
import 'package:wulflex_admin/widgets/alert_boxes_widgets.dart';
import 'package:wulflex_admin/widgets/custom_snacbar.dart';
import 'package:wulflex_admin/widgets/navigation_helper_widget.dart';

class ScreenViewInventory extends StatefulWidget {
  final String screenTitle;
  const ScreenViewInventory({super.key, required this.screenTitle});

  @override
  State<ScreenViewInventory> createState() => _ScreenViewInventoryState();
}

class _ScreenViewInventoryState extends State<ScreenViewInventory> {
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

    return BlocListener<ProductBloc, ProductState>(
      listenWhen: (previous, current) => current is ProductDeleteSuccess,
      listener: (context, state) {
        if (state is ProductDeleteSuccess) {
          CustomSnackbar.showCustomSnackBar(
              context, 'Product deleted successfully... 🎉🎉🎉');
        }
      },
      child: Scaffold(
        appBar: AppbarWithbackbuttonWidget(appBarTitle: widget.screenTitle),
        backgroundColor: AppColors.lightScaffoldColor,
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
                              final products = (context
                                      .read<ProductBloc>()
                                      .state as ProductLoaded)
                                  .products;
                              _filterProducts(products);
                            }
                          },
                          style: GoogleFonts.robotoCondensed(
                            fontSize: 18,
                            color: AppColors.darkScaffoldColor,
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
                              color: AppColors.darkScaffoldColor,
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
                          color: AppColors.darkScaffoldColor,
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
      ),
    );
  }

  // Build Item Card Widget
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
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 84, // Fixed height
              width: MediaQuery.of(context).size.width * 0.21,
              child: Image.network(
                product.imageUrls[0],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset('assets/wulflex_logo_nobg.png'),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: SizedBox(
                      width: 26,
                      height: 26,
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
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
                    color: AppColors.darkScaffoldColor,
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
                    color: AppColors.darkScaffoldColor,
                    fontSize: 18,
                    letterSpacing: 1,
                  ),
                ),
              ],
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
                            color: AppColors.darkScaffoldColor,
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
                            color: AppColors.darkScaffoldColor,
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
}
