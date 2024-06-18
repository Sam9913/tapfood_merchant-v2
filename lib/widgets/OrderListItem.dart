import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/model/Order.dart';
import 'package:tapfood_v2/provider/ControlProvider.dart';
import 'package:tapfood_v2/provider/OrderProvider.dart';
import 'package:tapfood_v2/screen/Order/OrderDetailPage.dart';

class OrderListItem extends StatefulWidget {
  final Order orderItem;
  const OrderListItem({Key? key, required this.orderItem}) : super(key: key);

  @override
  _OrderListItemState createState() => _OrderListItemState();
}

class _OrderListItemState extends State<OrderListItem> {
  late Order _orderItem;

  @override
  void initState() {
    setState(() {
      _orderItem = widget.orderItem;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              children: [
                Text(
                  "TF-${_orderItem.orderId}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: InkWell(
                    onTap: () async {
                      await context.read<LoadingProvider>().setIsLoading(true);

                      bool isSuccess = await context
                          .read<OrderProvider>()
                          .updatePaymentStatus(int.parse(_orderItem.orderId.toString()));

                      await context.read<LoadingProvider>().setIsLoading(false);

                      if (isSuccess) {
                        setState(() {
                          _orderItem.paymentStatus = 1;
                        });
                      }

                      Fluttertoast.showToast(
                          msg: isSuccess
                              ? AppLocalizations.of(context)!
                                  .order_payment_update
                                  .replaceAll("[###OrderID###]", _orderItem.orderId.toString())
                              : AppLocalizations.of(context)!.update_fail,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: _orderItem.status == 3
                              ? Colors.grey
                              : _orderItem.paymentStatus == 1
                                  ? Colors.green
                                  : Colors.red,
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
                        child: Text(
                          _orderItem.status == 3
                              ? AppLocalizations.of(context)!.cancelled
                              : _orderItem.paymentStatus == 1
                                  ? AppLocalizations.of(context)!.paid
                                  : AppLocalizations.of(context)!.unpaid,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          subtitle: Text(_orderItem.orderPreference == 2
              ? AppLocalizations.of(context)!
                  .delivery_order_description
                  .replaceAll("[###UserName###]", "${_orderItem.userName}")
                  .replaceAll("[###ItemCount###]", "${_orderItem.itemCount}")
              : AppLocalizations.of(context)!
                  .others_order_description
                  .replaceAll("[###UserName###]", "${_orderItem.userName}")
                  .replaceAll("[###ItemCount###]", "${_orderItem.itemCount}")),
          onTap: () async {
            await context.read<LoadingProvider>().setIsClickLoading(true);

            await context
                .read<OrderProvider>()
                .getOrderDetail(int.parse(_orderItem.orderId.toString()));

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OrderDetailPage()),
            ).then((value) async {
              await context.read<LoadingProvider>().setIsClickLoading(false);
            });
          },
        ),
      ),
    );
  }
}
