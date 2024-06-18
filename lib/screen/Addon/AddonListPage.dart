import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/config/enum.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/model/AddonCategory.dart';
import 'package:tapfood_v2/provider/AddonProvider.dart';
import 'package:tapfood_v2/provider/ControlProvider.dart';
import 'package:tapfood_v2/screen/Account/AccountPage.dart';
import 'package:tapfood_v2/screen/Addon/AddonItemPage.dart';
import 'package:tapfood_v2/screen/Addon/AddonPage.dart';
import 'package:tapfood_v2/screen/Addon/AddonSearchPage.dart';
import 'package:tapfood_v2/screen/Order/HomePage.dart';
import 'package:tapfood_v2/screen/Menu/MenuListPage.dart';
import 'package:tapfood_v2/screen/Report/ReportPage.dart';
import 'package:tapfood_v2/widgets/AddonList.dart';
import 'package:tapfood_v2/widgets/BottomTab.dart';
import 'package:tapfood_v2/widgets/LoadingScreen.dart';

class AddonListPage extends StatefulWidget {
  const AddonListPage({Key? key}) : super(key: key);

  @override
  _AddonListPageState createState() => _AddonListPageState();
}

class _AddonListPageState extends State<AddonListPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    getAddon();
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addon),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: InkWell(
          child: const Icon(
            Icons.search,
            color: Colors.orange,
          ),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const AddonSearchPage()));
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
                  value: AddonPage(
                    addonCategory: AddonCategory(),
                  ),
                ),
                PopupMenuItem(
                    child: Text(AppLocalizations.of(context)!.add_item),
                    value: const AddonItemPage())
              ],
              onSelected: (Widget navigationPage) {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => navigationPage));
              },
            ),
          ),
        ],
        bottom: TabBar(
            onTap: (index) async {
              await context.read<LoadingProvider>().setIsLoading(true);

              var tempLoading = await context.read<AddonProvider>().getCategoryByType(index);

              await context.read<LoadingProvider>().setIsLoading(!tempLoading);
            },
            isScrollable: false,
            controller: _tabController,
            tabs: [
              Tab(
                child: Text(AppLocalizations.of(context)!.optional),
              ),
              Tab(
                child: Text(AppLocalizations.of(context)!.required),
              )
            ],
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Colors.orange,
            indicatorColor: Colors.orange),
      ),
      body: Consumer<LoadingProvider>(
              builder: (context, LoadingProvider loadingProvider, child) {
                return loadingProvider.isLoading
                    ? const LoadingScreen()
                    : TabBarView(
                        controller: _tabController,
                        children: const [AddonList(), AddonList()],
                      );
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
                  iconData: Icons.add_box_rounded,
                  navigationPage: const AddonListPage(),
                  isCurrentPage: true,
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

  getAddon() async {
    await context.read<AddonProvider>().getCategoryByType(0);
    context.read<AvailabilityProvider>().setAvailability(Availability.available);

    await context.read<LoadingProvider>().setIsLoading(false);
  }
}
