import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:check_artisan/bloc/quote_bloc.dart';
import '../bloc/quote_event.dart';
import '../bloc/quote_state.dart';

class QuoteRequestsScreen extends StatelessWidget {
  const QuoteRequestsScreen({Key? key,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuoteBloc()..add(FetchQuotes()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quote Requests'),
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
                          title: Text(quote.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Location: ${quote.location}'),
                              Text('Budget: ${quote.budget}'),
                              Text(
                                  'Posted: ${quote.postedDate.toIso8601String()}'),
                            ],
                          ),
                          trailing: const Icon(Icons.info_outline,
                              color: Colors.teal),
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
