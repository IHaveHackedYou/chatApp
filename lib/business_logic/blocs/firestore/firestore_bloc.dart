import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:newwfirst/data/model/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'firestore_event.dart';
part 'firestore_state.dart';

class FirestoreBloc extends Bloc<FirestoreEvent, FirestoreState> {
  FirestoreBloc() : super(FirestoreInitial()) {
    on<FirestoreFetchMessagesOffline>((event, emit) =>
        _fetchMessagesOffline(event._userUid, event._contactUid, emit));
    on<FirestoreFetchMessagesOnline>(
        (event, emit) => _fetchMessagesOnline(event._userUid, emit));
    on<FirestoreSendMessage>((event, emit) => _sendMessage(event, emit));
  }

  Future<List<Message>> _fetchMessagesOnline(
      String userId, Emitter<FirestoreState> emit) async {

    emit(FirestoreMessagesLoading());
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("contacts")
        .doc(userId)
        .collection("messages")
        .get();
    final newMessagesMap = await snapshot.docs.map((doc) => doc.data()).toList();
    List<Message> newMessages = [];
    newMessagesMap.forEach((element) =>
        newMessages.add(Message.fromMap(element as Map<String, dynamic>)));
    newMessages.sort((a, b) {
      return a.timestamp.compareTo(b.timestamp);
    });
    print("NEW ONLINE MESSAGES");
    print(newMessages);
    try {
      await _saveMessagesOffline(newMessages, userId);
      FirebaseFirestore.instance
          .collection("contacts")
          .doc(userId)
          .collection("messages")
          .get()
          .then(
        (value) {
          for (DocumentSnapshot ds in snapshot.docs) {
            ds.reference.delete();
          }
        },
      );
    } on Exception catch (e) {}
    emit(FirestoreMessagesLoaded(newMessages));
    return newMessages;
  }

  Future<List<Message>> _fetchMessagesOffline(
      String userId, String contactUid, Emitter<FirestoreState> emit) async {
    emit(FirestoreMessagesLoading());
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
    print("FETCH OFFLINE");
    emit(FirestoreMessagesLoaded(newMessages));
    return newMessages;
  }

  Future<void> _sendMessage(
      FirestoreSendMessage event, Emitter<FirestoreState> emit) async {
    emit(FirestoreMessageSending());
    try {
      await FirebaseFirestore.instance
          .collection("contacts")
          .doc(event.message.uidReceiver)
          .collection("messages")
          .doc(event.message.messageId)
          .set(event.message.toMap());
      _saveMessageOffline(
          event.message, event.message.uidSender, event.message.uidReceiver);
      // await _fetchMessages(
      //     event.message.uidSender, contactUid: event.message.uidReceiver, emit);
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
    if (messagesJSON == null) {
      messagesJSON = [];
    }
    messagesJSON.add(message.toJson());
    print("SAVE OFFLINE");
    prefs.setStringList(
        userId + "__///__" + contactUid + "__///__" + "messages", messagesJSON);
  }

  Future<void> _saveMessagesOffline(List<Message> messages, String userId) async {
    messages.forEach(
      (element) async {
        await _saveMessageOffline(
            element, userId, element.uidSender);
      },
    );
  }
}
