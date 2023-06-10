import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:commercio/firebase_options.dart';
import 'package:commercio/i18n/translations.g.dart';
import 'package:commercio/router/router.dart';
import 'package:commercio/screens/login/login_localizations.dart';
import 'package:commercio/state/locale.dart';
import 'package:commercio/state/shared_perfernces_provider.dart';
import 'package:commercio/state/theme_mode.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };
  final prefs = await SharedPreferences.getInstance();

  if (kDebugMode) {
    Animate.restartOnHotReload = true;
    print('============= using emulators ============');
    await FirebaseAuth.instance.useAuthEmulator('192.168.1.26', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('192.168.1.26', 8080);
    FirebaseFunctions.instance.useFunctionsEmulator('192.168.1.26', 5001);
    await FirebaseStorage.instance.useStorageEmulator('192.168.1.26', 9199);
  }

  FirebaseUIAuth.configureProviders(
    [
      EmailAuthProvider(),
      GoogleProvider(clientId: ''),
    ],
  );
  runApp(
    ProviderScope(
      overrides: [
        sharedPerferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeState = ref.watch(themeModeProvider);

    final translations = ref.watch(translationProvider);
    return ScreenUtilInit(
      designSize: const Size(1080, 2340),
      builder: (context, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          locale: translations.locale.flutterLocale,
          supportedLocales: AppLocale.values.map((e) => e.flutterLocale),
          localizationsDelegates: [
            ...GlobalMaterialLocalizations.delegates,
            GlobalWidgetsLocalizations.delegate,
            FirebaseUILocalizations.withDefaultOverrides(
              LoginLocalilzations(translations.translations),
            ),
            FormBuilderLocalizations.delegate,
          ],
          theme: ThemeData.light(
            useMaterial3: true,
          ).copyWith(
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
            brightness: Brightness.dark,
          ),
          themeMode: themeState.flutterThemeMode,
        );
      },
    );
  }
}
