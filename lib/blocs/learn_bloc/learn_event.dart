part of 'learn_bloc.dart';

abstract class LearnEvent extends Equatable {
  const LearnEvent();
}

class LoadTopicItems extends LearnEvent {
  final String topicId;
  final String userId;

  const LoadTopicItems({ required this.topicId, required this.userId });

  @override
  List<Object?> get props => [topicId];
}