import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Define Review model
class Review extends Equatable {
  final String title;
  final String content;
  final String reviewer;
  final DateTime reviewDate;

  const Review({
    required this.title,
    required this.content,
    required this.reviewer,
    required this.reviewDate,
  });

  @override
  List<Object> get props => [title, content, reviewer, reviewDate];

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      title: json['title'],
      content: json['content'],
      reviewer: json['reviewer'],
      reviewDate: DateTime.parse(json['reviewDate']),
    );
  }
}

// Define Events
abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object> get props => [];
}

class FetchReviews extends ReviewEvent {}

// Define States
abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object> get props => [];
}

class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  final List<Review> reviews;

  const ReviewLoaded(this.reviews);

  @override
  List<Object> get props => [reviews];
}

class ReviewError extends ReviewState {}

// Define BLoC
class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final bool useApi;

  ReviewBloc({this.useApi = false}) : super(ReviewLoading()) {
    on<FetchReviews>((event, emit) async {
      emit(ReviewLoading());
      await Future.delayed(const Duration(seconds: 1));
      try {
        if (useApi) {
          final response = await http.get(Uri.parse(''));

          if (response.statusCode == 200) {
            final List<dynamic> data = json.decode(response.body);
            final reviews =
                data.map((reviewJson) => Review.fromJson(reviewJson)).toList();
            emit(ReviewLoaded(reviews));
          } else {
            emit(ReviewError());
          }
        } else {
          // Placeholder data
          final reviews = List<Review>.generate(
            2,
            (index) => Review(
              title: index == 0 ? 'Food' : 'Wedding Planner',
              content: index == 0
                  ? 'Wonderful service'
                  : 'A good vendor to work with. My wedding was a huge success. Thanks to your glorious team from Heaven. When I marry next I will still use you guys.',
              reviewer: 'Irozuru',
              reviewDate: DateTime.now(),
            ),
          );
          emit(ReviewLoaded(reviews));
        }
      } catch (e) {
        emit(ReviewError());
      }
    });
  }
}

class ReviewsScreen extends StatelessWidget {
  final bool useApi;

  const ReviewsScreen({Key? key, this.useApi = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReviewBloc(useApi: useApi)..add(FetchReviews()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Reviews',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: (value) {},
              ),
            ),
            Expanded(
              child: BlocBuilder<ReviewBloc, ReviewState>(
                builder: (context, state) {
                  if (state is ReviewLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ReviewLoaded) {
                    return ListView.separated(
                      itemCount: state.reviews.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final review = state.reviews[index];
                        return ListTile(
                          title: Row(
                            children: [
                              const Icon(Icons.thumb_up, color: Colors.teal),
                              const SizedBox(width: 8),
                              Text(
                                review.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(review.content),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.amber, size: 13),
                                  const SizedBox(width: 4),
                                  Text(
                                      'Reviewed by ${review.reviewer} on ${review.reviewDate.toIso8601String()}'),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (state is ReviewError) {
                    return const Center(child: Text('Failed to fetch reviews'));
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
