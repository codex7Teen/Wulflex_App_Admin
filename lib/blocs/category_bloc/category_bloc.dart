import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wulflex_admin/services/category_services.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryServices _categoryServices;
  CategoryBloc(this._categoryServices) : super(CategoryInitial()) {
    //! GET ALL CATEGORIES BLOC
    on<LoadCategoriesEvent>((event, emit) async {
      try {
        emit(CategoryLoading());

        // Initialize with default categories
        List<String> defaultCategories = CategoryServices.defaultCategories;
        List<String> customCategories = [];

        // Start listening to category updates
        await emit.forEach(
          _categoryServices.getCategories(),
          onData: (List<String> categories) {
            log('BLOC: Received categories from Firebase: $categories');

            // Separate default and custom categories
            customCategories = categories
                .where((category) => !defaultCategories.contains(category))
                .toList();

            log('BLOC: Custom Categories: $customCategories');

            return CategoriesLoaded(
              defaultCategories: defaultCategories,
              customCategories: customCategories,
            );
          },
          onError: (error, stackTrace) {
            log('Error loading categories: $error');
            return CategoryError('Failed to load categories: $error');
          },
        );
      } catch (error) {
        emit(CategoryError('Failed to load categories: $error'));
      }
    });

    //! ADD CATEGORIES BLOC
    on<AddCategoryEvent>((event, emit) async {
      try {
        emit(CategoryLoading());

        // Check if category already exists in defaults
        if (CategoryServices.defaultCategories.contains(event.categoryName)) {
          emit(CategoryError(
              'This category already exists in default categories'));
          return;
        }

        await _categoryServices.addCategory(event.categoryName);
        emit(CategoryAddSuccess());

        // No need to emit CategoriesLoaded here as the stream will handle that
      } catch (error) {
        emit(CategoryError('Failed to add category: $error'));
      }
    });
  }
}
