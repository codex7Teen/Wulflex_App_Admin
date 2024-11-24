part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoriesLoaded extends CategoryState {
  final List<String> defaultCategories;
  final List<String> customCategories;

  const CategoriesLoaded({
    required this.defaultCategories,
    required this.customCategories,
  });

  List<String> get allCategories => [...defaultCategories, ...customCategories];

  @override
  List<Object> get props => [defaultCategories, customCategories];
}

class CategoryError extends CategoryState {
  final String message;

  const CategoryError(this.message);

  @override
  List<Object> get props => [message];
}
