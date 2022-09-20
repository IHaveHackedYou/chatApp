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
      newMessages.sort((a, b) {
        return a.timestamp.compareTo(b.timestamp);
      });
      emit(FirestoreMessagesLoaded(newMessages));
    } on Exception catch (e) {
      emit(FirestoreMessagesLoadingError());
    }
  }

  Future<List<Message>> _fetchMessagesOnline(
      String userId, String contactUid) async {
        print(userId);
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("contacts")
        .doc(userId)
        .collection("messages")
        .get();
    final newMessagesMap = snapshot.docs.map((doc) => doc.data()).toList();
    List<Message> newMessages = [];
    newMessagesMap.forEach((element) =>
        newMessages.add(Message.fromMap(element as Map<String, dynamic>)));
    try {
      await _saveMessagesOffline(newMessages);
      FirebaseFirestore.instance
        .collection("contacts")
        .doc(userId)
        .collection("messages").get().then((value) {
          for(DocumentSnapshot ds in snapshot.docs){
            ds.reference.delete();
          }
        },);
    } on Exception catch (e) {}
    for (int i = 0; i < newMessages.length; i++) {
      if (newMessages[i].uidReceiver != userId ||
          newMessages[i].uidSender != contactUid) {
        newMessages.remove(newMessages[i]);
      }
    }
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
      _saveMessageOffline(
          event.message, event.message.uidSender, event.message.uidReceiver);
      await _fetchMessages(
          event.message.uidSender, event.message.uidReceiver, emit);
      emit(FirestoreMessageSended());
    } on Exception catch (e) {
      emit(FirestoreMessageSendingError());
    }
  }

  Future<void> _saveMessageOffline(
      Message message, String userId, String contactUid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? messagesJSON = await prefs.getStringList(
        userId + "__///__" + contactUid + "__///__" + "messages");
    if(messagesJSON == null){
      messagesJSON = [];
    }
    messagesJSON.add(message.toJson());
    prefs.setStringList(
        userId + "__///__" + contactUid + "__///__" + "messages",
        messagesJSON);
  }

  Future<void> _saveMessagesOffline(List<Message> messages) async {
    messages.forEach(
      (element) async {
        await _saveMessageOffline(
            element, element.uidSender, element.uidReceiver);
      },
    );
  }
}
