import 'package:elda3ia_tour/const/constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../generated/l10n.dart';
import 'setting_card.dart';

class DownloadsSection extends StatelessWidget {
  const DownloadsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingCard(
      context: context,
      title: S.of(context).downloads_manager,
      child: ListTile(
        leading: Icon(
          Icons.cloud_download_rounded,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(S.of(context).downloads_manager),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: Theme.of(context).colorScheme.primary,
        ),
        onTap:()=> context.push(kDownloadsRoute),
      ),
    );
  }
}
