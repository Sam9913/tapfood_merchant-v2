import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/config/enum.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/model/Menu.dart';
import 'package:tapfood_v2/provider/ControlProvider.dart';
import 'package:tapfood_v2/provider/MenuProvider.dart';
import 'package:tapfood_v2/screen/Account/AccountPage.dart';
import 'package:tapfood_v2/screen/Addon/AddonListPage.dart';
import 'package:tapfood_v2/screen/Menu/MenuDetailPage.dart';
import 'package:tapfood_v2/screen/Menu/MenuPage.dart';
import 'package:tapfood_v2/screen/Menu/MenuSearchPage.dart';
import 'package:tapfood_v2/screen/Order/HomePage.dart';
import 'package:tapfood_v2/screen/Report/ReportPage.dart';
import 'package:tapfood_v2/widgets/BottomTab.dart';
import 'package:tapfood_v2/widgets/LoadingScreen.dart';
import 'package:tapfood_v2/widgets/MenuList.dart';

class MenuListPage extends StatefulWidget {
  const MenuListPage({Key? key}) : super(key: key);

  @override
  _MenuListPageState createState() => _MenuListPageState();
}

class _MenuListPageState extends State<MenuListPage> {
  @override
  void initState() {
    getMenu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations.of(context)!.menu),
        centerTitle: true,
        leading: InkWell(
          child: const Icon(
            Icons.search,
            color: Colors.orange,
          ),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const MenuSearchPage()));
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: PopupMenuButton(
              child: const Icon(
                Icons.add,
                color: Colors.orange,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text(AppLocalizations.of(context)!.add_category),
                  value: MenuPage(
                    menu: Menu(menuId: 0),
                  ),
                ),
                PopupMenuItem(
                    child: Text(AppLocalizations.of(context)!.add_item),
                    value: const MenuDetailPage(
                      menuItemId: 0,
                    ))
              ],
              onSelected: (Widget navigationPage) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => navigationPage));
              },
            ),
          ),
        ],
      ),
      body: Consumer<LoadingProvider>(
        builder: (context, LoadingProvider loadingProvider, child){
          return loadingProvider.isLoading ? LoadingScreen() : const MenuList();
        },
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
                  iconData: Icons.fastfood,
                  navigationPage: const MenuListPage(),
                ),
                BottomTab(
                  title: AppLocalizations.of(context)!.report,
                  iconData: Icons.description_outlined,
                  navigationPage: const ReportPage(),
                ),
                BottomTab(
                  title: AppLocalizations.of(context)!.account,
                  iconData: Icons.account_circle_outlined,
                  navigationPage: const AccountPage(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getMenu() async {
    await context.read<MenuProvider>().getAll();
    context
        .read<AvailabilityProvider>()
        .setAvailability(Availability.available);

    await context.read<LoadingProvider>().setIsLoading(false);
  }
}
