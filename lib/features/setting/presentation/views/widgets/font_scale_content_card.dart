import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utls/theme_and_local/theme_and_local_cubit.dart';
import '../../../../../generated/l10n.dart';
import 'setting_card.dart';

class FontScaleSettingCard extends StatelessWidget {
  final ThemeAndLocalState state;
  const FontScaleSettingCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

    return SettingCard(
      context: context,
      title: s.font_scale,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            const Icon(Icons.text_fields, size: 16, color: Colors.grey),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: theme.primaryColor,
                  inactiveTrackColor: theme.primaryColor.withOpacity(0.2),
                  thumbColor: theme.primaryColor,
                  trackHeight: 6.0,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
                ),
                child: Slider(
                  value: state.fontScale,
                  min: 0.8,
                  max: 1.6,
                  divisions: 8,
                  label: '${state.fontScale.toStringAsFixed(1)}x',
                  onChanged: (value) {
                    context.read<ThemeAndLocalCubit>().changeFontScale(value);
                  },
                ),
              ),
            ),
            Icon(Icons.text_fields, size: 28, color: theme.primaryColor),
          ],
        ),
      ),
    );
  }
}