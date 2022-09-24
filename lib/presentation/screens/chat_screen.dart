import 'dart:async';

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

class ChatScreen extends StatefulWidget {
  Contact _contact;

  ChatScreen(this._contact, {super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? _userId;

  Timer? _refreshTimer;

  final TextEditingController _messageController = TextEditingController();

  List<Message> messages = [];

  @override
  void dispose() {
    _refreshTimer!.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _userId = Provider.of<AuthenticationBloc>(context).user.uid!;
    widget._contact.newMessages = 0;

    ScrollController _listViewController = ScrollController();

    return BlocProvider(
        create: (context) => FirestoreBloc(),
        child: Builder(builder: (context) {
          if (_refreshTimer != null) {
            _refreshTimer!.cancel();
          }
          Provider.of<FirestoreBloc>(context, listen: false).add(
              FirestoreFetchMessagesOffline(widget._contact.uid, _userId!));
          _refreshTimer = Timer.periodic(Duration(seconds: 5), (timer) {
            widget._contact.newMessages = 0;

            Provider.of<FirestoreBloc>(context, listen: false).add(
                FirestoreFetchMessagesOffline(widget._contact.uid, _userId!));
          });

          return Scaffold(
            appBar: HomeAppBar(widget._contact.uid, true),
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
                              reverse: true,
                              controller: _listViewController,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                List<Message> _reversedList =
                                    new List.from(messages.reversed);
                                print(_reversedList[index]);
                                if (_reversedList[index].uidSender == _userId) {
                                  return MessageListTile(_reversedList[index],
                                      MessageListTileType.user);
                                } else {
                                  return MessageListTile(_reversedList[index],
                                      MessageListTileType.contact);
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
                                  if (_messageController.text == "" ||
                                      _messageController.text.isEmpty) {
                                    return;
                                  }
                                  messages.add(Message(
                                      messageId: "69420",
                                      content: _messageController.text,
                                      uidSender: _userId!,
                                      uidReceiver: widget._contact.uid,
                                      timestamp:
                                          DateTime.now().toIso8601String()));
                                  Provider.of<FirestoreBloc>(context,
                                          listen: false)
                                      .add(FirestoreSendMessage(Message(
                                          messageId: "69420",
                                          uidSender:
                                              Provider.of<AuthenticationBloc>(
                                                      context,
                                                      listen: false)
                                                  .user
                                                  .uid!,
                                          uidReceiver: widget._contact.uid,
                                          timestamp:
                                              DateTime.now().toIso8601String(),
                                          content: _messageController.text)));
                                  final position = _listViewController
                                      .position.minScrollExtent;
                                  _listViewController.jumpTo(position);
                                })
                          ])
                        ]));
              },
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
        }));
  }

  void sendMessage(String text, BuildContext context) {}
}
