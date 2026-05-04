import 'package:flutter/material.dart';

// Ensure you import your generated localization file here
// import 'package:elda3ia_tour/generated/l10n.dart';

import 'package:elda3ia_tour/features/downloads_mangment/presentation/views/widgets/download_stats_helper.dart';
import 'package:elda3ia_tour/features/downloads_mangment/presentation/views/widgets/reciter_surahs_screen.dart';
import '../../../../core/utls/widgets/app_animations.dart';
import '../../../../generated/l10n.dart';
import '../../../quran/data/models/audio_model.dart';
import '../../../quran/presentation/views/widgets/AudioUtils.dart';

/// A screen that manages and displays a list of all available Quran reciters.
///
/// It features a search bar to filter reciters by name (Arabic or English)
/// and displays a progress bar for each reciter indicating how much of their
/// audio files have been downloaded locally.
class RecitersDownloadScreen extends StatefulWidget {
  const RecitersDownloadScreen({super.key});

  @override
  State<RecitersDownloadScreen> createState() => _RecitersDownloadScreenState();
}

class _RecitersDownloadScreenState extends State<RecitersDownloadScreen> {
  /// The complete list of available reciters loaded from the local utility.
  List<AudioModel> allReciters = [];

  /// The currently displayed list of reciters, updated based on the search query.
  List<AudioModel> filteredReciters = [];

  /// A cached set of all downloaded audio files to quickly calculate progress.
  Set<String> downloadedFiles = {};

  /// Indicates whether the initial data and file scan is still loading.
  bool isLoading = true;

  /// Controller for the search input field.
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Initializes the reciters list and fetches the downloaded files set.
  Future<void> _initData() async {
    // Load all reciters from the static AudioUtils list
    allReciters = AudioUtils.audios.map((e) => AudioModel.fromJson(e)).toList();
    filteredReciters = allReciters;

    // Fetch the set of downloaded files for O(1) performance during progress calculation
    downloadedFiles = await DownloadStatsHelper.getAllDownloadedFiles();

    setState(() {
      isLoading = false;
    });
  }

  /// Filters the [filteredReciters] list based on the user's search [query].
  ///
  /// It checks both the Arabic and English names of the reciter to ensure
  /// a seamless search experience regardless of the user's input language.
  void _filterReciters(String query) {
    setState(() {
      filteredReciters = allReciters.where((reciter) {
        return reciter.nameAr!.toLowerCase().contains(query.toLowerCase()) ||
            reciter.nameEn!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(S.of(context).downloads_manager, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // ==========================================
          // Search Bar Section
          // ==========================================
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: _filterReciters,
              decoration: InputDecoration(
                hintText: S.of(context).search_reciter,
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixIcon: Icon(Icons.search_rounded, color: Theme.of(context).primaryColor),
                // Show a clear button only if the user has typed something
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    _filterReciters('');
                  },
                )
                    : null,
                filled: true,
                fillColor: Theme.of(context).cardColor,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
                ),
              ),
            ).animateZoomInStart(duration: const Duration(milliseconds: 400)),
          ),

          // ==========================================
          // Reciters List Section
          // ==========================================
          Expanded(
            child: filteredReciters.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filteredReciters.length,
              itemBuilder: (context, index) {
                final reciter = filteredReciters[index];
                final reciterName = isAr ? reciter.nameAr : reciter.nameEn;
                final rewaya = isAr ? reciter.rewayaAr : reciter.rewayaEn;
                final type = isAr ? reciter.musshafTypeAr : reciter.musshafTypeEn;

                // Calculate how much of this specific reciter's audio is downloaded
                final progress = DownloadStatsHelper.getReciterProgress(reciter, downloadedFiles);
                final isFullyDownloaded = progress == 1.0;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () async {
                        FocusScope.of(context).unfocus(); // Dismiss keyboard
                        // Navigate to the Surahs screen for the selected reciter
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ReciterSurahsScreen(audio: reciter)),
                        );
                        // Refresh data upon returning in case new files were downloaded/deleted
                        _initData();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            // Reciter Image / Avatar
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.2), width: 2),
                              ),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                                // Assuming images are named dynamically based on reciter ID
                                backgroundImage: AssetImage("assets/images/png/${reciter.id}.jpg"),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Reciter Details & Progress Bar
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reciterName ?? '',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '${rewaya!}-${type!}',
                                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // Progress Indicator Row
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: LinearProgressIndicator(
                                            value: progress,
                                            minHeight: 6,
                                            backgroundColor: Colors.grey.shade200,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              isFullyDownloaded ? Colors.green : Theme.of(context).primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${(progress * 100).toInt()}%',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: isFullyDownloaded ? Colors.green : Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 8),
                            // Trailing Arrow Icon
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ).animateBottomToTop(delay: Duration(milliseconds: (index % 12) * 30));
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a UI state indicating that no reciters matched the search query.
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            S.of(context).no_reciter_found,
            style: TextStyle(fontSize: 18, color: Colors.grey.shade500, fontWeight: FontWeight.bold),
          ),
        ],
      ).animateShimmer(), // Apply custom shimmer animation defined in extensions
    );
  }
}