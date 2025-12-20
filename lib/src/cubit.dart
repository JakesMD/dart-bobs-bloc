import 'package:bloc/bloc.dart';
import 'package:bobs_bloc/bobs_bloc.dart';
import 'package:bobs_jobs/bobs_jobs.dart';

/// A mixin that adds request handling capabilities to a Cubit using
/// [BobsBlocState].
mixin BobsCubitMixin<F, S> on Cubit<BobsBlocState<F, S>> {
  /// Performs a request using the provided [job] and updates the Cubit's state
  /// accordingly.
  ///
  /// If a request is already in progress, this method returns immediately
  /// without making a new request.
  Future<void> request(BobsJob<F, S> job) async {
    if (state.isInProgress) return;
    emit(.inProgress(state.outcome));
    emit(.completed(await job.run()));
  }
}
