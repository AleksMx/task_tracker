import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_tracker/dashboard/presentation/pages/dashboard/ui/dashboard_screen.dart';
import 'package:task_tracker/services/AppLogic.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  static const String appTitle = 'Task Tracker';

  int appUpdateCounter = 0;

  @override
  void initState() {
    super.initState();

    App().subscribeUpdateEvent((_) {
      setState(() {
        appUpdateCounter++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        return getAppContent(context);
      }
    );
  }


  Widget getAppContent(BuildContext context) {
    return MaterialApp(
      key: Key('mainApp_{$appUpdateCounter}'),
      title: appTitle,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => const DashboardScreen()
      }
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();
  static bool isInit = false;

  Future initialize() async {
    if (isInit) {
      return;
    }

    //await Firebase.initializeApp();
    await App().init();

    //
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    isInit = true;
  }
}