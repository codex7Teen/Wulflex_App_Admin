part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

//! Get Categories
class LoadCategoriesEvent extends CategoryEvent {}

//! Add Categories
class AddCategoryEvent extends CategoryEvent {
  final String categoryName;

  const AddCategoryEvent(this.categoryName);

  @override
  List<Object> get props => [categoryName];
}
