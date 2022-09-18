part of 'contact_cubit.dart';

abstract class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object> get props => [];
}

class ContactInitial extends ContactState {}

class ContactsLoading extends ContactState {}

class ContactsLoaded extends ContactState {}

class ContactsLoadingFailed extends ContactState {}

class ContactsSaving extends ContactState {}

class ContactsSaved extends ContactState {}

class ContactsSavingFailed extends ContactState {}

class ContactsAdding extends ContactState {}

class ContactsAdded extends ContactState {}

class ContactsAddingFailed extends ContactState {
  final String errorMessage;

  ContactsAddingFailed(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}
