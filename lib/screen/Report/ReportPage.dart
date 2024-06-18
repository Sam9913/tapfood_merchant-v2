import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/provider/ControlProvider.dart';
import 'package:tapfood_v2/provider/ReportProvider.dart';
import 'package:tapfood_v2/screen/Account/AccountPage.dart';
import 'package:tapfood_v2/screen/Addon/AddonListPage.dart';
import 'package:tapfood_v2/screen/Order/HomePage.dart';
import 'package:tapfood_v2/screen/Menu/MenuListPage.dart';
import 'package:tapfood_v2/screen/Report/ReportDetailPage.dart';
import 'package:tapfood_v2/widgets/BottomTab.dart';
import 'package:tapfood_v2/widgets/DateTimePicker.dart';
import 'package:intl/intl.dart';
import 'package:tapfood_v2/widgets/EmptyScreen.dart';
import 'package:tapfood_v2/widgets/LoadingScreen.dart';
import 'package:tapfood_v2/widgets/StackLoadingScreen.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool isLoading = true;
  bool isClickLoading = false;

  @override
  void initState() {
    getReport();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(AppLocalizations.of(context)!.report),
            centerTitle: true,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context)!.start_date),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.44,
                                child: const DateTimePicker(
                                  isStart: true,
                                )),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context)!.end_date),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.44,
                                child: const DateTimePicker(
                                  isStart: false,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                child: Text(
                  AppLocalizations.of(context)!.summary,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16),
                ),
              ),
              Consumer<ReportSummaryProvider>(
                builder: (context, ReportSummaryProvider reportSummaryProvider, child) {
                  return Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.total_sales,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                      fontSize: 13),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("RM "),
                                      Text(reportSummaryProvider.totalIncome.toStringAsFixed(2))
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: VerticalDivider(),
                            ),
                            Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.total_refund,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                      fontSize: 13),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("RM "),
                                      Text(reportSummaryProvider.totalCancel.toStringAsFixed(2))
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: VerticalDivider(),
                            ),
                            Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.total_settlement,
                                  style: const TextStyle(
                                      color: Colors.orangeAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("RM "),
                                      Text(reportSummaryProvider.totalSettlement.toStringAsFixed(2))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context)!.orders,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16),
                ),
              ),
              Expanded(
                child: isLoading
                    ? const LoadingScreen()
                    : Consumer<LoadingProvider>(
                        builder: (context, LoadingProvider loadingProvider, child) {
                          return loadingProvider.isLoading
                              ? const LoadingScreen()
                              : Consumer<ReportProvider>(
                                  builder: (context, ReportProvider reportProvider, child) {
                                    return Container(
                                      color: Colors.white,
                                      child: reportProvider.reportList.isEmpty
                                          ? Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                                              child: EmptyScreen(
                                                  content: AppLocalizations.of(context)!
                                                      .no_orders_within_date_range,
                                                  imageUrl:
                                                      "images/undraw_Blank_canvas_re_2hwy.png",
                                                  height: 0.35),
                                            )
                                          : ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: reportProvider.reportList.length,
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                  onTap: () async {
                                                    setState(() {
                                                      isClickLoading = true;
                                                    });

                                                    await context
                                                        .read<ReportProvider>()
                                                        .getOrderList(reportProvider
                                                            .reportList[index].orderDateTime
                                                            .toString());

                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                            builder: (context) => ReportDetailPage(
                                                                datetime: reportProvider
                                                                    .reportList[index].orderDateTime
                                                                    .toString())))
                                                        .then((value) => {
                                                              setState(() {
                                                                isClickLoading = false;
                                                              })
                                                            });
                                                  },
                                                  leading: CircleAvatar(
                                                    backgroundColor: Colors.grey,
                                                    child: Text(
                                                      DateFormat("EEE").format(DateTime.parse(
                                                          reportProvider
                                                              .reportList[index].orderDateTime
                                                              .toString())),
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  title: Text(DateFormat("dd MMM yyyy").format(
                                                      DateTime.parse(reportProvider
                                                          .reportList[index].orderDateTime
                                                          .toString()))),
                                                  subtitle: Text(
                                                    "${reportProvider.reportList[index].orderCount} "
                                                    "${AppLocalizations.of(context)!.orders.toLowerCase()}, ${reportProvider.reportList[index].cancelCount} ${AppLocalizations.of(context)!.cancelled.toLowerCase()}",
                                                    style: const TextStyle(fontSize: 11),
                                                  ),
                                                  trailing: SizedBox(
                                                    width: 150,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Flexible(
                                                            child: Text(
                                                                "RM ${reportProvider.reportList[index].totalAmount}")),
                                                        const Icon(Icons.chevron_right_rounded)
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                    );
                                  },
                                );
                        },
                      ),
              ),
            ],
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
                      iconData: Icons.description,
                      navigationPage: const ReportPage(),
                      isCurrentPage: true,
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
        Offstage(offstage: !isClickLoading, child: const StackLoadingScreen()),
      ],
    );
  }

  getReport() async {
    final startDate =
        DateFormat("yyyy-MM-dd").format(context.read<DateTimeProvider>().startDateTime);
    final endDate = DateFormat("yyyy-MM-dd").format(context.read<DateTimeProvider>().endDateTime);

    await context.read<ReportProvider>().getByDateRange(startDate, endDate);
    var reportList = context.read<ReportProvider>().reportList;
    double tempTotalSettlement = 0;
    //double tempTotalCharge = 0;
    double tempTotalCancel = 0;
    double tempTotalIncome = 0;

    for (var i = 0; i < reportList.length; i++) {
      tempTotalSettlement += (double.parse(reportList[i].totalAmount.toString()) +
              double.parse(reportList[i].giveAmount.toString())) -
          double.parse(reportList[i].takeAmount.toString());
      tempTotalCancel += double.parse(reportList[i].totalCancelAmount.toString());
      tempTotalIncome += double.parse(reportList[i].totalAmount.toString());
    }

    Provider.of<ReportSummaryProvider>(context, listen: false)
        .setTotal(tempTotalIncome, tempTotalCancel, tempTotalSettlement);

    setState(() {
      isLoading = false;
    });
    await context.read<LoadingProvider>().setIsLoading(false);
  }
}
