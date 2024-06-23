import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/job_bloc.dart';
import '../bloc/job_event.dart';
import '../bloc/job_state.dart';

class JobListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JobBloc()..add(FetchJobs()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Job List'),
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
              child: BlocBuilder<JobBloc, JobState>(
                builder: (context, state) {
                  if (state is JobLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is JobLoaded) {
                    return ListView.separated(
                      itemCount: state.jobs.length,
                      separatorBuilder: (context, index) => Divider(),
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
                    return Center(child: Text('Failed to fetch jobs'));
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
