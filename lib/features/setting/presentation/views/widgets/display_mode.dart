import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utls/styles/app_styles.dart';
import '../../../../../generated/l10n.dart';
import '../../../../quran/presentation/manger/quran_cubit.dart';

class DisplayMode extends StatelessWidget {
  const DisplayMode({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            S.of(context).quran_display_mode,
            style: AppStyles.regular14(context).copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: theme.primaryColor,
            ),
          ),
          const SizedBox(height: 20),

          BlocBuilder<QuranCubit, QuranState>(
            builder: (context, quranState) {
              final quranCubit = context.read<QuranCubit>();
              return Row(
                children: [
                  Expanded(
                    child: _buildModeCard(
                      context: context,
                      title: S.of(context).mushaf_display_mode,

                      icon: Icons.menu_book_rounded,
                      isSelected: quranCubit.isMushafMode == true,
                      onTap: () => quranCubit.toggleDisplayMode(true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildModeCard(
                      context: context,
                      title: S.of(context).List_display_mode,
                      icon: Icons.format_list_bulleted_rounded,
                      isSelected: quranCubit.isMushafMode == false,
                      onTap: () => quranCubit.toggleDisplayMode(false),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildModeCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryColor.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? theme.primaryColor : theme.dividerColor.withOpacity(0.4),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? theme.primaryColor : Colors.grey.shade500,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppStyles.regular14(context).copyWith(
                color: isSelected ? theme.primaryColor : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}