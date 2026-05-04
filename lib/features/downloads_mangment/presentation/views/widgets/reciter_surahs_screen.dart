import 'package:elda3ia_tour/core/utls/functions/show_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qcf_quran_lite/qcf_quran_lite.dart';

// Ensure you import your generated localization file here
// import 'package:elda3ia_tour/generated/l10n.dart';

import '../../../../../core/utls/widgets/app_animations.dart';
import '../../../../../generated/l10n.dart';
import '../../../../quran/data/models/audio_model.dart';
import '../../manger/download_cubit.dart';
import 'download_stats_helper.dart';

/// A screen displaying all 114 Surahs for a specific [AudioModel] (Reciter).
///
/// It allows users to view the download progress of each Surah, download/delete
/// individual Surahs, or open a bottom sheet to batch-download a range of Surahs.
class ReciterSurahsScreen extends StatefulWidget {
  /// The reciter's audio metadata used to fetch and store files.
  final AudioModel audio;

  const ReciterSurahsScreen({super.key, required this.audio});

  @override
  State<ReciterSurahsScreen> createState() => _ReciterSurahsScreenState();
}

class _ReciterSurahsScreenState extends State<ReciterSurahsScreen> {
  /// A cached set of all currently downloaded file names for O(1) fast lookups.
  Set<String> downloadedFiles = {};

  /// Indicates whether the initial file scan is still running.
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshFiles();
  }

  /// Scans the local directory and updates the [downloadedFiles] set.
  ///
  /// Called on initialization and whenever a download/delete operation succeeds.
  Future<void> _refreshFiles() async {
    final files = await DownloadStatsHelper.getAllDownloadedFiles();
    setState(() {
      downloadedFiles = files;
      isLoading = false;
    });
  }

  /// Displays a modal bottom sheet allowing the user to select a range of Surahs
  /// for batch downloading.
  void _showBatchDownloadBottomSheet(BuildContext context, bool isAr) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BatchDownloadBottomSheet(
          audio: widget.audio,
          isAr: isAr,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final reciterName = isAr ? widget.audio.nameAr : widget.audio.nameEn;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(reciterName ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showBatchDownloadBottomSheet(context, isAr),
        icon: const Icon(Icons.checklist_rtl_rounded),
        label: Text(S.of(context).multi_download),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ).animateZoomInStart(),

      body: BlocConsumer<DownloadCubit, DownloadState>(
        listener: (context, state) {
          if (state is DownloadSuccess || state is DeleteSuccess) {
            _refreshFiles();
            if (state is DownloadSuccess) {
              SnackbarHelper.showSuccess(S.of(context).download_success);
            }
          } else if (state is DownloadError) {
            SnackbarHelper.showError(state.message);
          }
        },
        builder: (context, state) {
          if (isLoading) return const Center(child: CircularProgressIndicator());

          return Column(
            children: [
              // Global progress bar indicating active batch operations
              if (state is DownloadLoading)
                LinearProgressIndicator(
                  value: state.progress,
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                ),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 12, bottom: 80, left: 16, right: 16),
                  itemCount: 114,
                  itemBuilder: (context, index) {
                    int surahNumber = index + 1;
                    String surahName = isAr
                        ? getSurahNameArabic(surahNumber)
                        : getSurahName(surahNumber);

                    int versesCount = getVerseCount(surahNumber);
                    double progress = DownloadStatsHelper.getSurahProgress(widget.audio, surahNumber, downloadedFiles);
                    bool isFullyDownloaded = progress == 1.0;

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
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        leading: Container(
                          width: 45,
                          height: 45,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                          ),
                          child: Text(
                            '$surahNumber',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        title: Text(surahName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: Text('$versesCount ${S.of(context).verses}', style: TextStyle(color: Colors.grey.shade600)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Show percentage if partially downloaded
                            if (progress > 0 && progress < 1.0)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  '${(progress * 100).toInt()}%',
                                  style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                                ),
                              ),

                            IconButton(
                              icon: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: Icon(
                                  isFullyDownloaded ? Icons.delete_outline_rounded : Icons.cloud_download_rounded,
                                  key: ValueKey(isFullyDownloaded),
                                  color: isFullyDownloaded ? Colors.redAccent : Theme.of(context).primaryColor,
                                  size: 28,
                                ),
                              ),
                              onPressed: () {
                                if (isFullyDownloaded) {
                                  context.read<DownloadCubit>().deleteSurahRangeForVerse(
                                      widget.audio, surahNumber - 1, surahNumber - 1);
                                } else {
                                  context.read<DownloadCubit>().downloadSurahRangeForVerse(
                                      widget.audio, surahNumber - 1, surahNumber - 1);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ).animateBottomToTop(delay: Duration(milliseconds: (index % 10) * 30));
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ==========================================
// Batch Download Range Selector Bottom Sheet
// ==========================================

/// A bottom sheet that allows users to select a starting and ending Surah
/// to download them in bulk.
class BatchDownloadBottomSheet extends StatefulWidget {
  final AudioModel audio;
  final bool isAr;

  const BatchDownloadBottomSheet({super.key, required this.audio, required this.isAr});

  @override
  State<BatchDownloadBottomSheet> createState() => _BatchDownloadBottomSheetState();
}

class _BatchDownloadBottomSheetState extends State<BatchDownloadBottomSheet> {
  int startSurah = 1;
  int endSurah = 114;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle indicator
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            S.of(context).batch_download,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            S.of(context).batch_download_desc,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          const SizedBox(height: 24),

          // Start Surah Selection
          _buildSurahDropdown(
            title: S.of(context).from_surah,
            value: startSurah,
            maxLimit: endSurah, // Prevent selecting a start surah that comes after the end surah
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  startSurah = val;
                  if (endSurah < startSurah) {
                    endSurah = startSurah;
                  }
                });
              }
            },
          ),
          const SizedBox(height: 16),

          // End Surah Selection
          _buildSurahDropdown(
            title: S.of(context).to_surah,
            value: endSurah,
            minLimit: startSurah, // Prevent selecting an end surah that comes before the start surah
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  endSurah = val;
                  if (startSurah > endSurah) {
                    startSurah = endSurah;
                  }
                });
              }
            },
          ),

          const SizedBox(height: 32),

          // Confirmation Button
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context); // Close bottom sheet
                // Trigger batch download in the cubit
                context.read<DownloadCubit>().downloadSurahRangeForVerse(
                    widget.audio,
                    startSurah - 1,
                    endSurah - 1
                );
              },
              icon: const Icon(Icons.cloud_download),
              label: Text(
                S.of(context).start_download,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
            ),
          ).animateZoomInStart(),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Helper method to build a standardized dropdown for Surah selection.
  ///
  /// [minLimit] and [maxLimit] are used to disable invalid Surah options
  /// based on the current selection of the other dropdown.
  Widget _buildSurahDropdown({
    required String title,
    required int value,
    int? minLimit,
    int? maxLimit,
    required ValueChanged<int?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value,
              dropdownColor: Theme.of(context).primaryColor,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white),
              style: const TextStyle(color: Colors.white),
              items: List.generate(114, (index) {
                int surahNum = index + 1;
                String name = widget.isAr ? getSurahNameArabic(surahNum) : getSurahName(surahNum);

                // Determine if the option should be selectable based on limits
                bool isEnabled = true;
                if (minLimit != null && surahNum < minLimit) isEnabled = false;
                if (maxLimit != null && surahNum > maxLimit) isEnabled = false;

                return DropdownMenuItem(
                  value: surahNum,
                  enabled: isEnabled,
                  child: Text(
                    '$surahNum - $name',
                    style: TextStyle(
                        fontSize: 16,
                        color: isEnabled ? Colors.white : Colors.white38 // Dim disabled options
                    ),
                  ),
                );
              }),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}