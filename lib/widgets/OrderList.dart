import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/provider/ControlProvider.dart';
import 'package:tapfood_v2/provider/OrderProvider.dart';
import 'package:tapfood_v2/widgets/EmptyScreen.dart';
import 'package:tapfood_v2/widgets/LoadingScreen.dart';
import 'package:tapfood_v2/widgets/NormalOrderListItem.dart';
import 'package:tapfood_v2/widgets/OrderListItem.dart';

class OrderList extends StatefulWidget {
  final int orderStatus;
  const OrderList({Key? key, required this.orderStatus}) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Consumer<OrderProvider>(
          builder: (context, OrderProvider orderProvider, child) {
            switch (widget.orderStatus) {
              case 0:
                if (orderProvider.isLoading[0]) {
                  return const LoadingScreen();
                } else if (orderProvider.normalOrderList.isEmpty) {
                  return EmptyScreen(
                    content: AppLocalizations.of(context)!.no_order_currently,
                    imageUrl: "images/undraw_Empty_re_opql.png",
                    height: 0.72,
                  );
                } else {
                  return RefreshIndicator(
                    onRefresh: () async {
                      await context.read<LoadingProvider>().setIsLoading(true);
                      await orderProvider.getNormalOrder();
                      await context.read<LoadingProvider>().setIsLoading(false);
                    },
                    child: ListView.builder(
                        itemCount: orderProvider.normalOrderList.length,
                        itemBuilder: (context, index) {
                          return NormalOrderListItem(
                              orderItem: orderProvider.normalOrderList[index]);
                        }),
                  );
                }
              case 1:
                if (orderProvider.isLoading[1]) {
                  return const LoadingScreen();
                } else if (orderProvider.completedOrderList.isEmpty) {
                  return EmptyScreen(
                    content: AppLocalizations.of(context)!.no_order_currently,
                    imageUrl: "images/undraw_Empty_re_opql.png",
                    height: 0.72,
                  );
                } else {
                  return RefreshIndicator(
                    onRefresh: () async {
                      await context.read<LoadingProvider>().setIsLoading(true);
                      await orderProvider.getCompletedOrder();
                      await context.read<LoadingProvider>().setIsLoading(false);
                    },
                    child: ListView.builder(
                        itemCount: orderProvider.completedOrderList.length,
                        itemBuilder: (context, index) {
                          return OrderListItem(orderItem: orderProvider.completedOrderList[index]);
                        }),
                  );
                }
              case 2:
                if (orderProvider.isLoading[2]) {
                  return const LoadingScreen();
                } else if (orderProvider.scheduledOrderList.isEmpty) {
                  return EmptyScreen(
                    content: AppLocalizations.of(context)!.no_order_currently,
                    imageUrl: "images/undraw_Empty_re_opql.png",
                    height: 0.72,
                  );
                } else {
                  return RefreshIndicator(
                    onRefresh: () async {
                      await context.read<LoadingProvider>().setIsLoading(true);
                      await orderProvider.getScheduledOrder();
                      await context.read<LoadingProvider>().setIsLoading(false);
                    },
                    child: ListView.builder(
                        itemCount: orderProvider.scheduledOrderList.length,
                        itemBuilder: (context, index) {
                          return OrderListItem(orderItem: orderProvider.scheduledOrderList[index]);
                        }),
                  );
                }
              default:
                return const LoadingScreen();
            }
          },
        ));
  }
}
