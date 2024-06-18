import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/function/PrintReceipt.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/model/Order.dart';
import 'package:tapfood_v2/model/OrderDetail.dart';
import 'package:tapfood_v2/provider/ControlProvider.dart';
import 'package:tapfood_v2/provider/OrderProvider.dart';
import 'package:tapfood_v2/screen/Order/HomePage.dart';
import 'package:tapfood_v2/widgets/LoadingScreen.dart';
import 'package:tapfood_v2/widgets/OrderCard.dart';
import 'package:tapfood_v2/widgets/OrderDetailList.dart';
import 'package:tapfood_v2/widgets/PersonDetail.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({Key? key}) : super(key: key);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  bool isSunmi = false;
  int orderId = 0;
  int status = 0;
  String userName = "";
  bool isLoading = false;
  late OrderDetail currentOrder;
  Courier currentCourier = Courier();

  @override
  void initState() {
    getDevice();
    getOrderDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.order_details),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.orange, borderRadius: BorderRadius.circular(8.0)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                      child: Text(
                        currentOrder.orderPreference == 0
                            ? AppLocalizations.of(context)!.dine_in
                            : currentOrder.orderPreference == 1
                                ? AppLocalizations.of(context)!.self_pick_up
                                : currentOrder.orderPreference == 2
                                    ? AppLocalizations.of(context)!.delivery
                                    : currentOrder.orderPreference == 3
                                        ? AppLocalizations.of(context)!.drive_thru
                                        : AppLocalizations.of(context)!.campus_delivery,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    )),
              ),
            ],
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.orange,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            Offstage(
              offstage: !isSunmi,
              child: InkWell(
                child: const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.print,
                    color: Colors.orange,
                  ),
                ),
                onTap: () {
                  PrintReceipt().printWithSunmi(currentOrder);
                },
              ),
            ),
            Offstage(
              offstage: isSunmi,
              child: InkWell(
                child: const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.print,
                    color: Colors.orange,
                  ),
                ),
                onTap: () async{
                  String response = await PrintReceipt().printWithNormalPrinter(currentOrder);

                  Fluttertoast.showToast(
                      msg: response,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white);
                },
              ),
            )
          ],
        ),
        body: Consumer<LoadingProvider>(builder: (context, LoadingProvider loadingProvider, child) {
          return Consumer<OrderProvider>(
            builder: (context, OrderProvider orderProvider, child) {
              Order orderItem = orderProvider.orderItem;
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          OrderCard(
                            orderItem: orderItem,
                          ),
                          Offstage(
                            offstage: orderItem.orderPreference != 2,
                            child: PersonDetail(
                              orderId: orderItem.orderId.toString(),
                              contactNumber: currentCourier.phone == null
                                  ? ""
                                  : currentCourier.phone
                                      .toString()
                                      .substring(1, currentCourier.phone.toString().length),
                              tableNo: "null",
                              trackingUrl: orderItem.trackingUrl.toString(),
                              personRole: AppLocalizations.of(context)!.rider,
                              personName: currentCourier.name.toString(),
                              orderPreference: int.parse(orderItem.orderPreference.toString()),
                              orderTime: DateTime.parse(orderItem.orderDateTime.toString()),
                              queueId: orderItem.queueId ?? 0,
                            ),
                          ),
                          PersonDetail(
                            orderId: orderItem.orderId.toString(),
                            contactNumber: orderItem.contactNumber.toString(),
                            tableNo: orderItem.tableNo.toString(),
                            trackingUrl: "null",
                            personRole: AppLocalizations.of(context)!.order_summary,
                            personName: orderItem.userName.toString(),
                            orderPreference: int.parse(orderItem.orderPreference.toString()),
                            orderTime: DateTime.parse(orderItem.orderDateTime.toString()),
                            queueId: orderItem.queueId ?? 0,
                          ),
                          Offstage(
                            offstage: orderItem.orderNote == null,
                            child: Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4.0),
                                      child: Text(
                                        AppLocalizations.of(context)!.customer_notes_title,
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.amberAccent,
                                          borderRadius: BorderRadius.circular(8.0)),
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("${orderItem.orderNote}"),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const OrderDetailList()
                        ],
                      ),
                    ),
                  ),
                  Offstage(offstage: !loadingProvider.isLoading, child: const LoadingScreen())
                ],
              );
            },
          );
        }),
        bottomNavigationBar:
            Consumer<LoadingProvider>(builder: (context, LoadingProvider loadingProvider, child) {
          return Offstage(
            offstage: loadingProvider.isLoading || status != 0,
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: MaterialButton(
                  onPressed: () {
                    _showCancelDialog(context);
                  },
                  color: Colors.red,
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        }));
  }

  Future<void> _showCancelDialog(BuildContext context2) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.cancel_confirmation),
          content: Text(AppLocalizations.of(context)!
                  .confirm_to_cancel
                  .replaceFirst("[###OrderID###]", "$orderId")
                  .replaceFirst("[###Name###]", userName) +
              "?"),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)!.no),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.yes),
              onPressed: () async {
                String successMessage = AppLocalizations.of(context)!
                    .order_cancel_success
                    .replaceAll("[###OrderID###]", orderId.toString());
                String failMessage = AppLocalizations.of(context)!.cancel_fail;

                Navigator.of(context).pop();
                await context.read<LoadingProvider>().setIsLoading(true);
                bool isSuccess = await context.read<OrderProvider>().cancelOrder(orderId);
                await context2.read<LoadingProvider>().setIsLoading(false);

                Fluttertoast.showToast(
                    msg: isSuccess ? successMessage : failMessage,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white);

                if (isSuccess) {
                  Navigator.of(context2)
                      .pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
                }
              },
            ),
          ],
        );
      },
    );
  }

  getOrderDetail() {
    Order tempOrderItem = context.read<OrderProvider>().orderItem;

    setState(() {
      currentOrder = context.read<OrderProvider>().orderDetail;
      orderId = int.parse(tempOrderItem.orderId.toString());
      userName = tempOrderItem.userName.toString();
      status = int.parse(tempOrderItem.status.toString());
      currentCourier = context.read<OrderProvider>().courier;
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
