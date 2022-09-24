import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newwfirst/data/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  FirebaseAuth _firebaseAuth;
  final AppUser _user =
      AppUser(emptyUser: true, email: "", uid: "", user: null);

  AppUser get user {
    return _user;
  }

  AuthenticationBloc(this._firebaseAuth) : super(AuthenticationInitial()) {
    on<SignIn>(_onSignIn);
    on<SignUp>(_onSignUp);
    on<SignOut>(_onSignOut);
    on<ResetPassword>(_onResetPassword);
    on<TryAutoSignIn>(_onTryAutoSignIn);
  }

  Future<void> _onSignIn(
      SignIn event, Emitter<AuthenticationState> emit) async {
    try {
      emit(AuthenticationSigningIn());
      await _firebaseAuth.signInWithEmailAndPassword(
          email: event.email, password: event.password);
      User? _firebaseUser = _firebaseAuth.currentUser;
      _user.email = _firebaseUser?.email;
      _user.uid = _firebaseUser?.uid;
      _user.emptyUser = false;

      if (event.staySignedIn) {
        setStaySignedIn(event.email, event.password);
      }

      emit(AuthenticationSignedIn(_firebaseAuth.currentUser!));
    } on FirebaseAuthException catch (e) {
      emit(AuthenticationSignInFailed(e.message!));
    }
  }

  void _onSignUp(SignUp event, Emitter<AuthenticationState> emit) async {
    try {
      emit(AuthenticationSigningUp());
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: event.email, password: event.password);
      User? _firebaseUser = _firebaseAuth.currentUser;
      _user.email = _firebaseUser?.email;
      _user.emptyUser = false;
      _user.uid = _firebaseUser?.uid;
      final docUser =
          FirebaseFirestore.instance.collection("contacts").doc(_user.uid);
      await docUser.set(_user.toMap());
      if (event.staySignedIn) {
        setStaySignedIn(event.email, event.password);
      }
      emit(AuthenticationSignedIn(_firebaseAuth.currentUser!));
    } on FirebaseAuthException catch (e) {
      emit(AuthenticationSignUpFailed(e.message!));
    }
  }

  Future<void> _onSignOut(
      SignOut event, Emitter<AuthenticationState> emit) async {
    try {
      emit(AuthenticationSigningOut());
      await _firebaseAuth.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("last_password", "");
    await prefs.setString("last_email", "");
      emit(AuthenticationInitial());
    } on FirebaseAuthException catch (e) {
      emit(AuthenticationSignInFailed(e.message!));
    }
  }

  FutureOr<void> _onResetPassword(
      ResetPassword event, Emitter<AuthenticationState> emit) async {
    try {
      _firebaseAuth.sendPasswordResetEmail(email: event.email);
    } on FirebaseAuthException catch (e) {
      emit(AuthenticationResettingPasswordFailed(e.message!));
    }
  }

  Future<void> _onTryAutoSignIn(
      TryAutoSignIn event, Emitter<AuthenticationState> emit) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String password = await prefs.getString("last_password")!;
      String email = await prefs.getString("last_email")!;
      print("try sign in" + email + "  " + password);
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User? _firebaseUser = _firebaseAuth.currentUser;
      _user.email = _firebaseUser?.email;
      _user.uid = _firebaseUser?.uid;
      _user.emptyUser = false;
      emit(AuthenticationSignedIn(_firebaseAuth.currentUser!));
    } on Exception catch (e) {}
  }

  Future<void> setStaySignedIn(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("last_password", password);
    await prefs.setString("last_email", email);
  }
}
