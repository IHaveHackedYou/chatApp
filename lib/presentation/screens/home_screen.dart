import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newwfirst/business_logic/blocs/authentication/authentication_bloc.dart';
import 'package:newwfirst/business_logic/blocs/firestore/firestore_bloc.dart';
import 'package:newwfirst/business_logic/cubits/contact/contact_cubit.dart';
import 'package:newwfirst/data/model/contact.dart';
import 'package:newwfirst/presentation/widgets/app_bar.dart';
import 'package:newwfirst/presentation/widgets/contact_add_bottom_sheet.dart';
import 'package:newwfirst/presentation/widgets/contact_list_tile.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ContactCubit? _cubit;
  static Timer? _refreshTimer;

  String? _userId;
  @override
  void dispose() {
    _refreshTimer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _userId = Provider.of<AuthenticationBloc>(context).user.uid!;
    return WillPopScope(
      onWillPop: (() async => false),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ContactCubit(),
          ),
          BlocProvider(
            create: (context) => FirestoreBloc(),
          ),
        ],
        child: Builder(builder: (context) {
          if (_refreshTimer != null) _refreshTimer!.cancel();
          _refreshTimer = Timer.periodic(Duration(seconds: 5), (timer) {
            Provider.of<FirestoreBloc>(context, listen: false)
                .add(FirestoreFetchMessagesOnline(_userId!));
          });

          return Scaffold(
            body: Column(
              children: [
                BlocBuilder<ContactCubit, ContactState>(
                  builder: (context, state) {
                    _cubit = BlocProvider.of<ContactCubit>(context);
                    List<Contact> _contacts = _cubit!.contacts;
                    
                    return BlocConsumer<FirestoreBloc, FirestoreState>(
                      listener: (context, state) {
                        if (state is FirestoreMessagesLoaded) {
                          FirestoreMessagesLoaded _loaded =
                              state as FirestoreMessagesLoaded;
                          if (_contacts.length == 0) {
                            _loaded.messages.forEach((message) {
                              Contact newContact =
                                  Contact(message.uidSender, 1);
                              _contacts.insert(0, newContact);
                              Provider.of<ContactCubit>(context, listen: false)
                                  .addContact(newContact);
                            });
                          } else {
                            _contacts.forEach((contact) {
                              _loaded.messages.forEach((message) {
                                print(message.uidSender);
                                if (contact.uid == message.uidSender) {
                                  contact.newMessages += 1;
                                  if (_contacts.contains(contact)) {
                                    _contacts.insert(
                                        0,
                                        _contacts.removeAt(
                                            _contacts.indexOf(contact)));
                                  }
                                } else {
                                  Contact newContact =
                                      Contact(message.uidSender, 1);
                                  Provider.of<ContactCubit>(context,
                                          listen: false)
                                      .addContact(newContact);
                                  _contacts = _cubit!.contacts;
                                }
                              });
                            });
                          }
                        }
                      },
                      builder: ((context, state) {
                        return BlocProvider.value(
                          value: _cubit!,
                          child: RefreshIndicator(
                            onRefresh: () async {
                              // Provider.of<FirestoreBloc>(context, listen: false)
                              //     .add(FirestoreFetchMessagesOnline(_userId!));
                            },
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: _contacts.length,
                              itemBuilder: (context, index) {
                                return ContactListTile(
                                    _contacts[index], (() => setState(() {})));
                              },
                            ),
                          ),
                        );
                      }),
                    );
                  },
                )
              ],
            ),
            appBar: HomeAppBar("hello", false),
            floatingActionButton: FloatingActionButton.extended(
              icon: Icon(Icons.message),
              onPressed: (() {
                showModalBottomSheet(
                  useRootNavigator: false,
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return BlocProvider.value(
                      value: _cubit!,
                      child: ContactAddBottomSheet(),
                    );
                  },
                );
              }),
              label: Text("start chat"),
            ),
          );
        }),
      ),
    );
  }
}
