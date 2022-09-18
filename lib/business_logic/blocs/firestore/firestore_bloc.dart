import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:newwfirst/data/model/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'firestore_event.dart';
part 'firestore_state.dart';

class FirestoreBloc extends Bloc<FirestoreEvent, FirestoreState> {
  FirestoreBloc() : super(FirestoreInitial()) {
    on<FirestoreFetchMessages>(
        (event, emit) => _fetchMessagesEvent(event, emit));
    on<FirestoreSendMessage>((event, emit) => _sendMessage(event, emit));
  }

  Future<void> _fetchMessagesEvent(
      FirestoreFetchMessages event, Emitter<FirestoreState> emit) async {
    await _fetchMessages(event._userUid, event._contactUid, emit);
  }

  Future<void> _fetchMessages(
      String userId, String contactUid, Emitter<FirestoreState> emit) async {
    emit(FirestoreMessagesLoading());
    try {
      List<Message> newMessages =
          await _fetchMessagesOnline(userId, contactUid);

      newMessages = new List.from(newMessages)
        ..addAll(await _fetchMessagesOffline(userId, contactUid));
      emit(FirestoreMessagesLoaded(newMessages));
    } on Exception catch (e) {
      emit(FirestoreMessagesLoadingError());
    }
  }

  Future<List<Message>> _fetchMessagesOnline(
      String userId, String contactUid) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("contacts")
        .doc(userId)
        .collection("messages")
        .get();
    final newMessagesMap = snapshot.docs.map((doc) => doc.data()).toList();
    List<Message> newMessages = [];
    newMessagesMap.forEach((element) =>
        newMessages.add(Message.fromMap(element as Map<String, dynamic>)));
    return newMessages;
  }

  Future<List<Message>> _fetchMessagesOffline(
      String userId, String contactUid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Message> newMessages = [];

    List<String>? messagesJSON = prefs.getStringList(
        userId + "__///__" + contactUid + "__///__" + "messages");
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
      _sendMessageOffline(
          event.message, event.message.uidSender, event.message.uidReceiver);
      await _fetchMessages(event.message.uidSender, event.message.uidReceiver, emit);
      emit(FirestoreMessageSended());
    } on Exception catch (e) {
      emit(FirestoreMessageSendingError());
    }
  }

  Future<void> _sendMessageOffline(
      Message message, String userId, String contactUid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? messagesJSON = prefs.getStringList(
        userId + "__///__" + contactUid + "__///__" + "messages");
    messagesJSON?.add(message.toJson());
    prefs.setStringList(
        userId + "__///__" + contactUid + "__///__" + "messages",
        messagesJSON!);
  }
}
