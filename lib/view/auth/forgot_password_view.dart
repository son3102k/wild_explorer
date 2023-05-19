import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wild_explorer/extensions/buildcontext/loc.dart';

import '../../services/auth/bloc/auth_bloc.dart';
import '../../services/auth/bloc/auth_event.dart';
import '../../services/auth/bloc/auth_state.dart';
import '../ultilities/dialogs/error_dialog.dart';
import '../ultilities/dialogs/password_reset_error_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;
  bool isButtonEnabled = false;

  @override
  void initState() {
    _controller = TextEditingController();
    _controller.addListener(updateButtonState);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void updateButtonState() {
    setState(() {
      isButtonEnabled = _controller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            await showErrorDialog(
                context, context.loc.forgot_password_view_generic_error);
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.fill),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40.0),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Text(
                      context.loc.forgot_password_view_prompt,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.3,
                        color: Color.fromARGB(255, 100, 99, 99),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    autofocus: true,
                    controller: _controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: const Icon(Icons.email),
                      hintText: context.loc.email_text_field_placeholder,
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      fixedSize: const Size(double.maxFinite, 50),
                      foregroundColor:
                          !isButtonEnabled ? Colors.black26 : Colors.white,
                      backgroundColor:
                          !isButtonEnabled ? Colors.grey[200] : Colors.blue,
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: !isButtonEnabled
                        ? null
                        : () {
                            final email = _controller.text;
                            context
                                .read<AuthBloc>()
                                .add(AuthEventForgotPassword(email: email));
                          },
                    child: Text(context.loc.forgot_password_view_send_me_link),
                  ),
                  const SizedBox(height: 40.0),
                  TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        fixedSize: const Size(double.maxFinite, 50),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        context.read<AuthBloc>().add(
                              const AuthEventLogOut(),
                            );
                      },
                      child:
                          Text(context.loc.forgot_password_view_back_to_login)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
