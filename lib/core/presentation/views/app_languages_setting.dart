import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/presentation/bloc/locale_cubit.dart';

class AppLanguagesSetting extends StatelessWidget {
  const AppLanguagesSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'App Languages Setting',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<LocaleCubit, Locale>(
          builder: (context, currentLocale) {
            return SingleChildScrollView(
              child: RadioGroup<Locale>(
                groupValue: currentLocale,
                onChanged: (value) {
                  if (value != null) {
                    context.read<LocaleCubit>().changeLocale(value);
                  }
                },
                child: const Column(
                  children: [
                    RadioListTile<Locale>(
                      title: Text('English (en)'),
                      value: Locale('en'),
                    ),
                    RadioListTile<Locale>(
                      title: Text('Chinese (zh)'),
                      value: Locale('zh'),
                    ),
                    RadioListTile<Locale>(
                      title: Text('Indonesian (id)'),
                      value: Locale('id'),
                    ),
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
