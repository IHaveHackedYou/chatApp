import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:newwfirst/data/model/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'firestore_event.dart';
part 'firestore_state.dart';

class FirestoreBloc extends Bloc<FirestoreEvent, FirestoreState> {
  FirestoreBloc() : super(FirestoreInitial()) {
    on<FirestoreFetchMessages>((event, emit) => _fetchMessages(event, emit));
    on<FirestoreSendMessage>((event, emit) => _sendMessage(event, emit));
  }

  Future<void> _fetchMessages(
      FirestoreFetchMessages event, Emitter<FirestoreState> emit) async {
    emit(FirestoreMessagesLoading());
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("contacts")
          .doc(event._userUid)
          .collection("messages")
          .get();
      final newMessagesMap = snapshot.docs.map((doc) => doc.data()).toList();
      List<Message> newMessages = [];
      newMessagesMap.forEach((element) =>
          newMessages.add(Message.fromMap(element as Map<String, dynamic>)));
      newMessages = new List.from(newMessages)
        ..addAll(
            await _fetchMessagesOffline(event._userUid, event._contactUid));
      emit(FirestoreMessagesLoaded(newMessages));
    } on Exception catch (e) {
      emit(FirestoreMessagesLoadingError());
    }
  }

  Future<List<Message>> _fetchMessagesOffline(
      String userId, String contactUid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Message> newMessages = [];

    List<String>? messagesJSON =
        prefs.getStringList(contactUid + "__///__" + "messages");
    messagesJSON?.forEach(((element) {
      newMessages.add(Message.fromJson(element));
    }));
    newMessages.sort((a, b) {
      return a.timestamp.compareTo(b.timestamp);
    });
    return newMessages;
  }

  Future<void> _sendMessage( 
      FirestoreSendMessage event, Emitter<FirestoreState> emit) async {
    emit(FirestoreMessageSending());
    try {
      print(event.message.uidReceiver + "   " + event.message.uidSender);
      await FirebaseFirestore.instance
          .collection("contacts")
          .doc(event.message.uidReceiver)
          .collection("messages")
          .doc(event.message.messageId)
          .set(event.message.toMap());
      emit(FirestoreMessageSended());
    } on Exception catch (e) {
      emit(FirestoreMessageSendingError());
    }
  }
}
