import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Review Model
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

// Review Event
abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object> get props => [];
}

class FetchReviews extends ReviewEvent {}

// Review State
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

// Review Bloc
class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  ReviewBloc() : super(ReviewLoading()) {
    on<FetchReviews>((event, emit) async {
      // Simulate a network request
      await Future.delayed(Duration(seconds: 2));
      try {
        // Replace with your data fetching logic
        final reviews = [
          Review(
            title: 'Food',
            content: 'Wonderful service',
            reviewer: 'Irozuru',
            reviewDate: DateTime.parse('2024-05-01T13:12:15.000000Z'),
          ),
          Review(
            title: 'Wedding Planner',
            content:
                'A good vendor to work with. My wedding was a huge success. Thanks to your glorious team from Heaven. When I marry next I will still use you guys.',
            reviewer: 'Irozuru',
            reviewDate: DateTime.parse('2024-05-01T13:12:15.000000Z'),
          ),
          // Add more reviews here
        ];
        emit(ReviewLoaded(reviews));
      } catch (e) {
        emit(ReviewError());
      }
    });
  }
}

// Reviews Screen
class ReviewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReviewBloc()..add(FetchReviews()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Reviews'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                // Handle notifications
              },
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
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: (value) {
                  // Handle search
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<ReviewBloc, ReviewState>(
                builder: (context, state) {
                  if (state is ReviewLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is ReviewLoaded) {
                    return ListView.separated(
                      itemCount: state.reviews.length,
                      separatorBuilder: (context, index) => Divider(),
                      itemBuilder: (context, index) {
                        final review = state.reviews[index];
                        return ListTile(
                          title: Row(
                            children: [
                              Icon(Icons.thumb_up, color: Colors.teal),
                              SizedBox(width: 8),
                              Text(review.title,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(review.content),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.star,
                                      color: Colors.amber, size: 16),
                                  SizedBox(width: 4),
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
                    return Center(child: Text('Failed to fetch reviews'));
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
