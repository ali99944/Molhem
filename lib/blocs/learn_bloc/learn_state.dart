part of 'learn_bloc.dart';

abstract class LearnState extends Equatable {
  const LearnState();
}

class LearnInitial extends LearnState {
  @override
  List<Object> get props => [];
}

class TopicItemsLoadSuccess extends LearnState {
  final List<CategoryInformation> items;
  const TopicItemsLoadSuccess({ required this.items });
  @override
  List<Object> get props => [items];
}

class TopicItemsLoadFailure extends LearnState {
  final String message;
  final String topicId;
  const TopicItemsLoadFailure({ required this.message, required this.topicId });
  @override
  List<Object> get props => [message,topicId];
}

class TopicItemsLoading extends LearnState {
  @override
  List<Object> get props => [];
}

class TopicsAreEmpty extends LearnState {
  final String message;
  const TopicsAreEmpty({ required this.message });

  @override
  List<Object> get props => [message];
}