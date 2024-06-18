import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/model/Order.dart';
import 'package:tapfood_v2/provider/ControlProvider.dart';
import 'package:tapfood_v2/provider/OrderProvider.dart';

class OrderCard extends StatefulWidget {
  final Order orderItem;
  const OrderCard({Key? key, required this.orderItem}) : super(key: key);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
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
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Row(
              children: [
                Text("TF-${_orderItem.orderId}",
                    style: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16)),
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
                ),
                Expanded(
                  flex: 1,
                  child: Offstage(
                    offstage: _orderItem.status != 0,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () async {
                          await context.read<LoadingProvider>().setIsLoading(true);

                          bool isSuccess = await context
                              .read<OrderProvider>()
                              .updateOrderStatus(int.parse(_orderItem.orderId.toString()));

                          await context.read<LoadingProvider>().setIsLoading(false);

                          if (isSuccess) {
                            setState(() {
                              _orderItem.status = 1;
                            });
                          }

                          Fluttertoast.showToast(
                              msg: isSuccess
                                  ? AppLocalizations.of(context)!
                                      .order_status_update_success
                                      .replaceAll("[###OrderID###]", _orderItem.orderId.toString())
                                  : AppLocalizations.of(context)!.update_fail,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white);
                        },
                        child: Container(
                          width: 70,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(color: Colors.grey)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(
                                Icons.check,
                                size: 20,
                              ),
                              Text(AppLocalizations.of(context)!.done)
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
          Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
              child: _orderItem.orderPreference == 2
                  ? Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .item_count
                              .replaceAll("[###ItemCount###]", "${_orderItem.itemCount}"),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(AppLocalizations.of(context)!
                            .for_user
                            .replaceAll("[###UserName###]", " ${_orderItem.userName}"))
                      ],
                    )
                  : Row(
                      children: [
                        Text(AppLocalizations.of(context)!
                            .user_ordered
                            .replaceAll("[###UserName###]", "${_orderItem.userName}")),
                        Text(
                          AppLocalizations.of(context)!
                              .item_count
                              .replaceAll("[###ItemCount###]", " ${_orderItem.itemCount}"),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
          /*Offstage(
            offstage: _orderItem.orderNote == null,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(),
                  Text("Notes from customer", style: TextStyle(color: Colors.grey),),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: Colors.orange[200],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${_orderItem.orderNote}",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 8,
          )*/
        ],
      ),
    );
  }
}
