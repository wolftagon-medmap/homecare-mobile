import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/settings/language/locale_cubit.dart';
import 'package:m2health/features/settings/language/app_languages_setting.dart';
import 'package:m2health/features/auth/domain/entities/user_role.dart';
import 'package:m2health/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m2health/features/auth/presentation/cubit/sign_in_cubit.dart';
import 'package:m2health/i18n/translations.g.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/service_locator.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String _getLanguageLabel(AppLocale locale) {
    switch (locale.languageCode) {
      case 'id':
        return 'Bahasa Indonesia';
      case 'zh':
        return '中文';
      case 'en':
      default:
        return 'English';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          BlocBuilder<LocaleCubit, AppLocale>(
            builder: (context, locale) {
              return TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AppLanguagesSetting()),
                  );
                },
                child: Text(
                  _getLanguageLabel(locale),
                  style: const TextStyle(
                    color: Const.aqua,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => SignInCubit(authRepository: sl()),
        child: BlocConsumer<SignInCubit, SignInState>(
          listener: (context, state) {
            if (state is SignInSuccess) {
              context.read<AuthCubit>().loggedIn();
            } else if (state is SignInError) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(context.t.global.error),
                    content: Text(state.message),
                    actions: <Widget>[
                      TextButton(
                        child: Text(context.t.global.ok),
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ],
                  );
                },
              );
            } else if (state is SignInRequiresRole) {
              _showRoleSelectionDialog(context, state.idToken);
            }
          },
          builder: (context, state) {
            Hero(
              tag: 'logo',
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 48.0,
                child: Image.asset('assets/icons/ic_launcher.png'),
              ),
            );

            final email = TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              decoration: InputDecoration(
                hintText: context.t.auth.form.label.email,
                contentPadding:
                    const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            );
            final password = TextFormField(
              controller: passwordController,
              autofocus: false,
              obscureText: true,
              decoration: InputDecoration(
                hintText: context.t.auth.form.label.password,
                contentPadding:
                    const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            );

            final loginButton = Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Const.aqua,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5.0,
                  side: BorderSide.none,
                  padding: const EdgeInsets.all(16.0),
                ),
                onPressed: () {
                  context
                      .read<SignInCubit>()
                      .signIn(emailController.text, passwordController.text);
                },
                child: Text(context.t.auth.login.button.submit,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            );

            final createAccountText = Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: GestureDetector(
                onTap: () {
                  context.go(AppRoutes.signUp);
                },
                child: Text(
                  context.t.auth.login.button.create_account_link,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Const.aqua,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );

            final continueWithText = Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                context.t.auth.continue_with_alternative_text,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            );

            final socialIcons = Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 16),
                  IconButton(
                    icon: Image.asset('assets/icons/ic_google.png'),
                    iconSize: 40,
                    onPressed: () {
                      context.read<SignInCubit>().signInWithGoogle();
                    },
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            );

            return Center(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
                  Text(
                    context.t.auth.login.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Const.aqua,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    context.t.auth.login.subtitle,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48.0),
                  email,
                  const SizedBox(height: 8.0),
                  password,
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        context.push(AppRoutes.forgotPassword);
                      },
                      child: Text(
                        context.t.auth.login.button.forgot_password_link,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  loginButton,
                  const SizedBox(height: 11.0),
                  createAccountText,
                  continueWithText,
                  socialIcons,
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showRoleSelectionDialog(BuildContext context, String idToken) {
    final cubit = context.read<SignInCubit>();
    UserRole selectedRole = UserRole.patient;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: Text(context.t.auth.login.role_selection_dialog.title,
              style: const TextStyle(
                color: Const.aqua,
                fontWeight: FontWeight.w600,
              )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(context.t.auth.login.role_selection_dialog.body),
              const SizedBox(height: 24),
              DropdownButtonFormField<UserRole>(
                decoration: InputDecoration(
                  labelText: context.t.auth.form.label.user_role,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                initialValue: selectedRole,
                items: <UserRole>[
                  UserRole.patient,
                  UserRole.nurse,
                  UserRole.pharmacist,
                  UserRole.radiologist,
                  UserRole.caregiver,
                  UserRole.physiotherapist,
                ].map<DropdownMenuItem<UserRole>>((UserRole value) {
                  return DropdownMenuItem<UserRole>(
                    value: value,
                    child: Text(
                      value.getDisplayName(context),
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    ),
                  );
                }).toList(),
                onChanged: (UserRole? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedRole = newValue;
                    });
                  }
                },
              ),
            ],
          ),
          backgroundColor: Colors.white,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(context.t.global.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                // Retry Google Auth with the selected role and cached token
                cubit.signInWithGoogle(
                    role: selectedRole.value, idToken: idToken);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Const.aqua,
                foregroundColor: Colors.white,
              ),
              child: Text(context.t.global.submit),
            ),
          ],
        );
      }),
    );
  }
}
