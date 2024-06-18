import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapfood_v2/function/ChangeFocus.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/model/General.dart';
import 'package:tapfood_v2/provider/AuthProvider.dart';
import 'package:tapfood_v2/provider/NotificationProvider.dart';
import 'package:tapfood_v2/provider/OrderProvider.dart';
import 'package:tapfood_v2/services/PusherServices.dart';
import 'package:tapfood_v2/screen/Order/HomePage.dart';
import 'package:tapfood_v2/services/appLanguage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  late bool isLoading = false;
  late bool textFieldEnabled = true;
  bool isHide = false;
  bool isPasswordFocus = false;
  int langId = 0;
  List<Language> languageSelection = [
    Language.fromJson({"langCode": "en", "name": "English", "id": 0}),
    Language.fromJson({"langCode": "ms", "name": "Melayu", "id": 1}),
    Language.fromJson({"langCode": "zh", "name": "中文", "id": 2}),
  ];

  @override
  void initState() {
    _passwordFocus.addListener(() {
      setState(() {
        isPasswordFocus = _passwordFocus.hasFocus;
      });
    });
    getLanguageId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.1),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (langId == 2) {
                    langId = 0;
                  } else {
                    langId += 1;
                  }
                });

                var langCode = languageSelection
                    .firstWhere((element) => element.id == langId)
                    .langCode;
                context.read<AppLanguage>().changeLanguage(Locale(langCode!));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.language),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(languageSelection
                          .firstWhere((element) => element.id == langId)
                          .name
                          .toString())
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "images/logo.png",
                width: size.height >= 600.0 && size.width >= 1024.0 ? 200 : 100,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                child: Text(
                  AppLocalizations.of(context)!.welcome,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size.height >= 600.0 && size.width >= 1024.0
                          ? 34
                          : 28),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                child: Text(
                  AppLocalizations.of(context)!.log_in_content,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size.height >= 600.0 && size.width >= 1024.0
                          ? 22
                          : 14),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                child: TextField(
                  enabled: textFieldEnabled,
                  focusNode: _emailFocus,
                  controller: _emailController,
                  decoration: InputDecoration(
                    suffixIcon: const Icon(
                      Icons.mail,
                      color: Colors.orange,
                    ),
                    labelText: AppLocalizations.of(context)!.email,
                    hintText: 'email@gmail.com',
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  ),
                  onEditingComplete: () {
                    ChangeFocus()
                        .fieldFocusChange(context, _emailFocus, _passwordFocus);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                child: TextField(
                  enabled: textFieldEnabled,
                  focusNode: _passwordFocus,
                  controller: _passwordController,
                  obscureText: isHide ? false : true,
                  textInputAction: TextInputAction.go,
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 1.0),
                    ),
                    suffixIcon: const Icon(
                      Icons.lock,
                      color: Colors.orange,
                    ),
                    suffix: InkWell(
                      onTap: (){
                        if(isPasswordFocus) {
                          setState(() {
                            isHide = !isHide;
                          });
                        }
                      },
                      child: Icon(
                        isHide ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
                        color: isPasswordFocus ? Colors.orange : Colors.grey[100],
                      ),
                    ),
                    labelText: AppLocalizations.of(context)!.password,
                    hintText: '6+ characters',
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  ),
                  onEditingComplete: () {
                    setState(() {
                      _passwordFocus.unfocus();
                    });
                  },
                  onSubmitted: (String value){
                    login();
                  },
                ),
              ),
              SizedBox(
                width: 270,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                  child: isLoading
                      // ignore: prefer_const_constructors
                      ? Center(child: SpinKitThreeBounce(color: Colors.orange))
                      : MaterialButton(
                          //splashColor: notifier.color(),
                          color: Colors.orange,
                          onPressed: ()  {
                            login();
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: const BorderSide(color: Colors.orange),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.log_in,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getLanguageId() async {
    var prefs = await SharedPreferences.getInstance();
    var tempSelection = languageSelection.firstWhere(
        (element) => element.langCode == (prefs.getString("language_code") ?? "en"));

    setState(() {
      langId = int.parse(tempSelection.id.toString());
    });
  }

  login() async{
    setState(() {
      isLoading = !isLoading;
      textFieldEnabled = !textFieldEnabled;
    });

    bool isAuth = await context
        .read<AuthProvider>()
        .signIn(_emailController.text,
        _passwordController.text);
    if (isAuth) {
      var auth = context.read<AuthProvider>().auth;
      Fluttertoast.showToast(
          msg:
          "${AppLocalizations.of(context)!.welcome_back}, ${auth.name}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white);

      PusherServices pusherServices = PusherServices(context.read<OrderProvider>());
      pusherServices.initPusher();
      context.read<NotificationProvider>().initNotification();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } else {
      Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.login_fail,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white);

      setState(() {
        isLoading = !isLoading;
        textFieldEnabled = !textFieldEnabled;
      });
    }
  }
}
