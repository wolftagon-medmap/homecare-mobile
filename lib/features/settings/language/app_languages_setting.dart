import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/extensions/l10n_extensions.dart';
import 'package:m2health/features/settings/language/locale_cubit.dart';
import 'package:m2health/i18n/translations.g.dart';

class AppLanguagesSetting extends StatelessWidget {
  const AppLanguagesSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.settings_language_title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<LocaleCubit, AppLocale>(
          builder: (context, currentLocale) {
            return SingleChildScrollView(
              child: RadioGroup<AppLocale>(
                groupValue: currentLocale,
                onChanged: (value) {
                  if (value != null) {
                    context.read<LocaleCubit>().changeLocale(value);
                  }
                },
                child: Column(
                  children: [
                    RadioListTile<AppLocale>(
                      title: const Text(
                        "English",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(context.l10n.language_en),
                      value: AppLocale.en,
                    ),
                    RadioListTile<AppLocale>(
                      title: const Text(
                        "中文",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(context.l10n.language_zh),
                      value: AppLocale.zh,
                    ),
                    RadioListTile<AppLocale>(
                      title: const Text(
                        "Bahasa Indonesia",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(context.l10n.language_id),
                      value: AppLocale.id,
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
