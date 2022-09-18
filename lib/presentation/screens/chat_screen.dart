import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newwfirst/business_logic/blocs/authentication/authentication_bloc.dart';
import 'package:newwfirst/business_logic/blocs/firestore/firestore_bloc.dart';
import 'package:newwfirst/data/model/contact.dart';
import 'package:newwfirst/data/model/message.dart';
import 'package:newwfirst/presentation/widgets/app_bar.dart';
import 'package:newwfirst/presentation/widgets/dialogs/loading_dialog.dart';
import 'package:newwfirst/presentation/widgets/message_list_tile.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  Contact _contact;
  String? _userId;

  final TextEditingController _messageController = TextEditingController();
  List<Message> messages = [];

  ChatScreen(this._contact, {super.key});

  @override
  Widget build(BuildContext context) {
    _userId = Provider.of<AuthenticationBloc>(context).user.uid!;
    return BlocProvider(
        create: (context) => FirestoreBloc(),
        child: Builder(builder: (context) {
          Provider.of<FirestoreBloc>(context, listen: false).add(
              FirestoreFetchMessages(
                  Provider.of<AuthenticationBloc>(context).user.uid!,
                  _contact.uid));
          return Scaffold(
              appBar: HomeAppBar(_contact.uid, true),
              body: BlocConsumer<FirestoreBloc, FirestoreState>(
                listener: (context, state) {
                  if (state is FirestoreMessageSending ||
                      state is FirestoreMessagesLoading) {
                    showDialog(
                        // The user CANNOT close this dialog  by pressing outsite it
                        barrierDismissible: false,
                        context: context,
                        builder: (_) {
                          return LoadingDialog();
                        });
                  } else if (state is FirestoreMessageSended) {
                    Navigator.pop(context);
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _messageController.clear();
                  } else if (state is FirestoreMessagesLoaded) {
                    final _messageLoaded = state as FirestoreMessagesLoaded;
                    messages = _messageLoaded.messages;
                    Navigator.pop(context);
                  }
                },
                builder: (context, state) {
                  return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  if (messages[index].uidSender == _userId) {
                                    return MessageListTile(messages[index],
                                        MessageListTileType.contact);
                                  } else {
                                    return MessageListTile(messages[index],
                                        MessageListTileType.user);
                                  }
                                },
                              ),
                            ),
                            Row(children: [
                              Expanded(
                                  child: TextField(
                                      controller: _messageController,
                                      onSubmitted: (value) =>
                                          sendMessage(value, context),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(232))),
                                      ))),
                              IconButton(
                                  icon: Icon(Icons.send),
                                  onPressed: () {
                                    Provider.of<FirestoreBloc>(
                                            context,
                                            listen: false)
                                        .add(FirestoreSendMessage(Message(
                                            messageId: "69420",
                                            uidSender:
                                                Provider.of<AuthenticationBloc>(
                                                        context,
                                                        listen: false)
                                                    .user
                                                    .uid!,
                                            uidReceiver: _contact.uid,
                                            timestamp: DateTime.now()
                                                .toIso8601String(),
                                            content: _messageController.text)));
                                  })
                            ])
                          ]));
                },
              ));
        }));
  }

  void sendMessage(String text, BuildContext context) {}
}
