import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Quote {
  final String title;
  final String location;
  final String budget;
  final DateTime postedDate;

  Quote({
    required this.title,
    required this.location,
    required this.budget,
    required this.postedDate,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      title: json['title'],
      location: json['location'],
      budget: json['budget'],
      postedDate: DateTime.parse(json['postedDate']),
    );
  }
}

abstract class QuoteEvent extends Equatable {
  const QuoteEvent();

  @override
  List<Object> get props => [];
}

class FetchQuotes extends QuoteEvent {}

abstract class QuoteState extends Equatable {
  const QuoteState();

  @override
  List<Object> get props => [];
}

class QuoteInitial extends QuoteState {}

class QuoteLoading extends QuoteState {}

class QuoteLoaded extends QuoteState {
  final List<Quote> quotes;

  const QuoteLoaded(this.quotes);

  @override
  List<Object> get props => [quotes];
}

class QuoteError extends QuoteState {
  final String error;

  const QuoteError(this.error);

  @override
  List<Object> get props => [error];
}

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  final bool useApi;

  QuoteBloc({this.useApi = true}) : super(QuoteInitial()) {
    on<FetchQuotes>(_onFetchQuotes);
  }

  Future<void> _onFetchQuotes(
      FetchQuotes event, Emitter<QuoteState> emit) async {
    emit(QuoteLoading());

    try {
      if (useApi) {
        final response = await http.get(Uri.parse(''));

        if (response.statusCode == 200) {
          final List<dynamic> quoteJson = jsonDecode(response.body);
          final quotes = quoteJson.map((json) => Quote.fromJson(json)).toList();
          emit(QuoteLoaded(quotes));
        } else {
          emit(const QuoteError('Failed to fetch quotes from API'));
        }
      } else {
        await Future.delayed(const Duration(seconds: 1));
        final quotes = List<Quote>.generate(
          6,
          (index) => Quote(
            title: 'Small Chops',
            location: 'Umuahia, Abia',
            budget: 'Under NGN50,000',
            postedDate: DateTime.now(),
          ),
        );
        emit(QuoteLoaded(quotes));
      }
    } catch (e) {
      emit(QuoteError(e.toString()));
    }
  }
}

class QuoteRequestsScreen extends StatelessWidget {
  const QuoteRequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuoteBloc(useApi: false)..add(FetchQuotes()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Quote Requests',
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
                onChanged: (value) {
                  // Handle search
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<QuoteBloc, QuoteState>(
                builder: (context, state) {
                  if (state is QuoteLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is QuoteLoaded) {
                    return ListView.separated(
                      itemCount: state.quotes.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final quote = state.quotes[index];
                        return ListTile(
                          title: Text(
                            quote.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Location: ${quote.location}'),
                              Text('Budget: ${quote.budget}'),
                              Text(
                                'Posted: ${quote.postedDate.toIso8601String()}',
                              ),
                            ],
                          ),
                          trailing: const Icon(
                            Icons.info_outline,
                            color: Colors.teal,
                          ),
                        );
                      },
                    );
                  } else if (state is QuoteError) {
                    return const Center(child: Text('Failed to fetch quotes'));
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
