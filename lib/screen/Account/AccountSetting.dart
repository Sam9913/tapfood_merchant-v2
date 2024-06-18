import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/model/General.dart';
import 'package:tapfood_v2/provider/MerchantProvider.dart';
import 'package:tapfood_v2/screen/Account/OperationHourSetting.dart';
import 'package:tapfood_v2/screen/Account/SpecialHourSetting.dart';
import 'package:tapfood_v2/widgets/StackLoadingScreen.dart';

class AccountSetting extends StatefulWidget {
  const AccountSetting({Key? key}) : super(key: key);

  @override
  _AccountSettingState createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  bool isClickLoading = false;
  final List<DeliveryVehicleType> vehicleType = [
    DeliveryVehicleType(vehicleName: "Both", id: 0),
    DeliveryVehicleType(vehicleName: "Motorcycle", id: 1),
    DeliveryVehicleType(vehicleName: "Car", id: 2)
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.store_settings),
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.orange,
                size: 20,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Consumer<MerchantProvider>(
              builder: (context, MerchantProvider merchantProvider, child) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context)!.delivery,
                      style: const TextStyle(
                          color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(AppLocalizations.of(context)!.vehicle),
                            trailing: DropdownButton(
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.grey,
                              ),
                              alignment: Alignment.centerRight,
                              value: merchantProvider.deliverySetting.delivery,
                              items: vehicleType.map((DeliveryVehicleType items) {
                                return DropdownMenuItem(
                                  value: items.id,
                                  child: Text("${items.vehicleName}"),
                                );
                              }).toList(),
                              onChanged: (value) async {
                                int vehicleId = value! as int;

                                await context.read<MerchantProvider>().updateDeliverySetting(
                                    vehicleId,
                                    int.parse(merchantProvider
                                        .deliverySetting.deliveryPreparationTime
                                        .toString()));

                                setState(() {
                                  merchantProvider.deliverySetting.deliveryVehicle = vehicleId;
                                });

                                Fluttertoast.showToast(
                                    msg:
                                        "${AppLocalizations.of(context)!.delivery_vehicle_message} ${vehicleType.firstWhere((element) => element.id == value).vehicleName}.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white);
                              },
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Divider(),
                          ),
                          ListTile(
                            title: Text(AppLocalizations.of(context)!.preparation_time),
                            trailing: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black38),
                                  borderRadius: BorderRadius.circular(8.0)),
                              width: 120,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      int minuteSelected = int.parse(merchantProvider
                                          .deliverySetting.deliveryPreparationTime
                                          .toString());

                                      if (minuteSelected > 0) {
                                        minuteSelected -= 15;
                                      }

                                      await context.read<MerchantProvider>().updateDeliverySetting(
                                          int.parse(merchantProvider
                                              .deliverySetting.deliveryPreparationTime
                                              .toString()),
                                          minuteSelected);

                                      setState(() {
                                        merchantProvider.deliverySetting.deliveryPreparationTime =
                                            minuteSelected;
                                      });

                                      Fluttertoast.showToast(
                                          msg:
                                              "${AppLocalizations.of(context)!.preparation_time_message} $minuteSelected ${minuteSelected > 0 ? AppLocalizations.of(context)!.minutes : "minute"}.",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.black,
                                          textColor: Colors.white);
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          border: Border(right: BorderSide(color: Colors.black38))),
                                      child: const Padding(
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                      "${merchantProvider.deliverySetting.deliveryPreparationTime}"),
                                  InkWell(
                                    onTap: () async {
                                      int minuteSelected = int.parse(merchantProvider
                                          .deliverySetting.deliveryPreparationTime
                                          .toString());
                                      if (minuteSelected < 60) {
                                        minuteSelected += 15;
                                      }

                                      await context.read<MerchantProvider>().updateDeliverySetting(
                                          int.parse(merchantProvider
                                              .deliverySetting.deliveryPreparationTime
                                              .toString()),
                                          minuteSelected);

                                      setState(() {
                                        merchantProvider.deliverySetting.deliveryPreparationTime =
                                            minuteSelected;
                                      });

                                      Fluttertoast.showToast(
                                          msg:
                                              "${AppLocalizations.of(context)!.preparation_time_message} $minuteSelected ${AppLocalizations.of(context)!.minutes}",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.black,
                                          textColor: Colors.white);
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          border: Border(left: BorderSide(color: Colors.black38))),
                                      child: const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Icon(
                                          Icons.add_rounded,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.operation_hour,
                          style: const TextStyle(
                              color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        InkWell(
                          onTap: () async {
                            setState(() {
                              isClickLoading = true;
                            });
                            bool isSuccess =
                                await context.read<MerchantProvider>().getOperationHourGroup();

                            if (isSuccess) {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (context) => const OperationHourSetting()))
                                  .then((value) {
                                setState(() {
                                  isClickLoading = false;
                                });
                              });
                            }
                          },
                          child: Text(
                            AppLocalizations.of(context)!.edit,
                            style: const TextStyle(
                                color: Colors.orangeAccent, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: merchantProvider.operationHourGrouped.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                  "${merchantProvider.operationHourGrouped[index].firstDay} ${merchantProvider.operationHourGrouped[index].lastDay != null ? "- ${merchantProvider.operationHourGrouped[index].lastDay}" : ""}"),
                              trailing: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.38,
                                height: MediaQuery.of(context).size.height *
                                    (0.025 *
                                        merchantProvider.operationHourGrouped[index].time.length),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      merchantProvider.operationHourGrouped[index].time.length,
                                  itemBuilder: (context, timeIndex) {
                                    return Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                          "${merchantProvider.operationHourGrouped[index].time[timeIndex].openAt} - ${merchantProvider.operationHourGrouped[index].time[timeIndex].closeAt}"),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context)!.special_operation_hour,
                      style: const TextStyle(
                          color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: merchantProvider.specialHourGrouped.isEmpty
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Text(AppLocalizations.of(context)!.no_special_hour),
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          setState(() {
                                            isClickLoading = true;
                                          });

                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) => const SpecialHourSetting()))
                                              .then((value) {
                                            setState(() {
                                              isClickLoading = false;
                                            });
                                          });
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!.add,
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        color: Colors.orange,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: merchantProvider.specialHourGrouped.length,
                                itemBuilder: (context, index) {
                                  DateTime date = DateTime.parse(
                                      merchantProvider.specialHourGrouped[index].date.toString());

                                  return date.isAfter(DateTime.now())
                                      ? ListTile(
                                          title: Text(DateFormat("dd MMM yyyy").format(date)),
                                          subtitle: Text(merchantProvider
                                                      .specialHourGrouped[index].closeStatus ==
                                                  true
                                              ? AppLocalizations.of(context)!.closed
                                              : AppLocalizations.of(context)!.open),
                                          trailing: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    isClickLoading = true;
                                                  });

                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                          builder: (context) => SpecialHourSetting(
                                                              specialHourDate: merchantProvider
                                                                  .specialHourGrouped[index].date)))
                                                      .then((value) {
                                                    setState(() {
                                                      isClickLoading = false;
                                                    });
                                                  });
                                                },
                                                child: Text(
                                                  AppLocalizations.of(context)!.edit,
                                                  style: const TextStyle(
                                                      color: Colors.orangeAccent,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              merchantProvider
                                                      .specialHourGrouped[index].time.isEmpty
                                                  ? const Text("24 Hours")
                                                  : SizedBox(
                                                      height:
                                                          MediaQuery.of(context).size.height * 0.05,
                                                      width:
                                                          MediaQuery.of(context).size.width * 0.37,
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemCount: merchantProvider
                                                            .specialHourGrouped[index].time.length,
                                                        itemBuilder: (context, timeIndex) {
                                                          String openTime = DateFormat("hh:mm a")
                                                              .format(DateFormat("hh:mm:ss").parse(
                                                                  merchantProvider
                                                                      .specialHourGrouped[index]
                                                                      .time[timeIndex]
                                                                      .openAt
                                                                      .toString()));
                                                          String closeTime = DateFormat("hh:mm a")
                                                              .format(DateFormat("hh:mm:ss").parse(
                                                                  merchantProvider
                                                                      .specialHourGrouped[index]
                                                                      .time[timeIndex]
                                                                      .closeAt
                                                                      .toString()));

                                                          return Text("$openTime - $closeTime");
                                                        },
                                                      ),
                                                    )
                                            ],
                                          ),
                                        )
                                      : Dismissible(
                                          key: Key(merchantProvider.specialHourGrouped[index].date
                                              .toString()),
                                          direction: DismissDirection.endToStart,
                                          background: Container(
                                            color: Colors.red,
                                            child: const Align(
                                              alignment: Alignment.centerRight,
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.remove_circle_outline,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          onDismissed: (direction) async {
                                            bool isSuccess = await context
                                                .read<MerchantProvider>()
                                                .deleteOperationHourException(
                                                    DateFormat("yyyy-MM-dd").format(date));

                                            if (isSuccess) {
                                              setState(() {
                                                merchantProvider.specialHourGrouped.removeAt(index);
                                              });

                                              Fluttertoast.showToast(
                                                  msg: AppLocalizations.of(context)!
                                                      .special_hour_removed
                                                      .replaceAll("[###Date###]",
                                                          DateFormat("dd MMM yyyy").format(date)),
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.black,
                                                  textColor: Colors.white);
                                            }
                                          },
                                          child: ListTile(
                                            title: Text(DateFormat("dd MMM yyyy").format(date)),
                                            subtitle: Text(merchantProvider
                                                        .specialHourGrouped[index].closeStatus ==
                                                    true
                                                ? AppLocalizations.of(context)!.closed
                                                : AppLocalizations.of(context)!.open),
                                            trailing: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isClickLoading = true;
                                                    });

                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                            builder: (context) =>
                                                                SpecialHourSetting(
                                                                    specialHourDate:
                                                                        merchantProvider
                                                                            .specialHourGrouped[
                                                                                index]
                                                                            .date)))
                                                        .then((value) {
                                                      setState(() {
                                                        isClickLoading = false;
                                                      });
                                                    });
                                                  },
                                                  child: Text(
                                                    AppLocalizations.of(context)!.edit,
                                                    style: const TextStyle(
                                                        color: Colors.orangeAccent,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                merchantProvider
                                                        .specialHourGrouped[index].time.isEmpty
                                                    ? const Text("24 Hours")
                                                    : SizedBox(
                                                        height: MediaQuery.of(context).size.height *
                                                            0.05,
                                                        width: MediaQuery.of(context).size.width *
                                                            0.37,
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          itemCount: merchantProvider
                                                              .specialHourGrouped[index]
                                                              .time
                                                              .length,
                                                          itemBuilder: (context, timeIndex) {
                                                            String openTime = DateFormat("hh:mm a")
                                                                .format(DateFormat("hh:mm:ss")
                                                                    .parse(merchantProvider
                                                                        .specialHourGrouped[index]
                                                                        .time[timeIndex]
                                                                        .openAt
                                                                        .toString()));
                                                            String closeTime = DateFormat("hh:mm a")
                                                                .format(DateFormat("hh:mm:ss")
                                                                    .parse(merchantProvider
                                                                        .specialHourGrouped[index]
                                                                        .time[timeIndex]
                                                                        .closeAt
                                                                        .toString()));

                                                            return Text("$openTime - $closeTime");
                                                          },
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        );
                                },
                              )),
                  ),
                ],
              ),
            );
          }),
        ),
        Offstage(offstage: !isClickLoading, child: const StackLoadingScreen()),
      ],
    );
  }
}
