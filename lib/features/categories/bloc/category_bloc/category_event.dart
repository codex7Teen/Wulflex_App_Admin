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
  final File categoryImage;

  const AddCategoryEvent(this.categoryName, this.categoryImage);

  @override
  List<Object> get props => [categoryName, categoryImage];
}

//! Load Category with all details
class LoadCategoryDetailsEvent extends CategoryEvent {}

//! EDIT CATEGORY EVENT
class EditCategoryEvent extends CategoryEvent {
  final String categoryId;
  final String newCategoryName;
  final File? newImageFile;

  EditCategoryEvent(
      {required this.categoryId,
      required this.newCategoryName,
      this.newImageFile});

  @override
  List<Object> get props => [categoryId, newCategoryName, newImageFile!];
}

//! DELETE CATEGORY EVENT
class DeleteCategoryEvent extends CategoryEvent {
  final String categoryId;

  DeleteCategoryEvent({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}
