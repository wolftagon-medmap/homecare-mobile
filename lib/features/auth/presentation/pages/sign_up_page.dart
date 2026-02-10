import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/core/presentation/widgets/buttons/button_size.dart';
import 'package:m2health/core/presentation/widgets/buttons/primary_button.dart';
import 'package:m2health/features/settings/language/locale_cubit.dart';
import 'package:m2health/features/settings/language/app_languages_setting.dart';
import 'package:m2health/features/auth/domain/entities/user_role.dart';
import 'package:m2health/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m2health/i18n/translations.g.dart';
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
  UserRole? _selectedRole = UserRole.patient;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _validatePasswords() {
    setState(() {
      if (_passwordController.text != _confirmPasswordController.text) {
        _passwordError = context.t.auth.form.validation.password_mismatch;
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
          content: Text(context.t.auth.form.validation.user_role_required),
          backgroundColor: Colors.red,
        ),
      );
    }
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
        create: (context) => SignUpCubit(authRepository: sl()),
        child: BlocConsumer<SignUpCubit, SignUpState>(
          listener: (context, state) {
            if (state is SignUpSuccess) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(context
                        .t.auth.register.registration_success_dialog.title),
                    content: Text(context
                        .t.auth.register.registration_success_dialog.body),
                    actions: <Widget>[
                      TextButton(
                        child: Text(context.t.global.ok),
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
                    title: Text(context.t.global.error),
                    content: Text(state.error),
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
                      context.t.auth.register.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Const.aqua,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      context.t.auth.register.subtitle,
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
                        labelText: context.t.auth.form.label.username,
                        contentPadding:
                            const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return context
                              .t.auth.form.validation.username_required;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: context.t.auth.form.label.email,
                        contentPadding:
                            const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return context.t.auth.form.validation.email_required;
                        }
                        if (!EmailValidator.validate(value.trim())) {
                          return context.t.auth.form.validation.invalid_email;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: context.t.auth.form.label.password,
                        contentPadding:
                            const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_isPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context
                              .t.auth.form.validation.password_required;
                        }
                        if (value.length < 6) {
                          return context
                              .t.auth.form.validation.invalid_password_length;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: context.t.auth.form.label.password_confirm,
                        contentPadding:
                            const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        errorText: _passwordError,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_isConfirmPasswordVisible,
                      onChanged: (value) {
                        _validatePasswords();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return t
                              .auth.form.validation.password_confirm_required;
                        }
                        if (value != _passwordController.text) {
                          return context
                              .t.auth.form.validation.password_mismatch;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    FormField<UserRole>(
                      initialValue: _selectedRole,
                      validator: (value) {
                        if (value == null) {
                          return context
                              .t.auth.form.validation.user_role_required;
                        }
                        return null;
                      },
                      builder: (FormFieldState<UserRole> fieldState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownMenu<UserRole>(
                              expandedInsets: EdgeInsets.zero,
                              initialSelection: _selectedRole,
                              label: Text(context.t.auth.form.label.user_role),
                              menuHeight: 180,
                              onSelected: (UserRole? newValue) {
                                setState(() {
                                  _selectedRole = newValue;
                                });
                                fieldState.didChange(newValue);
                              },
                              dropdownMenuEntries: <UserRole>[
                                UserRole.patient,
                                UserRole.nurse,
                                UserRole.pharmacist,
                                UserRole.radiologist,
                                UserRole.caregiver,
                                UserRole.physiotherapist,
                              ].map<DropdownMenuEntry<UserRole>>(
                                  (UserRole value) {
                                return DropdownMenuEntry<UserRole>(
                                  value: value,
                                  label: value.getDisplayName(context),
                                  style: MenuItemButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    PrimaryButton(
                      size: ButtonSize.large,
                      text: context.t.auth.register.button.submit,
                      isLoading: state is SignUpLoading,
                      onPressed: () => _submitForm(context),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        context.go(AppRoutes.signIn);
                      },
                      child: Text(
                        context.t.auth.register.button.login_link,
                        style: const TextStyle(color: Const.aqua),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      context.t.auth.continue_with_alternative_text,
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
                            icon: Image.asset(
                              'assets/icons/ic_google_signin.png',
                              width: 44,
                              height: 44,
                            ),
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
                          const SizedBox(width: 8),
                          IconButton(
                            icon: ClipOval(
                              child: Image.asset(
                                'assets/icons/ic_apple_signin.png',
                                width: 44,
                                height: 44,
                              ),
                            ),
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
                                  .signUpWithApple(_selectedRole!.value);
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
