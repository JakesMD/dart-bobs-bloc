import 'package:example/random_number_fetch_cubit.dart';
import 'package:example/random_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => RandomRepository(),
      child: const MaterialApp(
        title: "Bob's Bloc Example",
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void onShufflePressed(BuildContext context) =>
      context.read<RandomNumberFetchCubit>().fetchRandomNumber();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RandomNumberFetchCubit(
        randomRepository: context.read(),
      ),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text("Bob's Bloc Example")),
          body: Center(
            child: BlocBuilder<RandomNumberFetchCubit, RandomNumberFetchState>(
              builder: (context, state) => switch (state.status) {
                .initial => const Text('Generate a random number!'),
                .inProgress => const CircularProgressIndicator(),
                .succeeded => Text('${state.success}'),
                .failed => Text(
                  switch (state.failure!) {
                    .unknown => 'Unknown error occurred.',
                    .overflow => 'Error: Overflowed',
                  },
                ),
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => onShufflePressed(context),
            child: const Icon(Icons.shuffle),
          ),
        ),
      ),
    );
  }
}
