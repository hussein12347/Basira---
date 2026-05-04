import 'package:elda3ia_tour/const/constant.dart';
import 'package:elda3ia_tour/core/utls/functions/convert_to_arabic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:qcf_quran_lite/qcf_quran_lite.dart';
import '../../../../../const/resource.dart';
import '../../../../../core/utls/functions/is_arabic.dart';
import '../../../../../core/utls/styles/app_styles.dart';
import '../../../../../core/utls/widgets/app_animations.dart';
import '../../../../../generated/l10n.dart';

class SurahListTile extends StatelessWidget {
  final int surah;
  final int animationIndex;

  const SurahListTile({
    super.key,
    required this.surah,
    this.animationIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    int index = surah - 1;
    final delayMS = 50 * (animationIndex % 15);

    return Container(
      margin: const EdgeInsets.symmetric( vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],

      ),
      child: ListTile(
        leading: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              R.assetsImagesSvgQuranNumberSvg,
              colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.secondary, BlendMode.srcIn),
            ),
            Text(
              LanguageHelper.isArabic() ? ConvertToArabic.convertToArabicNumber(surah) : "$surah",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
        title: Text(getSurahName(surah), style: AppStyles.medium24(context)),
        subtitle: Text(
          '${S.of(context).numberOfVerses}: ${getVerseCount(surah)} - ${getPlaceOfRevelation(surah)}',
          style: AppStyles.regular16(context).copyWith(color: Colors.grey),
        ),
        trailing: Text(
          "surah${surah.toString().padLeft(3, '0')}",
          style: TextStyle(
            fontFamily: 'surahName',
            fontSize: 36,
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: () {
          context.push(kQuranPageViewRoute, extra: {
            "surahNumber": surah,
            "pageNumber": null
          });
        },
      )
    ).animateBottomToTop(delay: Duration(milliseconds: delayMS));
  }
}
