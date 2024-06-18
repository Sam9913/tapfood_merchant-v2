import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter_sunmi_printer/flutter_sunmi_printer.dart';
import 'package:intl/intl.dart';
import 'package:tapfood_v2/model/OrderDetail.dart';

class PrintReceipt {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  printWithSunmi(OrderDetail currentOrder) {
    SunmiPrinter.hr();
    SunmiPrinter.text(
      "#TF-" + currentOrder.orderId.toString(),
      styles: const SunmiStyles(align: SunmiAlign.center, bold: true),
    );
    if (currentOrder.queueId != null) {
      SunmiPrinter.text(
        "Queue No: ${currentOrder.queueId}",
        styles: const SunmiStyles(align: SunmiAlign.center),
      );
    }
    if (currentOrder.tableNo != null) {
      SunmiPrinter.text(
        "Table No: ${currentOrder.tableNo}",
        styles: const SunmiStyles(align: SunmiAlign.center),
      );
    }
    SunmiPrinter.text(
      "Customer Name: ${currentOrder.userName}",
      styles: const SunmiStyles(align: SunmiAlign.center),
    );
    SunmiPrinter.text(
      "Order Preference: " +
          (currentOrder.orderPreference == 0
              ? "Dine In"
              : currentOrder.orderPreference == 1
                  ? "Self Pick Up"
                  : currentOrder.orderPreference == 2
                      ? "Delivery"
                      : currentOrder.orderPreference == 3
                          ? "Drive Thru"
                          : "Campus Delivery"),
      styles: const SunmiStyles(align: SunmiAlign.center),
    );
    SunmiPrinter.hr();

    final formatter = DateFormat('dd-MM-yyyy HH:mma');
    final orderDateTime = DateTime.parse(currentOrder.orderDateTime.toString());
    final String timestamp = formatter.format(orderDateTime);
    SunmiPrinter.text("Order Time: " + timestamp);
    final pickUpTime = currentOrder.scheduledAt == null
        ? DateTime.now()
        : DateTime.parse(currentOrder.scheduledAt.toString());
    final String timestamp2 = formatter.format(pickUpTime);
    SunmiPrinter.text(
      "Pick Up At: " + (currentOrder.scheduledAt == null ? "ASAP" : timestamp2),
      styles: const SunmiStyles(align: SunmiAlign.left),
    );

    if (currentOrder.orderNote != null) {
      SunmiPrinter.text(
        "Order Note: ${currentOrder.orderNote}",
        styles: const SunmiStyles(align: SunmiAlign.left),
      );
    }

    SunmiPrinter.text("-------------------------------",
        styles: const SunmiStyles(bold: true, size: SunmiSize.md));

    int? orderItemsLength = currentOrder.orderItems?.length;
    for (int i = 0; i < orderItemsLength!; i++) {
      SunmiPrinter.text(
          "${currentOrder.orderItems?[i].quantity}x  ${currentOrder.orderItems?[i].menuItem?.name}");

      int? orderItemAddonsLength = currentOrder.orderItems?[i].orderItemAddons?.length;
      if (orderItemAddonsLength! > 0) {
        for (int j = 0; j < orderItemAddonsLength; j++) {
          SunmiPrinter.text(
              "   (+) ${currentOrder.orderItems?[i].orderItemAddons?[j].addon?.name}");
        }
      }
      if (currentOrder.orderItems?[i].remarks != "") {
        SunmiPrinter.text("   * ${currentOrder.orderItems?[i].remarks}");
      }

      //SunmiPrinter.text("-------------------------------", styles: SunmiStyles(bold: true, size:SunmiSize.md));
    }
    SunmiPrinter.hr();
    SunmiPrinter.text("-Completed-",
        styles: const SunmiStyles(bold: true, size: SunmiSize.md, align: SunmiAlign.center));
    SunmiPrinter.emptyLines(3);
  }

  Future<String> printWithNormalPrinter(OrderDetail currentOrder) async {
    String response = await bluetooth.isConnected.then((isConnected) {
      if (isConnected!) {
        bluetooth.printCustom("-------------------------------", 0, 0);
        bluetooth.printCustom("#TF-${currentOrder.orderId}", 1, 1, charset: "windows-936");
        if (currentOrder.queueId != null) {
          bluetooth.printCustom("Queue No: ${currentOrder.queueId}", 0, 1, charset: "windows-936");
        }
        if (currentOrder.tableNo != null) {
          bluetooth.printCustom("Table No: ${currentOrder.tableNo}", 0, 1, charset: "windows-936");
        }
        bluetooth.printCustom("Customer Name: ${currentOrder.userName}", 0, 1,
            charset: "windows-936");

        bluetooth.printCustom(
            "Order Preference: " +
                (currentOrder.orderPreference == 0
                    ? "Dine In"
                    : currentOrder.orderPreference == 1
                        ? "Self Pick Up"
                        : currentOrder.orderPreference == 2
                            ? "Delivery"
                            : currentOrder.orderPreference == 3
                                ? "Drive Thru"
                                : "Campus Delivery"),
            0,
            1,
            charset: "windows-936");

        bluetooth.printCustom("-------------------------------", 0, 0);
        final formatter = DateFormat('dd-MM-yyyy HH:mma');
        final orderDateTime = DateTime.parse(currentOrder.orderDateTime.toString());
        final String timestamp = formatter.format(orderDateTime);
        bluetooth.printCustom("Order Time: " + timestamp, 0, 0);

        final pickUpTime = currentOrder.scheduledAt == null
            ? DateTime.now()
            : DateTime.parse(currentOrder.scheduledAt.toString());
        final String timestamp2 = formatter.format(pickUpTime);
        bluetooth.printCustom(
            "Pick Up At: " + (currentOrder.scheduledAt == null ? "ASAP" : timestamp2), 0, 0);

        if (currentOrder.orderNote != null) {
          bluetooth.printCustom("Order Note: ${currentOrder.orderNote}", 0, 0,
              charset: "windows-936");
        }

        bluetooth.printCustom("-------------------------------", 0, 0);

        int? orderItemsLength = currentOrder.orderItems?.length;
        for (int i = 0; i < orderItemsLength!; i++) {
          bluetooth.printCustom(
              "${currentOrder.orderItems?[i].quantity}x  ${currentOrder.orderItems?[i].menuItem?.name}",
              0,
              0,
              charset: "windows-936");

          int? orderItemAddonsLength = currentOrder.orderItems?[i].orderItemAddons?.length;
          if (orderItemAddonsLength! > 0) {
            for (int j = 0; j < orderItemAddonsLength; j++) {
              bluetooth.printCustom(
                  "   (+) ${currentOrder.orderItems?[i].orderItemAddons?[j].addon?.name}", 0, 0,
                  charset: "windows-936");
            }
          }
          if (currentOrder.orderItems?[i].remarks != "") {
            bluetooth.printCustom("   * ${currentOrder.orderItems?[i].remarks}", 0, 0,
                charset: "windows-936");
          }
        }

        bluetooth.printCustom("-------------------------------", 0, 0);
        bluetooth.printCustom("   -Completed-  ", 2, 1);
        bluetooth.printNewLine();

        bluetooth.paperCut();
        return 'Order ${currentOrder.orderId} receipt is printing...';
      } else {
        return 'No printer detected or connect. Please retry';
      }
    });

    return response;
  }
}
