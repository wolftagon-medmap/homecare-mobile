import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/presentation/bloc/locale_cubit.dart';
import 'package:m2health/core/presentation/views/app_languages_setting.dart';
import 'package:m2health/features/auth/domain/entities/user_role.dart';
import 'package:m2health/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/service_locator.dart';
import '../cubit/sign_up_cubit.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _passwordError;
  UserRole? _selectedRole;

  void _validatePasswords() {
    setState(() {
      if (_passwordController.text != _confirmPasswordController.text) {
        _passwordError = context.l10n.auth_passwords_do_not_match;
      } else {
        _passwordError = null;
      }
    });
  }

  void _submitForm(BuildContext context) {
    _validatePasswords();
    if (_formKey.currentState!.validate() &&
        _passwordError == null &&
        _selectedRole != null) {
      context.read<SignUpCubit>().signUp(
            _emailController.text.trim(),
            _passwordController.text,
            _usernameController.text.trim(),
            _selectedRole!.value,
          );
    } else if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.auth_select_role_error),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getLanguageLabel(Locale locale) {
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
          BlocBuilder<LocaleCubit, Locale>(
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
        create: (context) => SignUpCubit(authRepository: sl()),
        child: BlocConsumer<SignUpCubit, SignUpState>(
          listener: (context, state) {
            if (state is SignUpSuccess) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title:
                        Text(context.l10n.auth_registration_successful_title),
                    content:
                        Text(context.l10n.auth_registration_successful_content),
                    actions: <Widget>[
                      TextButton(
                        child: Text(context.l10n.common_ok),
                        onPressed: () {
                          context.go(AppRoutes.signIn);
                        },
                      ),
                    ],
                  );
                },
              );
            } else if (state is SignUpSSOSuccess) {
              context.read<AuthCubit>().loggedIn();
            } else if (state is SignUpFailure) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(context.l10n.auth_error_title),
                    content: Text(state.error),
                    actions: <Widget>[
                      TextButton(
                        child: Text(context.l10n.common_ok),
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      context.l10n.auth_sign_up_title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Const.aqua,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      context.l10n.auth_sign_up_subtitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: context.l10n.auth_username_hint,
                        contentPadding:
                            const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return context.l10n.auth_enter_username;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: context.l10n.auth_email_hint,
                        contentPadding:
                            const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return context.l10n.auth_enter_email;
                        }
                        if (!EmailValidator.validate(value.trim())) {
                          return context.l10n.auth_enter_valid_email;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: context.l10n.auth_password_hint,
                        contentPadding:
                            const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.l10n.auth_enter_password;
                        }
                        if (value.length < 6) {
                          return context.l10n.auth_password_length_error;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        hintText: context.l10n.auth_confirm_password_hint,
                        contentPadding:
                            const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        errorText: _passwordError,
                      ),
                      obscureText: true,
                      onChanged: (value) {
                        _validatePasswords();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.l10n.auth_confirm_password_error;
                        }
                        if (value != _passwordController.text) {
                          return context.l10n.auth_passwords_do_not_match;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<UserRole>(
                      decoration: InputDecoration(
                        hintText: context.l10n.auth_select_user_type_hint,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      initialValue: _selectedRole,
                      items: <UserRole>[
                        UserRole.patient,
                        UserRole.nurse,
                        UserRole.pharmacist,
                        UserRole.radiologist,
                        UserRole.caregiver,
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
                        setState(() {
                          _selectedRole = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return context.l10n.auth_select_role_error;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Const.aqua,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5.0,
                          side: BorderSide.none,
                          padding: const EdgeInsets.all(16.0),
                        ),
                        onPressed: state is SignUpLoading
                            ? null
                            : () => _submitForm(context),
                        child: Text(context.l10n.auth_sign_up_btn,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                    ),
                    if (state is SignUpLoading)
                      const Center(child: CircularProgressIndicator()),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        context.go(AppRoutes.signIn);
                      },
                      child: Text(
                        context.l10n.auth_already_have_account,
                        style: const TextStyle(color: Const.aqua),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      context.l10n.auth_continue_with,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 16),
                          IconButton(
                            icon: Image.asset('assets/icons/ic_google.png'),
                            iconSize: 40,
                            onPressed: () {
                              if (_selectedRole == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(context
                                        .l10n.auth_select_role_first_error),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                                return;
                              }
                              context
                                  .read<SignUpCubit>()
                                  .signUpWithGoogle(_selectedRole!.value);
                            },
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
