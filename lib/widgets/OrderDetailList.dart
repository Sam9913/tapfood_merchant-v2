import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/model/OrderDetail.dart';
import 'package:tapfood_v2/provider/OrderProvider.dart';

class OrderDetailList extends StatefulWidget {
  const OrderDetailList({Key? key}) : super(key: key);

  @override
  _OrderDetailListState createState() => _OrderDetailListState();
}

class _OrderDetailListState extends State<OrderDetailList> with TickerProviderStateMixin {
  double subTotalPrice = 0.0;
  double totalAmount = 0.0;
  double totalTax = 0.0;
  late AnimationController _animationController;
  bool isOpen = false;

  @override
  void initState() {
    getTotalAmount();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      upperBound: 0.5,
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(builder: (context, OrderProvider orderProvider, child) {
      // double subAddonPrice = 0;
      // int? orderItemsLength = orderProvider.orderDetail.orderItems == null
      //     ? 0
      //     : orderProvider.orderDetail.orderItems?.length;
      //
      // for (int j = 0; j < orderItemsLength!; j++) {
      //   int? orderItemsAddonLength =
      //       orderProvider.orderDetail.orderItems?[j].orderItemAddons == null
      //           ? 0
      //           : orderProvider
      //               .orderDetail.orderItems?[j].orderItemAddons?.length;
      //   for (int i = 0; i < orderItemsAddonLength!; i++) {
      //     String? addonPrice = orderProvider
      //         .orderDetail.orderItems?[j].orderItemAddons?[i].price;
      //     int? addonQty = orderProvider
      //         .orderDetail.orderItems?[j].orderItemAddons?[i].quantity;
      //     subAddonPrice += double.parse(addonPrice.toString()) *
      //         int.parse(addonQty.toString());
      //   }
      //
      //   String? amount = orderProvider.orderDetail.orderItems?[j].amount;
      //   int? quantity = orderProvider.orderDetail.orderItems?[j].quantity;
      //   subTotalPrice = (subAddonPrice +
      //       double.parse(amount.toString()) * int.parse(quantity.toString()));
      // }

      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        /*Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Order Item(s)",
            style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ),*/
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                const Divider(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orderProvider.orderDetail.orderItems?.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            RichText(
                              text: TextSpan(
                                  style: const TextStyle(
                                      color: Colors.black, fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            "${orderProvider.orderDetail.orderItems?[index].quantity}"),
                                    const TextSpan(
                                        text: "x ",
                                        style: TextStyle(
                                            color: Colors.grey, fontWeight: FontWeight.normal)),
                                    TextSpan(
                                        text:
                                            "${orderProvider.orderDetail.orderItems?[index].menuItem?.name}")
                                  ]),
                            ),
                            Text("${orderProvider.orderDetail.orderItems?[index].amount}"),
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 0, 0.0, 8.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: orderProvider
                                    .orderDetail.orderItems?[index].orderItemAddons?.length ??
                                0,
                            itemBuilder: (context, addonIndex) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    " ${orderProvider.orderDetail.orderItems?[index].orderItemAddons?[addonIndex].addon?.name}",
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                  Offstage(
                                    offstage: orderProvider.orderDetail.orderItems?[index]
                                            .orderItemAddons?[addonIndex].price
                                            .toString() ==
                                        "0.00",
                                    child: Text(
                                      "+${orderProvider.orderDetail.orderItems?[index].orderItemAddons?[addonIndex].price}",
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 12,
                                          color: Colors.grey),
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                        Offstage(
                          offstage: orderProvider.orderDetail.orderItems?[index].remarks == null ||
                              orderProvider.orderDetail.orderItems?[index].remarks == "",
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              "* ${orderProvider.orderDetail.orderItems?[index].remarks}",
                              style: const TextStyle(
                                  color: Colors.orangeAccent, fontStyle: FontStyle.italic),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.subtotal,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "RM ${totalAmount.toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Offstage(
                  offstage: orderProvider.orderDetail.deliveryAmount.toString() == "0.00",
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.delivery_fee,
                      ),
                      Text(
                        "RM ${double.parse(orderProvider.orderDetail.deliveryAmount.toString()).toStringAsFixed(2)}",
                      ),
                    ],
                  ),
                ),
                Offstage(
                  offstage: orderProvider.orderDetail.discountAmount.toString() == "0.00",
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${AppLocalizations.of(context)!.discount} (${orderProvider.orderDetail.userVoucher?.voucher?.name})"),
                      Text(
                        "- RM ${double.parse(orderProvider.orderDetail.discountAmount.toString()).toStringAsFixed(2)}",
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    setState(() {
                      if (isOpen) {
                        _animationController.reverse(from: 0.5);
                      } else {
                        _animationController.forward(from: 0.0);
                      }
                      isOpen = !isOpen;
                    });
                  },
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(AppLocalizations.of(context)!.tax),
                              RotationTransition(
                                  turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
                                  child: Icon(Icons.keyboard_arrow_down_rounded))
                            ],
                          ),
                          Text(
                            "RM ${totalTax.toStringAsFixed(2)}",
                          ),
                        ],
                      ),
                      Offstage(
                        offstage: !isOpen,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.platform_tax,
                                  style: TextStyle(color: Colors.black45, fontSize: 12),
                                ),
                                Text(
                                  "RM ${double.parse(orderProvider.orderDetail.taxAmount.toString()).toStringAsFixed(2)}",
                                  style: TextStyle(color: Colors.black45, fontSize: 12),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.service_charge,
                                  style: TextStyle(color: Colors.black45, fontSize: 12),
                                ),
                                Text(
                                  "RM ${double.parse(orderProvider.orderDetail.serviceChargeAmount.toString()).toStringAsFixed(2)}",
                                  style: TextStyle(color: Colors.black45, fontSize: 12),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.government_tax,
                                  style: TextStyle(color: Colors.black45, fontSize: 12),
                                ),
                                Text(
                                  "RM ${double.parse(orderProvider.orderDetail.governmentTaxAmount.toString()).toStringAsFixed(2)}",
                                  style: TextStyle(color: Colors.black45, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.order_total,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "RM ${double.parse(orderProvider.orderDetail.totalAmount.toString()).toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16, color: Colors.orange),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]);
    });
  }

  getTotalAmount() async {
    OrderDetail orderDetail = context.read<OrderProvider>().orderDetail;

    double takeAmt = double.parse(orderDetail.taxAmount.toString()) +
        double.parse(orderDetail.deliveryAmount.toString()) +
        double.parse(orderDetail.deliveryMarkupAmount.toString()) +
        double.parse(orderDetail.governmentTaxAmount.toString()) +
        double.parse(orderDetail.serviceChargeAmount.toString());

    double giveAmt = double.parse(orderDetail.discountAmount.toString()) +
        double.parse(orderDetail.tfDiscountAmount.toString()) +
        double.parse(orderDetail.tfDeliveryDiscountAmount.toString()) +
        double.parse(orderDetail.merchantVoucherDiscountAmount.toString());

    setState(() {
      totalAmount = (double.parse(orderDetail.totalAmount.toString()) + giveAmt) - takeAmt;
      totalTax = double.parse(orderDetail.taxAmount.toString()) +
          double.parse(orderDetail.serviceChargeAmount.toString()) +
          double.parse(orderDetail.governmentTaxAmount.toString());
    });
  }
}
