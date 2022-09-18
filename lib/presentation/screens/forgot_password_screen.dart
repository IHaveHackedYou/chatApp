import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newwfirst/business_logic/blocs/authentication/authentication_bloc.dart';
import 'package:newwfirst/presentation/widgets/dialogs/confirmation_dialog.dart';
import 'package:newwfirst/presentation/widgets/dialogs/error_dialog.dart';
import 'package:newwfirst/presentation/widgets/dialogs/loading_dialog.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is AuthenticationResettingPasswordFailed) {
                final resetPasswordFailedEvent =
                    state as AuthenticationResettingPasswordFailed;
                showDialog(
                  context: context,
                  builder: (context) {
                    Navigator.of(context, rootNavigator: true).pop();
                    return ErrorDialog(
                        "Sign up Error", resetPasswordFailedEvent.errorMessage, (){Navigator.of(context).pushNamed("/signIn");});
                  },
                );
              }
            },
            child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(50),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                            labelText: "Email",
                          ),
                          validator: ((value) {
                            if (value!.isEmpty) {
                              return "Enter email";
                            } else if (!value.contains("@") ||
                                !value.contains(".")) {
                              return "Enter valid email";
                            } else {
                              return null;
                            }
                          }),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          child: const Text("Reset password"),
                          onPressed: (() {
                            if (_formKey.currentState!.validate()) {
                              context
                                  .read<AuthenticationBloc>()
                                  .add(ResetPassword(_emailController.text));
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return ConfirmationDialog(
                                      "Password reset mail sent!", "/signIn");
                                },
                              );
                            }
                          }),
                        )
                      ],
                    )))));
  }
}
