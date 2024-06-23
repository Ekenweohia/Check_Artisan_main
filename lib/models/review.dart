// lib/models/review.dart
import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String title;
  final String content;
  final String reviewer;
  final DateTime reviewDate;

  Review({
    required this.title,
    required this.content,
    required this.reviewer,
    required this.reviewDate,
  });

  @override
  List<Object> get props => [title, content, reviewer, reviewDate];
}
