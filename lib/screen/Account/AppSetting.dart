import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/model/General.dart';
import 'package:tapfood_v2/provider/AppPreferenceProvider.dart';
import 'package:tapfood_v2/services/appLanguage.dart';
import 'package:device_info_plus/device_info_plus.dart';

class AppSetting extends StatefulWidget {
  const AppSetting({Key? key}) : super(key: key);

  @override
  State<AppSetting> createState() => _AppSettingState();
}

class _AppSettingState extends State<AppSetting> {
  bool isSunmi = false;
  int languageId = 0;
  List<Language> languageSelection = [
    Language.fromJson({"langCode": "en", "name": "English", "id": 0}),
    Language.fromJson({"langCode": "ms", "name": "Melayu", "id": 1}),
    Language.fromJson({"langCode": "zh", "name": "中文", "id": 2}),
  ];

  @override
  void initState() {
    getDevice();
    getLanguageId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.app_settings),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.orange,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            ListTile(
              title: Text(AppLocalizations.of(context)!.language),
              trailing: DropdownButton(
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey,
                ),
                value: languageId,
                items: languageSelection.map((Language items) {
                  return DropdownMenuItem(
                    value: items.id,
                    child: Text("${items.name}"),
                  );
                }).toList(),
                onChanged: (value) async {
                  int langId = value! as int;
                  String? langCode =
                      languageSelection.firstWhere((element) => element.id == langId).langCode;

                  context.read<AppLanguage>().changeLanguage(Locale(langCode!));
                  

                  setState(() {
                    languageId = langId;
                  });
                },
              ),
            ),
            Offstage(offstage: !isSunmi, child: const Divider()),
            Offstage(
              offstage: !isSunmi,
              child: Consumer<AppPreference>(
                builder: (context, AppPreference appPreference, child) {
                  return ListTile(
                    title: Text(AppLocalizations.of(context)!.auto_print_receipt),
                    trailing: Switch(
                      activeColor: Colors.orange,
                      onChanged: (bool value) async {
                        await context.read<AppPreference>().changeAutoPrintPreference(value);
                      },
                      value: appPreference.is_auto_print,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  getLanguageId() async {
    var prefs = await SharedPreferences.getInstance();
    var tempSelection = languageSelection
        .firstWhere((element) => element.langCode == prefs.getString("language_code"));

    setState(() {
      languageId = int.parse(tempSelection.id.toString());
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
