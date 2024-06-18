import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/provider/AddonProvider.dart';
import 'package:tapfood_v2/provider/AppPreferenceProvider.dart';
import 'package:tapfood_v2/provider/AuthProvider.dart';
import 'package:tapfood_v2/provider/ControlProvider.dart';
import 'package:tapfood_v2/provider/MenuProvider.dart';
import 'package:tapfood_v2/provider/MerchantProvider.dart';
import 'package:tapfood_v2/provider/NotificationProvider.dart';
import 'package:tapfood_v2/provider/OrderProvider.dart';
import 'package:tapfood_v2/provider/ReportProvider.dart';
import 'package:tapfood_v2/screen/Order/HomePage.dart';
import 'package:tapfood_v2/screen/Login.dart';
import 'package:tapfood_v2/services/appLanguage.dart';
import 'package:tapfood_v2/utils/locator.dart';
import 'package:tapfood_v2/widgets/AppLoadingScreen.dart';
import 'package:tapfood_v2/widgets/AppLossConnection.dart';
import 'package:tapfood_v2/widgets/RestartWidget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'model/General.dart';

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();
final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();
String? selectedNotificationPayload;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "MainNavigator");

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
bool isFlutterLocalNotificationsInitialized = false;
Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  var channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound("notification_sound"),
  );

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

Future<void> main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  AppLanguage appLanguage = AppLanguage();
  AuthProvider authProvider = AuthProvider();
  AppPreference appPreferenceProvider = AppPreference();

  runApp(RestartWidget(
    child: FutureBuilder(
      future: Future.wait([
        appLanguage.fetchLocale(),
        authProvider.checkIsAuth(),
        appPreferenceProvider.fetchSettings()
      ]),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? MyApp(
                appLanguage: appLanguage,
                authProvider: authProvider,
                appPreference: appPreferenceProvider)
            : const AppLoadingScreen();
      },
    ),
  ));

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

class MyApp extends StatefulWidget {
  final AppLanguage appLanguage;
  final AuthProvider authProvider;
  final AppPreference appPreference;
  const MyApp(
      {Key? key,
      required this.appLanguage,
      required this.authProvider,
      required this.appPreference})
      : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool isConnected = true;
  bool isLatest = true;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  String currentVersion = "1.6.1";
  GlobalKey<NavigatorState> globalKey = locator<DialogService>().navigatorKey;


  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    checkConnectivity();
    checkAppVersion();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    setupFlutterNotifications();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: widget.authProvider,
        ),
        ChangeNotifierProvider.value(
          value: widget.appPreference,
        ),
        ChangeNotifierProvider.value(
          value: widget.appLanguage,
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddonProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MenuProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ReportProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AvailabilityProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DateTimeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ReportSummaryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoadingProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MerchantProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MenuCategoryProvider(),
        ),
      ],
      child: Consumer<AppLanguage>(builder: (context, model, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: model.appLocal,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          title: 'TapFood',
          theme: ThemeData(
            platform: TargetPlatform.android,
            appBarTheme: const AppBarTheme(
                color: Colors.white,
                titleTextStyle: TextStyle(
                    color: Colors.orange,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                elevation: 0),
            primaryColor: const Color.fromRGBO(32, 32, 32, 1),
            primaryColorLight: const Color.fromRGBO(133, 139, 147, 1),
            backgroundColor: Colors.white,
            canvasColor: const Color.fromRGBO(243, 244, 245, 1),
            fontFamily: 'Lato',
            primaryIconTheme: ThemeData.light().iconTheme.copyWith(
                  color: const Color.fromRGBO(32, 32, 32, 1),
                ),
            primaryTextTheme: ThemeData.light().textTheme.copyWith(
                  headline1: const TextStyle(
                    color: Color.fromRGBO(32, 32, 32, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  bodyText1: const TextStyle(
                    color: Color.fromRGBO(32, 32, 32, 1),
                  ),
                  bodyText2: const TextStyle(
                    color: Color.fromRGBO(133, 139, 147, 1),
                  ),
                  headline6: const TextStyle(
                    color: Color.fromRGBO(32, 32, 32, 1),
                  ),
                  button: const TextStyle(
                    color: Colors.white,
                  ),
                  caption: const TextStyle(
                    color: Color.fromRGBO(133, 139, 147, 1),
                  ),
                ),
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange)
                .copyWith(secondary: const Color.fromRGBO(133, 139, 147, 1)),
            inputDecorationTheme: const InputDecorationTheme(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              border: OutlineInputBorder(
                gapPadding: 3.0,
              ),
            ),
          ),
          home: Scaffold(
            body: Stack(
              children: [
                !isConnected
                    ? const AppLossConnection()
                    : widget.authProvider.isAuth
                        ? const HomePage()
                        : const LoginPage(),
                Offstage(
                  offstage: isLatest,
                  child: Container(
                    color: Colors.grey.withOpacity(0.5),
                    child: Center(
                      child: Container(
                        width: 300,
                        height: 150,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Found newer version",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const Text("Please download latest version to proceed"),
                              MaterialButton(
                                minWidth: 270,
                                onPressed: () async {
                                  final Uri uri = Uri.https(
                                      "play.google.com",
                                      "/store/apps/details",
                                      {"id": "com.tapfood.production"});
                                  await launchUrl(uri);
                                },
                                color: Colors.orange,
                                child: const Text(
                                  "Download",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          //routes: routes,
          navigatorKey: globalKey,
        );
      }),
    );
  }

  checkAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    if (version == currentVersion) {
      setState(() {
        isLatest = true;
      });
    } else {
      setState(() {
        isLatest = false;
      });
    }
  }

  checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isConnected = false;
      });
    } else {
      setState(() {
        isConnected = true;
      });
    }
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      setState(() {
        isConnected = false;
      });
    } else {
      setState(() {
        isConnected = true;
      });
    }
  }
}
