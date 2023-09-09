import 'dart:async';

import 'package:Molhem/data/models/animal.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../auth_status_bloc/auth_status_bloc.dart';

part 'learn_event.dart';
part 'learn_state.dart';

class LearnBloc extends Bloc<LearnEvent, LearnState> {
  LearnBloc() : super(LearnInitial()) {
    on<LoadTopicItems>((event, emit) async{
      emit(TopicItemsLoading());
      try{
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        QuerySnapshot data = await firestore
            .collection('users')
            .doc(event.userId)
            .collection('child-learning')
            .doc(event.topicId)
            .collection('items').get();
        List<CategoryInformation> items = data.docs.map((item) => CategoryInformation.fromFirestore(item)).toList();

        if(items.isEmpty){
          emit(TopicsAreEmpty(message: 'no items were found'));
        }else{
          emit(TopicItemsLoadSuccess(items: items));
        }
      }catch(error){
        emit(TopicItemsLoadFailure(message: 'something went wrong',topicId: event.topicId));
      }
    });
  }
}
