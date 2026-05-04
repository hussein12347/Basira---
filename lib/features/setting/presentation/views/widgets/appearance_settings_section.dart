import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utls/styles/app_styles.dart';
import '../../../../../core/utls/theme_and_local/theme_and_local_cubit.dart';
import '../../../../../generated/l10n.dart';
import 'setting_card.dart';

class AppearanceSettingsSection extends StatelessWidget {
  final ThemeAndLocalState state;
  const AppearanceSettingsSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

    return Column(
      children: [
        // Dark Mode
        SettingCard(
          context: context,
          title: s.appearance,
          child: ListTile(
            leading: Icon(state.isDark ? Icons.dark_mode : Icons.light_mode, color: theme.colorScheme.primary),
            title: Text(s.dark_mode),
            trailing: Switch.adaptive(
              value: state.isDark,
              onChanged: (v) => context.read<ThemeAndLocalCubit>().toggleTheme(),
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Language
        SettingCard(
          context: context,
          title: s.language,
          child: ListTile(
            leading: Icon(Icons.language, color: theme.colorScheme.primary),
            title: Text(s.app_language),
            trailing: DropdownButton<String>(
              value: state.locale,
              underline: const SizedBox(),
              items: _buildLanguageItems(context),
              onChanged: (lang) => lang != null ? context.read<ThemeAndLocalCubit>().changeLanguage(lang) : null,
            ),
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _buildLanguageItems(BuildContext context) {
    return [
      DropdownMenuItem(value: 'ar', child: Text('العربية', style: AppStyles.regular18(context))),
      DropdownMenuItem(value: 'en', child: Text('English', style: AppStyles.regular18(context))),
    ];
  }
}