import 'package:flutter/material.dart';

import '../../../../../core/utls/styles/app_styles.dart';

class SettingCard extends StatelessWidget {
  const SettingCard({
    super.key,
    required this.context,
    required this.title,
    required this.child,
  });

  final BuildContext context;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Text(
            title,
            style: AppStyles.bold16(context)
                .copyWith(color: theme.colorScheme.primary),
          ),
        ),
        Card(
          elevation: 0,
          color: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
          ),
          child: child,
        ),
      ],
    );
  }
}
