import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wulflex_admin/data/models/enhanced_review_model.dart';
import 'package:wulflex_admin/data/services/review_services.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewServices _reviewServices;
  ReviewBloc(this._reviewServices) : super(ReviewInitial()) {
    //! FETCH PRODUCT REVIEWS
    on<FetchProductReviewsEvent>((event, emit) async {
      emit(ReviewLoading());
      try {
        final reviewStream =
            _reviewServices.getProductReviewsWithUserDetails(event.productId);
        log('BLOC: REVIEWS LOADED');
        await for (var reviews in reviewStream) {
          emit(ReviewsLoaded(reviews));
        }
      } catch (error) {
        log('BLOC: REVIEWS ERROR $error');
        emit(ReviewError(error.toString()));
      }
    });

    //! DELETE PRODUCT REVIEW
    on<DeleteReviewEvent>((event, emit) async {
      try {
        await _reviewServices.deleteReview(event.reviewId);
        // Emit a temporary success state
        emit(ReviewDeletedSuccess());
  
        // Delay to allow snackbar to show
        await Future.delayed(Duration(milliseconds: 500));

        // Then fetch updated reviews
        final reviewStream =
            _reviewServices.getProductReviewsWithUserDetails(event.productId);
        await for (var reviews in reviewStream) {
          emit(ReviewsLoaded(reviews));
        }
      } catch (error) {
        log('BLOC: DELETE REVIEW ERROR $error');
        emit(ReviewError(error.toString()));
      }
    });
  }
}
