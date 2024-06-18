import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/config/appConfig.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/provider/AuthProvider.dart';
import 'package:tapfood_v2/provider/MerchantProvider.dart';
import 'package:tapfood_v2/screen/Account/AccountSetting.dart';
import 'package:tapfood_v2/screen/Account/AppSetting.dart';
import 'package:tapfood_v2/screen/Account/PrinterSetting.dart';
import 'package:tapfood_v2/screen/Addon/AddonListPage.dart';
import 'package:tapfood_v2/screen/Order/HomePage.dart';
import 'package:tapfood_v2/screen/Menu/MenuListPage.dart';
import 'package:tapfood_v2/screen/Report/ReportPage.dart';
import 'package:tapfood_v2/widgets/BottomTab.dart';
import 'package:tapfood_v2/widgets/LoadingScreen.dart';
import 'package:tapfood_v2/widgets/RestartWidget.dart';
import 'package:tapfood_v2/widgets/StackLoadingScreen.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool isLoading = false;
  bool isClickLoading = false;
  bool isSunmi = false;

  @override
  void initState() {
    getMerchant();
    getDevice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(AppLocalizations.of(context)!.account),
            automaticallyImplyLeading: false,
          ),
          body: isLoading
              ? const LoadingScreen()
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * (isSunmi ? 0.42 : 0.48),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Consumer<AuthProvider>(
                              builder: (context, AuthProvider authProvider, child) {
                                return ListTile(
                                  onTap: () async {
                                    setState(() {
                                      isClickLoading = true;
                                    });

                                    await context
                                        .read<MerchantProvider>()
                                        .getMerchantStoreSetting(AppLocalizations.of(context)!);

                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => const AccountSetting()))
                                        .then((value) {
                                      setState(() {
                                        isClickLoading = false;
                                      });
                                    });
                                  },
                                  leading: CircleAvatar(
                                      radius: 25,
                                      backgroundImage: NetworkImage(Config().imageUrl +
                                          "${authProvider.auth.user?.userImage}")),
                                  title: Text("${authProvider.auth.name}"),
                                  subtitle: SizedBox(
                                    height: 30,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Transform.translate(
                                          offset: const Offset(-8, 0),
                                          child: Switch(
                                            value: int.parse(authProvider.auth.operationStatus
                                                        .toString()) ==
                                                    0
                                                ? false
                                                : true,
                                            activeColor: Colors.orange,
                                            onChanged: (val) async {
                                              await context.read<MerchantProvider>().updateStatus();

                                              await getMerchant();
                                            },
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius: BorderRadius.circular(8.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              int.parse(authProvider.auth.operationStatus
                                                          .toString()) ==
                                                      0
                                                  ? AppLocalizations.of(context)!.closed
                                                  : AppLocalizations.of(context)!.open,
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  trailing: const Icon(
                                    Icons.chevron_right_rounded,
                                    color: Colors.orange,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.settings_outlined),
                                title: Transform.translate(
                                    offset: const Offset(-16, 0),
                                    child: Text(AppLocalizations.of(context)!.setting)),
                                trailing: const Icon(Icons.chevron_right_rounded),
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => const AppSetting()));
                                },
                              ),
                              Offstage(
                                offstage: isSunmi,
                                child: ListTile(
                                  leading: const Icon(Icons.local_printshop_rounded),
                                  title: Transform.translate(
                                      offset: const Offset(-16, 0),
                                      child: Text(AppLocalizations.of(context)!.printer_setting)),
                                  trailing: const Icon(Icons.chevron_right_rounded),
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => const PrinterSetting()));
                                  },
                                ),
                              ),
                              ListTile(
                                leading: const Icon(Icons.info_outline),
                                title: Transform.translate(
                                    offset: const Offset(-16, 0),
                                    child: Text(AppLocalizations.of(context)!.app_version)),
                                trailing: const Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Text("1.6.1"),
                                ),
                              ),
                              ListTile(
                                onTap: () async {
                                  bool isSuccess = await context.read<AuthProvider>().logout();
                                  if (isSuccess) {
                                    RestartWidget.restartApp(context);
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Logout fail, please contact our team for help",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.black,
                                        textColor: Colors.white);
                                  }
                                },
                                leading: const Icon(
                                  Icons.logout,
                                  color: Colors.red,
                                ),
                                title: Transform.translate(
                                    offset: const Offset(-16, 0),
                                    child: Text(AppLocalizations.of(context)!.log_out)),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          bottomNavigationBar: BottomAppBar(
            child: SizedBox(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                child: Row(
                  children: <Widget>[
                    BottomTab(
                      title: AppLocalizations.of(context)!.home,
                      iconData: Icons.home_outlined,
                      navigationPage: const HomePage(),
                    ),
                    BottomTab(
                      title: AppLocalizations.of(context)!.addon,
                      iconData: Icons.add_box_outlined,
                      navigationPage: const AddonListPage(),
                    ),
                    BottomTab(
                      title: AppLocalizations.of(context)!.menu,
                      iconData: Icons.fastfood_outlined,
                      navigationPage: const MenuListPage(),
                    ),
                    BottomTab(
                      title: AppLocalizations.of(context)!.report,
                      iconData: Icons.description_outlined,
                      navigationPage: const ReportPage(),
                    ),
                    BottomTab(
                      title: AppLocalizations.of(context)!.account,
                      iconData: Icons.account_circle,
                      navigationPage: const AccountPage(),
                      isCurrentPage: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Offstage(offstage: !isClickLoading, child: const StackLoadingScreen()),
      ],
    );
  }

  getMerchant() async {
    var tempLoading = await context.read<AuthProvider>().getMerchant();

    setState(() {
      isLoading = !tempLoading;
    });
  }

  getDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    if (androidDeviceInfo.brand == "SUNMI") {
      setState(() {
        isSunmi = true;
      });
    }
  }
}
