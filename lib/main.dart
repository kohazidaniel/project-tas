import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_i18n/loaders/file_translation_loader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/services/dialog_service.dart';
import 'package:tas/ui/views/startup_view.dart';
import 'managers/dialog_manager.dart';
import 'ui/router.dart';
import 'locator.dart';

void main() async {
  setupLocator();
  final FlutterI18nDelegate flutterI18nDelegate = FlutterI18nDelegate(
    translationLoader: FileTranslationLoader(
        useCountryCode: false,
        fallbackFile: 'en',
        basePath: 'assets/lang',
        forcedLocale: Locale('hu')),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await flutterI18nDelegate.load(null);

  runApp(MyApp(flutterI18nDelegate));
}

class MyApp extends StatelessWidget {
  final FlutterI18nDelegate flutterI18nDelegate;

  MyApp(this.flutterI18nDelegate);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TAS",
      builder: (context, child) => Navigator(
        key: locator<DialogService>().dialogNavigationKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => DialogManager(child: child)),
      ),
      navigatorKey: locator<NavigationService>().navigationKey,
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 9, 202, 172),
        backgroundColor: Color.fromARGB(255, 26, 27, 30),
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Open Sans',
            ),
      ),
      localizationsDelegates: [
        flutterI18nDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      home: StartUpView(),
      onGenerateRoute: generateRoute,
    );
  }
}
