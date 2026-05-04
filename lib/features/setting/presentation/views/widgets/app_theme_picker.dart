import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utls/styles/app_styles.dart';
import '../../../../../core/utls/theme_and_local/app_themes.dart';
import '../../../../../core/utls/theme_and_local/theme_and_local_cubit.dart';
import '../../../../../generated/l10n.dart';
import 'setting_card.dart';
class AppThemePicker extends StatelessWidget {
  final ThemeAndLocalState state;
  const AppThemePicker({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

    return Column(
      children: [
        SettingCard(
          context: context,
          title: s.theme,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.choose_primary_color, style: AppStyles.regular14(context)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 50,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: AppThemes.lightThemeNames.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final themeKey = AppThemes.lightThemeNames[index];
                      final Color themeColor = AppThemes.lightThemes[themeKey]!.primaryColor;
                      final bool isSelected = state.theme == themeKey;

                      return GestureDetector(
                        onTap: () {
                          context.read<ThemeAndLocalCubit>().changeTheme(themeKey);
                        },
                        child: _ColorItem(
                          color: themeColor,
                          isSelected: isSelected,
                          onSurfaceColor: theme.colorScheme.onSurface,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

      ],
    );
  }
}


class _ColorItem extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final Color onSurfaceColor;

  const _ColorItem({
    required this.color,
    required this.isSelected,
    required this.onSurfaceColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? onSurfaceColor : Colors.transparent,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isSelected
          ? const Icon(Icons.check, color: Colors.white, size: 20)
          : null,
    );
  }
}