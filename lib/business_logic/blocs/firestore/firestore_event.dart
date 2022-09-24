part of 'firestore_bloc.dart';

abstract class FirestoreEvent extends Equatable {
  const FirestoreEvent();

  @override
  List<Object> get props => [];
}

class FirestoreFetchMessagesOnline extends FirestoreEvent {
  final String _userUid;
  FirestoreFetchMessagesOnline(this._userUid);
}

class FirestoreFetchMessagesOffline extends FirestoreEvent {
  final String _contactUid;
  final String _userUid;
  FirestoreFetchMessagesOffline(this._contactUid, this._userUid);
}

class FirestoreSendMessage extends FirestoreEvent {
  final Message message;
  FirestoreSendMessage(this.message);
}
