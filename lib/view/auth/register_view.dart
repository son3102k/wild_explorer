import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wild_explorer/extensions/buildcontext/loc.dart';

import '../../services/auth/auth_exceptions.dart';
import '../../services/auth/bloc/auth_bloc.dart';
import '../../services/auth/bloc/auth_event.dart';
import '../../services/auth/bloc/auth_state.dart';
import '../ultilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _phoneNumber;
  bool _obscureText = true;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _phoneNumber = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _phoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
                context, context.loc.register_error_weak_password);
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
                context, context.loc.register_error_email_already_in_use);
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, context.loc.register_error_generic);
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
                context, context.loc.register_error_invalid_email);
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
            child: Column(
              children: [
                const SizedBox(height: 40.0),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Create account',
                    style: TextStyle(
                      fontSize: 36,
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    prefixIcon: const Icon(Icons.email),
                    hintText: context.loc.email_text_field_placeholder,
                  ),
                ),
                const SizedBox(height: 30.0),
                TextField(
                  controller: _password,
                  obscureText: _obscureText,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      hintText: context.loc.password_text_field_placeholder),
                ),
                const SizedBox(height: 30.0),
                TextField(
                  controller: _phoneNumber,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    prefixIcon: const Icon(Icons.smartphone),
                    hintText: 'Phone number',
                  ),
                ),
                const SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(const AuthEventLogOut());
                    },
                    child: Text(
                      context.loc.register_view_already_registered,
                      style: const TextStyle(
                        fontFamily: 'Rubik',
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      color: const Color.fromRGBO(199, 57, 249, 1),
                    ),
                    child: TextButton.icon(
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 30,
                      ),
                      label: const Text(''),
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        context.read<AuthBloc>().add(AuthEventRegister(
                              email,
                              password,
                            ));
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 50,
                          icon: SvgPicture.asset(
                            'assets/icons/icons8-facebook.svg',
                            fit: BoxFit.scaleDown,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          iconSize: 46,
                          icon: SvgPicture.asset(
                            'assets/icons/icons8-google.svg',
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                const Text(
                  'Or create new with social media',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Rubik',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
