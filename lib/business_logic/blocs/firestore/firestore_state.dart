part of 'firestore_bloc.dart';

abstract class FirestoreState extends Equatable {
  const FirestoreState();
  
  @override
  List<Object> get props => [];
}

class FirestoreInitial extends FirestoreState {}

class FirestoreMessagesLoading extends FirestoreState {}

class FirestoreMessagesLoaded extends FirestoreState {
  List<Message> messages;
  FirestoreMessagesLoaded(this.messages);
}

class FirestoreMessagesLoadingError extends FirestoreState {}

class FirestoreMessageSending extends FirestoreState {}

class FirestoreMessageSended extends FirestoreState {}

class FirestoreMessageSendingError extends FirestoreState {}