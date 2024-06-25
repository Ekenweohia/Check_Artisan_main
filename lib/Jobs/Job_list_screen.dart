import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/job_bloc.dart';
import '../bloc/job_event.dart';
import '../bloc/job_state.dart';

class JobListScreen extends StatelessWidget {
  const JobListScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JobBloc()..add(FetchJobs()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Job List'),
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
              child: BlocBuilder<JobBloc, JobState>(
                builder: (context, state) {
                  if (state is JobLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is JobLoaded) {
                    return ListView.separated(
                      itemCount: state.jobs.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final job = state.jobs[index];
                        return ListTile(
                          title: Text('Job Title: ${job.title}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Location: ${job.location}'),
                              Text(
                                'Status: ${job.status}',
                                style: TextStyle(
                                  color: job.status == 'Job Completed'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              Text(
                                  'Posted Date: ${job.postedDate.toIso8601String()}'),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (state is JobError) {
                    return const Center(child: Text('Failed to fetch jobs'));
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
