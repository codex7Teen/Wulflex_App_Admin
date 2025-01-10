import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wulflex_admin/features/categories/presentation/widgets/category_products_screen_widgets.dart';
import 'package:wulflex_admin/features/products/bloc/product_bloc/product_bloc.dart';
import 'package:wulflex_admin/data/models/product_model.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/shared/widgets/appbar_with_back_button_widget.dart';
import 'package:wulflex_admin/shared/widgets/custom_snacbar.dart';

class ScreenCategoryProducts extends StatefulWidget {
  final String categoryName;
  const ScreenCategoryProducts({super.key, required this.categoryName});

  @override
  State<ScreenCategoryProducts> createState() => _ScreenCategoryProductsState();
}

class _ScreenCategoryProductsState extends State<ScreenCategoryProducts> {
  List<ProductModel> _filteredProducts = [];
  String _searchQuery = '';
  bool _initialFilterApplied = false; // Add this flag

  @override
  void initState() {
    super.initState();
    // Delay the initial load slightly to avoid build conflicts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductBloc>().add(LoadProducts());
    });
  }

  void _filterProducts(List<ProductModel> products) {
    if (!mounted) return; // Check if widget is still mounted

    var categoryFilteredProducts = products
        .where((product) =>
            product.category.toLowerCase() == widget.categoryName.toLowerCase())
        .toList();

    if (_searchQuery.isEmpty) {
      if (mounted) {
        setState(() {
          _filteredProducts = categoryFilteredProducts;
          _initialFilterApplied = true;
        });
      }
    } else {
      final filtered = categoryFilteredProducts.where((product) {
        return product.brandName
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            product.description
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
      }).toList();

      if (mounted) {
        setState(() {
          _filteredProducts = filtered;
          _initialFilterApplied = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listenWhen: (previous, current) =>
          current is ProductDeleteSuccess ||
          current is ProductLoaded ||
          current is ProductUpdateSuccess,
      listener: (context, state) {
        if (state is ProductDeleteSuccess) {
          CustomSnackbar.showCustomSnackBar(
              context, 'Product deleted successfully... 🎉🎉🎉');

          // Get the current products after deletion
          if (context.read<ProductBloc>().state is ProductLoaded) {
            final products =
                (context.read<ProductBloc>().state as ProductLoaded).products;
            _filterProducts(
                products); // Re-filter the products to update the UI
          }
        } else if (state is ProductUpdateSuccess) {
          CustomSnackbar.showCustomSnackBar(
              context, 'Product updated successfully... 🎉🎉🎉');

          // Get the current products after updation
          if (context.read<ProductBloc>().state is ProductLoaded) {
            final products =
                (context.read<ProductBloc>().state as ProductLoaded).products;
            _filterProducts(
                products); // Re-filter the products to update the UI
          }
        }
        // Move initial filtering to listener
        if (state is ProductLoaded && !_initialFilterApplied) {
          _filterProducts(state.products);
        }
      },
      child: Scaffold(
        appBar: AppbarWithbackbuttonWidget(appBarTitle: widget.categoryName),
        backgroundColor: AppColors.whiteThemeColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: SingleChildScrollView(
              // Added to prevent overflow
              child: Column(
                children: [
                  CategoryProductsScreenWidgets.buildSearchBar(
                    MediaQuery.of(context).size.width,
                    (value) {
                      if (mounted) {
                        setState(() {
                          _searchQuery = value;
                        });
                        if (context.read<ProductBloc>().state
                            is ProductLoaded) {
                          final products = (context.read<ProductBloc>().state
                                  as ProductLoaded)
                              .products;
                          _filterProducts(products);
                        }
                      }
                    },
                    context,
                    _filterProducts,
                  ),
                  const SizedBox(height: 22),
                  BlocBuilder<ProductBloc, ProductState>(
                    buildWhen: (previous, current) =>
                        current is ProductLoading ||
                        current is ProductLoaded ||
                        current is ProductError,
                    builder: (context, state) {
                      if (state is ProductLoading &&
                          _filteredProducts.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (state is ProductError) {
                        return Center(
                          child: Text('Error: ${state.message}'),
                        );
                      }

                      if (_filteredProducts.isEmpty && _searchQuery.isEmpty) {
                        return CategoryProductsScreenWidgets
                            .buildSearchedProductNotFoundDisplay(
                                context, false, '');
                      }

                      if (_filteredProducts.isEmpty) {
                        return CategoryProductsScreenWidgets
                            .buildSearchedProductNotFoundDisplay(
                                context, true, widget.categoryName);
                      }

                      return ListView.separated(
                        shrinkWrap:
                            true, // Added to make the list scroll inside the Column
                        physics:
                            const NeverScrollableScrollPhysics(), // Prevent nested scrolling
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          return CategoryProductsScreenWidgets.buildItemCard(
                            context,
                            _filteredProducts[index],
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 15),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
