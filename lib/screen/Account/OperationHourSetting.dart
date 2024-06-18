import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/model/General.dart';
import 'package:tapfood_v2/model/OperationHour.dart';
import 'package:tapfood_v2/provider/ControlProvider.dart';
import 'package:tapfood_v2/provider/MerchantProvider.dart';
import 'package:tapfood_v2/widgets/TimePicker.dart';

class OperationHourSetting extends StatefulWidget {
  const OperationHourSetting({Key? key}) : super(key: key);

  @override
  State<OperationHourSetting> createState() => _OperationHourSettingState();
}

class _OperationHourSettingState extends State<OperationHourSetting> {
  @override
  Widget build(BuildContext context) {
    List<ItemType> weekday = [
      ItemType(name: AppLocalizations.of(context)!.monday, id: 1),
      ItemType(name: AppLocalizations.of(context)!.tuesday, id: 2),
      ItemType(name: AppLocalizations.of(context)!.wednesday, id: 3),
      ItemType(name: AppLocalizations.of(context)!.thursday, id: 4),
      ItemType(name: AppLocalizations.of(context)!.friday, id: 5),
      ItemType(name: AppLocalizations.of(context)!.saturday, id: 6),
      ItemType(name: AppLocalizations.of(context)!.sunday, id: 7),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.edit_operation_hour),
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
          return ListView.builder(
            itemCount: merchantProvider.operationHourGroup.length,
            itemBuilder: (context, index) {
              return Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                          "${weekday.firstWhere((element) => element.id == int.parse(merchantProvider.operationHourGroup[index].day.toString())).name}"),
                      trailing: Switch(
                        value: merchantProvider.operationHourGroup[index].isSet,
                        activeColor: Colors.orange,
                        onChanged: (bool value) {},
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: merchantProvider.operationHourGroup[index].is24,
                          onChanged: (value) {
                            String date = DateFormat("yyyy-mm-dd").format(DateTime.now());

                            if (value == true) {
                              setState(() {
                                merchantProvider.operationHourGroup[index].openCloseTime[0].openAt =
                                    DateTime.parse("$date 00:00:00");
                                merchantProvider.operationHourGroup[index].openCloseTime[0]
                                    .closedAt = DateTime.parse("$date 00:00:00");
                              });
                            } else {
                              setState(() {
                                merchantProvider.operationHourGroup[index].openCloseTime[0].openAt =
                                    DateTime.parse("$date 10:00:00");
                                merchantProvider.operationHourGroup[index].openCloseTime[0]
                                    .closedAt = DateTime.parse("$date 22:00:00");
                              });
                            }
                          },
                          activeColor: Colors.orange,
                        ),
                        const Text("24 Hours")
                      ],
                    ),
                    Offstage(
                        offstage: merchantProvider.operationHourGroup[index].is24,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              merchantProvider.operationHourGroup[index].openCloseTime.length,
                          itemBuilder: (context, openCloseIndex) {
                            return Offstage(
                              offstage: merchantProvider
                                  .operationHourGroup[index].openCloseTime[openCloseIndex].isDelete,
                              child: TimePicker(
                                openCloseTime: merchantProvider
                                    .operationHourGroup[index].openCloseTime[openCloseIndex],
                                index: -1,
                                normalIndex: index,
                                secondaryIndex: openCloseIndex,
                              ),
                            );
                          },
                        ) /*TimePicker(
                          openCloseTime: merchantProvider.operationHourGroup[index].openCloseTime,
                          index: -1,
                          normalIndex: index,
                        )*/
                        ),
                    Offstage(
                      offstage: merchantProvider.operationHourGroup[index].is24,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            context.read<MerchantProvider>().addOpenCloseTime(
                                index,
                                AppLocalizations.of(context)!.cover_most,
                                AppLocalizations.of(context)!.illogic_operation_add);
                          },
                          child: Text(
                            "+ ${AppLocalizations.of(context)!.add_another_time}",
                            style:
                                const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Divider(),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            color: Colors.orange,
            child: Text(AppLocalizations.of(context)!.confirm_operation_hour),
            textColor: Colors.white,
            onPressed: () async {
              await context.read<LoadingProvider>().setIsLoading(true);

              List<Map<String, dynamic>> jsonBody = [];
              List<OperationHourGroup> operationHourList =
                  context.read<MerchantProvider>().operationHourGroup;

              for (var i = 0; i < operationHourList.length; i++) {
                for (var j = 0; j < operationHourList[i].openCloseTime.length; j++) {
                  jsonBody.add({
                    "id": operationHourList[i].openCloseTime[j].id,
                    "day": operationHourList[i].day,
                    "opened_at":
                        DateFormat("HH:mm:ss").format(operationHourList[i].openCloseTime[j].openAt),
                    "closed_at": DateFormat("HH:mm:ss")
                        .format(operationHourList[i].openCloseTime[j].closedAt),
                    "is_delete": operationHourList[i].openCloseTime[j].isDelete
                  });
                }
              }

              bool isSuccess = await context.read<MerchantProvider>().updateOperationHour(jsonBody);
              await context.read<LoadingProvider>().setIsLoading(false);
              Fluttertoast.showToast(
                  msg: isSuccess
                      ? AppLocalizations.of(context)!.operation_hour_update_success
                      : AppLocalizations.of(context)!.update_fail,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white);

              if (isSuccess) {
                await context
                    .read<MerchantProvider>()
                    .getOperationHour(AppLocalizations.of(context)!);
                Navigator.of(context).pop();
              }
            },
          ),
        ),
      ),
    );
  }
}
