import 'package:background_downloader/background_downloader.dart';
import 'package:elda3ia_tour/core/utls/audio_state/audio_cubit.dart';
import 'package:elda3ia_tour/features/quran/presentation/manger/quran_cubit.dart';
import 'package:elda3ia_tour/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:just_audio/just_audio.dart';
import 'package:toastification/toastification.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'core/utls/theme_and_local/app_themes.dart';
import 'core/utls/theme_and_local/theme_and_local_cubit.dart';
import 'features/downloads_mangment/presentation/manger/download_cubit.dart';
import 'features/quran/data/repos/quran_repo_impl.dart';
import 'features/quran/presentation/manger/audio/audio_quran_cubit.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: false,


  );
  await FileDownloader().configure(
    globalConfig: [
      (Config.requestTimeout, const Duration(minutes: 30)),
    ],
  );
  FileDownloader().configureNotificationForGroup(
    FileDownloader.defaultGroup,
    running: const TaskNotification(
        'جاري التحميل', 'ملف: {filename} - {progress}'),
    complete: const TaskNotification(
        'اكتمل التحميل', 'تم تحميل {filename} بنجاح'),
    error: const TaskNotification(
        'خطأ في التحميل', 'فشل تحميل {filename}'),
    paused: const TaskNotification(
        'تم الإيقاف', 'تحميل {filename} متوقف مؤقتاً'),
    canceled: const TaskNotification(
        'تم الإلغاء', 'تم إلغاء تحميل {filename}'),
    progressBar: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeAndLocalCubit()..loadPreferences(),
        ),
        BlocProvider<DownloadCubit>(
          create: (context) => DownloadCubit(),
        ),
        BlocProvider(
          create: (context) => QuranCubit(repo:QuranRepoImpl())..init(),
        ),
        BlocProvider(
          create: (context) => AudioCubit(AudioPlayer()),
        ),

        BlocProvider(
          create: (context) => QuranPlayerCubit(context.read<AudioCubit>()),
        ),


      ],
      child: BlocBuilder<ThemeAndLocalCubit, ThemeAndLocalState>(
        builder: (context, state) {
          return ToastificationWrapper(
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: "Basira - القرآن الكريم",
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(state.fontScale),
                  ),
                  child: child!,
                );
              },

              theme: AppThemes.lightThemes[state.theme] ?? AppThemes.lightThemes['blue']!,
              darkTheme: AppThemes.darkThemes[state.theme] ?? AppThemes.darkThemes['blue']!,
              themeMode: state.isDark ? ThemeMode.dark : ThemeMode.light,
            
              locale: Locale(state.locale),
            
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
            
              supportedLocales: S.delegate.supportedLocales,
            
              routerConfig: AppRouter.router,
            ),
          );
        },
      ),
    );
  }
}