import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/model/Merchant.dart';
import 'package:tapfood_v2/provider/AddonProvider.dart';
import 'package:tapfood_v2/provider/AuthProvider.dart';
import 'package:tapfood_v2/provider/ControlProvider.dart';
import 'package:tapfood_v2/provider/NotificationProvider.dart';
import 'package:tapfood_v2/provider/OrderProvider.dart';
import 'package:tapfood_v2/services/PusherServices.dart';
import 'package:tapfood_v2/screen/Account/AccountPage.dart';
import 'package:tapfood_v2/screen/Addon/AddonListPage.dart';
import 'package:tapfood_v2/screen/Menu/MenuListPage.dart';
import 'package:tapfood_v2/screen/Report/ReportPage.dart';
import 'package:tapfood_v2/widgets/BottomTab.dart';
import 'package:tapfood_v2/widgets/LoadingScreen.dart';
import 'package:tapfood_v2/widgets/MenuTab.dart';
import 'package:tapfood_v2/widgets/OrderList.dart';
import 'package:tapfood_v2/widgets/StackLoadingScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;
  String sequence = "asc";
  late Merchant auth;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    setToken();
    getOrder();
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    PusherServices pusherServices = PusherServices(context.read<OrderProvider>());

    if (state == AppLifecycleState.resumed) {
      pusherServices.initPusher();
      pusherServices.onConnect(auth);
      await context.read<LoadingProvider>().setIsLoading(true);

      bool isReadFinish = false;
      isReadFinish = await context.read<OrderProvider>().getNormalOrder();
      isReadFinish = await context.read<OrderProvider>().getScheduledOrder();
      isReadFinish = await context.read<OrderProvider>().getCompletedOrder();

      if (isReadFinish) {
        await context.read<LoadingProvider>().setIsLoading(false);
      }
    } else if (state == AppLifecycleState.paused) {
      pusherServices.disconnect(auth);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.orders),
            centerTitle: true,
            automaticallyImplyLeading: false,
            bottom: TabBar(
                onTap: (index) async {
                  await context.read<LoadingProvider>().setIsLoading(true);

                  bool isReadFinish = false;
                  if (index == 0) {
                    isReadFinish = await context.read<OrderProvider>().getNormalOrder();
                  } else if (index == 1) {
                    isReadFinish = await context.read<OrderProvider>().getScheduledOrder();
                  } else {
                    isReadFinish = await context.read<OrderProvider>().getCompletedOrder();
                  }

                  if (isReadFinish) {
                    await context.read<LoadingProvider>().setIsLoading(false);
                  }
                },
                isScrollable: false,
                controller: _tabController,
                tabs: [
                  Consumer<OrderProvider>(
                    builder: (context, OrderProvider orderProvider, child) {
                      return Tab(
                        child: MenuTab(
                            orderTitle: AppLocalizations.of(context)!.preparing,
                            orderCount: orderProvider.preparingOrderCount),
                      );
                    },
                  ),
                  Consumer<OrderProvider>(
                    builder: (context, OrderProvider orderProvier, child) {
                      return Tab(
                        child: MenuTab(
                            orderTitle: AppLocalizations.of(context)!.upcoming,
                            orderCount: orderProvier.upcomingOrderCount),
                      );
                    },
                  ),
                  Tab(
                    child: Center(child: Text(AppLocalizations.of(context)!.completed)),
                  ),
                ],
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: Colors.orange,
                indicatorColor: Colors.orange),
            /*actions: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                  elevation: 0,
                  color: Colors.orange,
                  onPressed: () {
                    setState(() {
                      sequence = sequence == "asc" ? "desc" : "asc";
                    });
                  },
                  child: Row(
                    children: [
                      const Text(
                        "Time",
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(
                        sequence == "asc" ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              )
            ],*/
          ),
          body:
              Consumer<LoadingProvider>(builder: (context, LoadingProvider loadingProvider, child) {
            return TabBarView(controller: _tabController, children: [
              Stack(
                children: [
                  const OrderList(orderStatus: 0),
                  Offstage(offstage: !loadingProvider.isLoading, child: const LoadingScreen())
                ],
              ),
              Stack(
                children: [
                  const OrderList(orderStatus: 2),
                  Offstage(offstage: !loadingProvider.isLoading, child: const LoadingScreen())
                ],
              ),
              Stack(
                children: [
                  const OrderList(orderStatus: 1),
                  Offstage(offstage: !loadingProvider.isLoading, child: const LoadingScreen())
                ],
              ),
            ]);
          }),
          /*TabBarView(
            controller: _tabController,
            children: [
              Consumer<LoadingProvider>(
                  builder: (context, LoadingProvider loadingProvider, child) {
                return loadingProvider.isLoading
                    ? const LoadingScreen()
                    : const OrderList(orderStatus: 0);
              }),
              Consumer<LoadingProvider>(
                  builder: (context, LoadingProvider loadingProvider, child) {
                return loadingProvider.isLoading
                    ? const LoadingScreen()
                    : const OrderList(orderStatus: 2);
              }),
              Consumer<LoadingProvider>(
                  builder: (context, LoadingProvider loadingProvider, child) {
                return loadingProvider.isLoading
                    ? const LoadingScreen()
                    : const OrderList(orderStatus: 1);
              }),
            ],
          ),*/
          bottomNavigationBar: BottomAppBar(
            child: SizedBox(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                child: Row(
                  children: <Widget>[
                    BottomTab(
                      title: AppLocalizations.of(context)!.home,
                      iconData: Icons.home_rounded,
                      navigationPage: const HomePage(),
                      isCurrentPage: true,
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
                      iconData: Icons.account_circle_outlined,
                      navigationPage: const AccountPage(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Consumer<LoadingProvider>(
          builder: (context, LoadingProvider loadingProvider, child) {
            return Offstage(
              offstage: !loadingProvider.isClickLoading,
              child: const StackLoadingScreen(),
            );
          },
        )
      ],
    );
  }

  getOrder() async {
    bool isReadFinish = false;
    isReadFinish = await context.read<OrderProvider>().getNormalOrder();
    if (isReadFinish) {
      await context.read<LoadingProvider>().setIsLoading(false);
    }

    await context.read<OrderProvider>().getScheduledOrder();
    await context.read<OrderProvider>().getCompletedOrder();

    setState(() {
      auth = context.read<AuthProvider>().auth;
    });

    PusherServices pusherServices = PusherServices(context.read<OrderProvider>());
    pusherServices.initPusher();
    pusherServices.onConnect(auth);
    await context.read<AddonProvider>().getAllCategory();
  }

  setToken() async {
    await context.read<NotificationProvider>().setToken();
  }
}
