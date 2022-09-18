part of 'firestore_bloc.dart';

abstract class FirestoreEvent extends Equatable {
  const FirestoreEvent();

  @override
  List<Object> get props => [];
}

class FirestoreFetchMessages extends FirestoreEvent {
  final String _contactUid;
  final String _userUid;
  FirestoreFetchMessages(this._contactUid, this._userUid);
}

class FirestoreSendMessage extends FirestoreEvent {
  final Message message;
  FirestoreSendMessage(this.message);
}
