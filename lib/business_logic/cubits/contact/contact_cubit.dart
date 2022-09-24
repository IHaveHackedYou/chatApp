import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:newwfirst/data/model/contact.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  List<Contact> _contacts = [];
  List<Contact> get contacts {
    return _contacts;
  }

  ContactCubit() : super(ContactInitial()) {
    fetchContacts();
  }

  void fetchContacts() async {
    emit(ContactsLoading());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? contactsJSON = prefs.getStringList("contacts");
      contactsJSON?.forEach((element) {
        _contacts.add(Contact.fromJson(element));
      });
      emit(ContactsLoaded());
    } catch (e) {
      emit(ContactsLoadingFailed());
    }
  }

  Future<void> saveContacts() async {
    emit(ContactsSaving());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> contactsJSON = [];
      _contacts.forEach((element) {
        contactsJSON.add(element.toJson());
      });
      prefs.setStringList("contacts", contactsJSON);
      emit(ContactsSaved());
    } catch (e) {
      emit(ContactsSavingFailed());
    }
  }

  Future<void> addContact(Contact contact) async {
    emit(ContactsAdding());
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("contacts").get();
    final allUsers = snapshot.docs.map((doc) => doc.id).toList();

    bool contactAlreadyExisting = false;
    contacts.forEach((element) {
      if (element.uid == contact.uid) {
        contactAlreadyExisting = true;
      }
    });

    if (contactAlreadyExisting) {
      emit(ContactsAddingFailed("Contact already existing"));
    } else if (allUsers.contains(contact.uid.trim())) {
      _contacts.insert(0, contact);
      emit(ContactsAdded());
    } else {
      emit(ContactsAddingFailed("Invalid contact"));
    }
    saveContacts();
  }

  void updateContact(){
    emit(ContactsLoaded());
  }

  void removeContact(Contact contact) async {
    if (contacts.contains(contact)) {
      contacts.remove(contact);
    }
    saveContacts();
  }
}
