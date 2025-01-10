import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wulflex_admin/features/products/bloc/product_bloc/product_bloc.dart';
import 'package:wulflex_admin/data/models/product_model.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/features/products/presentation/widgets/view_inventory_screen_widgets.dart';
import 'package:wulflex_admin/shared/widgets/appbar_with_back_button_widget.dart';
import 'package:wulflex_admin/shared/widgets/custom_snacbar.dart';

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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocListener<ProductBloc, ProductState>(
      listenWhen: (previous, current) => current is ProductDeleteSuccess,
      listener: (context, state) {
        if (state is ProductDeleteSuccess) {
          CustomSnackbar.showCustomSnackBar(
              context, 'Product deleted successfully... 🎉🎉🎉');
        } else if (state is ProductUpdateSuccess) {
          CustomSnackbar.showCustomSnackBar(
              context, 'Product updated successfully... 🎉🎉🎉');
        }
      },
      child: Scaffold(
        appBar: AppbarWithbackbuttonWidget(appBarTitle: widget.screenTitle),
        backgroundColor: AppColors.whiteThemeColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 18, right: 18, top: 15),
            child: Column(
              children: [
                //! Search Container
                ViewInventoryScreenWidgets.buildSearchBar(screenWidth, (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                  // Get current products from bloc state and filter
                  if (context.read<ProductBloc>().state is ProductLoaded) {
                    final products =
                        (context.read<ProductBloc>().state as ProductLoaded)
                            .products;
                    _filterProducts(products);
                  }
                }, context, _filterProducts),
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
                            return ViewInventoryScreenWidgets.buildItemCard(
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
      ),
    );
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
}
