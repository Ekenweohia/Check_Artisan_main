
// lib/bloc/review_event.dart
import 'package:equatable/equatable.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object> get props => [];
}

class FetchReviews extends ReviewEvent {}