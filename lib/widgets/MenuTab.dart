import 'package:flutter/material.dart';

class MenuTab extends StatelessWidget {
  final int orderCount;
  final String orderTitle;
  const MenuTab({Key? key, required this.orderCount, required this.orderTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(orderTitle),
        Offstage(
            offstage: orderCount == 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 3.0),
              child: CircleAvatar(
                maxRadius: 9.0,
                backgroundColor: Colors.orange,
                child: Text(
                  orderCount > 9 ? "9+" : "$orderCount",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ))
      ],
    );
  }
}
