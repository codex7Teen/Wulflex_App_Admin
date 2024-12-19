part of 'review_bloc.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object> get props => [];
}

class FetchProductReviewsEvent extends ReviewEvent {
  final String productId;

  FetchProductReviewsEvent({required this.productId});

  @override
  List<Object> get props => [productId];
}

class DeleteReviewEvent extends ReviewEvent {
  final String reviewId;
  final String productId;

  DeleteReviewEvent({required this.reviewId, required this.productId});

  @override
  List<Object> get props => [productId, reviewId];
}
