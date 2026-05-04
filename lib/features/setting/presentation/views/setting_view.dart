import 'package:elda3ia_tour/features/setting/presentation/views/widgets/display_mode.dart';
import 'package:elda3ia_tour/features/setting/presentation/views/widgets/download_card.dart';

import 'widgets/appearance_settings_section.dart';
import 'widgets/font_scale_content_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../core/utls/theme_and_local/theme_and_local_cubit.dart';
import '../../../../generated/l10n.dart';
import 'widgets/app_theme_picker.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).settings)),
      body: BlocBuilder<ThemeAndLocalCubit, ThemeAndLocalState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AppearanceSettingsSection(state: state),
              const SizedBox(height: 24),
              FontScaleSettingCard(state: state),

              const SizedBox(height: 24),
              AppThemePicker(state: state),
              const SizedBox(height: 24),
              const DisplayMode(),
              const SizedBox(height: 24),
              const DownloadsSection(),
              const SizedBox(height: kBottomNavigationBarHeight + 24),
            ],
          );
        },
      ),
    );
  }
}


