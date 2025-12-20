import 'package:bobs_bloc/bobs_bloc.dart';

/// The status of the [BobsBlocState].
enum BobsBlocStatus {
  /// No request has been made yet.
  initial,

  /// The request is currently in progress.
  inProgress,

  /// The request failed.
  failed,

  /// The request succeeded.
  succeeded,
}
