import 'package:elda3ia_tour/core/utls/functions/is_arabic.dart';
import 'package:elda3ia_tour/features/home/presentation/views/widgets/quarter_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:qcf_quran_lite/qcf_quran_lite.dart';
import 'package:qcf_quran_lite/src/data/quarters.dart';

import '../../../../../const/constant.dart';
import '../../../../../const/resource.dart';
import '../../../../../core/utls/functions/convert_to_arabic.dart';
import '../../../../../core/utls/styles/app_styles.dart';
import '../../../../../core/utls/widgets/app_animations.dart';
import '../../../../../generated/l10n.dart';
import '../../../data/models/hgizb_model.dart';


class HizbList extends StatefulWidget {
  const HizbList({super.key});

  @override
  State<HizbList> createState() => _HizbListState();
}

class _HizbListState extends State<HizbList> {
  final TextEditingController _searchController = TextEditingController();
  final List<HizbModel> _allHizbs = [];
  List<HizbModel> _filteredHizbs = [];

  @override
  void initState() {
    super.initState();
    _prepareHizbData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _prepareHizbData() {
    for (int i = 0; i < 60; i++) {
      final int firstQuarterIndex = i * 4;
      final int sNum = quarters[firstQuarterIndex]['surah']!;
      final int aNum = quarters[firstQuarterIndex]['ayah']!;

      _allHizbs.add(
        HizbModel(
          id: i + 1,
          startPage: getPageNumber(sNum, aNum),
          startSurah: sNum,
          startSurahName: getSurahNameArabic(sNum),
          ayaNum: aNum,
        ),
      );
    }
    _filteredHizbs = List.from(_allHizbs);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredHizbs = List.from(_allHizbs);
      } else {
        _filteredHizbs = _allHizbs.where((hizb) {
          return hizb.id.toString().contains(query) ||
              _toArabicNumbers(hizb.id).contains(query) ||
              hizb.startPage.toString().contains(query) ||
              _toArabicNumbers(hizb.startPage).contains(query) ||
              hizb.ayaNum.toString().contains(query) ||
              _toArabicNumbers(hizb.ayaNum).contains(query) ||
              hizb.startSurahName.contains(query);
        }).toList();
      }
    });
  }

  String _toArabicNumbers(int number) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .toString()
        .split('')
        .map((d) => arabicDigits[int.parse(d)])
        .join('');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: S.of(context).search,
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.primary,
              ),
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
              ),
            ),
          ),
        ),

        // القائمة
        Expanded(
          child: _filteredHizbs.isEmpty
              ? Center(child: Text(S.of(context).no_results_found))
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: _filteredHizbs.length + 1,
                  itemBuilder: (context, index) {
                    if (index >= _filteredHizbs.length) {
                      return const SizedBox(height: kBottomNavigationBarHeight);
                    }

                    final hizb = _filteredHizbs[index];
                    return _buildHizbCard(context, hizb, index);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildHizbCard(BuildContext context, HizbModel hizb, int index) {
    final bool isAr = Localizations.localeOf(context).languageCode == 'ar';
    final delayMS = 50 * (index % 15);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ExpansionTile(
          shape: const RoundedRectangleBorder(side: BorderSide.none),
          collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
          leading: _buildHizbNumber(context, hizb.id, isAr),
          title: Text(
            "${S.of(context).hizb} ${isAr ? ConvertToArabic.convertToArabicNumber(hizb.id) : hizb.id}",
            style: AppStyles.medium20(context),
          ),
          subtitle: Text(
            "${S.of(context).page} ${isAr ? ConvertToArabic.convertToArabicNumber(hizb.startPage) : hizb.startPage} - ${LanguageHelper.isArabic() ? hizb.startSurahName : getSurahName(hizb.startSurah)}",
            style: AppStyles.regular14(context).copyWith(color: Colors.grey),
          ),
          children: List.generate(4, (qIndex) {
            final int absoluteQuarterIndex = ((hizb.id - 1) * 4) + qIndex;
            return _buildQuarterTile(
              context,
              absoluteQuarterIndex,
              qIndex,
              isAr,
            );
          }),
        ),
      ).animateBottomToTop(delay: Duration(milliseconds: delayMS)),
    );
  }

  Widget _buildQuarterTile(
    BuildContext context,
    int absIndex,
    int qInHizb,
    bool isAr,
  ) {
    final int surah = quarters[absIndex]['surah']!;
    final int ayah = quarters[absIndex]['ayah']!;
    final int page = getPageNumber(surah, ayah);

    final List<String> quarterNamesAr = [
      "بداية الحزب",
      "ربع الحزب",
      "نصف الحزب",
      "ثلاثة أرباع الحزب",
    ];
    final List<String> quarterNamesEn = [
      "Hizb Start",
      "1/4 Hizb",
      "1/2 Hizb",
      "3/4 Hizb",
    ];

    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      leading: SizedBox(
        width: 20,
        height: 20,
        child: CustomPaint(
          painter: QuarterCirclePainter(
            qInHizb: qInHizb,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
          ),
        ),
      ),
      title: Text(
        isAr ? quarterNamesAr[qInHizb] : quarterNamesEn[qInHizb],
        style: AppStyles.regular16(context),
      ),
      subtitle: Text(
        getVerse(surah, ayah).replaceAll('\n', ' '),
        style: AppStyles.medium20(context).copyWith(fontFamily: 'hafs'),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        "${isAr ? "صـ" : "p."} ${isAr ? ConvertToArabic.convertToArabicNumber(page) : page}",
        style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
      ),
      onTap: () {
        context.push(
          kQuranPageViewRoute,
          extra: {"surahNumber": surah, "pageNumber": page,"verseNumber":ayah},
        );
      },
    );
  }

  Widget _buildHizbNumber(BuildContext context, int number, bool isAr) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
          R.assetsImagesSvgQuranNumberSvg,
          width: 40,
          height: 40,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.secondary,
            BlendMode.srcIn,
          ),
        ),
        Text(
          isAr ? ConvertToArabic.convertToArabicNumber(number) : "$number",
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
