import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/model/General.dart';
import 'package:tapfood_v2/model/OperationHourException.dart';
import 'package:tapfood_v2/provider/ControlProvider.dart';
import 'package:tapfood_v2/provider/MerchantProvider.dart';
import 'package:tapfood_v2/widgets/LoadingScreen.dart';
import 'package:tapfood_v2/widgets/SingleDatePicker.dart';
import 'package:tapfood_v2/widgets/TimePicker.dart';

class SpecialHourSetting extends StatefulWidget {
  final String? specialHourDate;
  const SpecialHourSetting({Key? key, this.specialHourDate}) : super(key: key);

  @override
  State<SpecialHourSetting> createState() => _SpecialHourSettingState();
}

class _SpecialHourSettingState extends State<SpecialHourSetting> {
  bool isTf = true;
  DateTime date = DateTime.now();

  @override
  void initState() {
    stopLoading();
    if (widget.specialHourDate != null) {
      getSpecific();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.specialHourDate != null
              ? AppLocalizations.of(context)!.edit_special_hour
              : AppLocalizations.of(context)!.add_special_hour),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.orange,
              size: 20,
            ),
            onPressed: () {
              context.read<DateTimeProvider>().resetDateTimeList(true);
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Consumer<LoadingProvider>(
          builder: (context, LoadingProvider loadingProvider, child) {
            return loadingProvider.isLoading
                ? const LoadingScreen()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalizations.of(context)!.special_hour_date),
                                SingleDatePicker(date: date)
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppLocalizations.of(context)!.availability),
                                  Row(
                                    children: [
                                      Switch(
                                        value: isTf,
                                        activeColor: Colors.orange,
                                        onChanged: (bool value) {
                                          setState(() {
                                            isTf = value;
                                          });
                                        },
                                      ),
                                      Text(AppLocalizations.of(context)!.all_day)
                                    ],
                                  ),
                                  Offstage(
                                    offstage: isTf,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          context.read<DateTimeProvider>().addDateTimeList(
                                              AppLocalizations.of(context)!.cover_most,
                                              AppLocalizations.of(context)!.illogic_operation_add);
                                        },
                                        child: Text(
                                          "+ ${AppLocalizations.of(context)!.add_another_time}",
                                          style: const TextStyle(
                                              color: Colors.orange, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Consumer<DateTimeProvider>(
                                    builder: (context, DateTimeProvider dateTimeProvider, child) {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: dateTimeProvider.dateTimeList.length,
                                        itemBuilder: (context, index) {
                                          return Offstage(
                                            offstage: dateTimeProvider.dateTimeList[index].isDelete,
                                            child: TimePicker(
                                              openCloseTime: dateTimeProvider.dateTimeList[index],
                                              index: index,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Offstage(
                          offstage: widget.specialHourDate == null,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: MaterialButton(
                              minWidth: MediaQuery.of(context).size.width,
                              color: Colors.red,
                              child: Text(AppLocalizations.of(context)!.delete),
                              textColor: Colors.white,
                              onPressed: () async {
                                DateTime date = context.read<DateTimeProvider>().singleDate;
                                await context.read<LoadingProvider>().setIsLoading(true);

                                bool isSuccess = await context
                                    .read<MerchantProvider>()
                                    .deleteOperationHourException(
                                        DateFormat("yyyy-MM-dd").format(date));

                                Fluttertoast.showToast(
                                    msg: isSuccess
                                        ? AppLocalizations.of(context)!
                                            .special_hour_delete_success
                                            .replaceAll("[###Date###]",
                                                DateFormat("dd-MM-yyyy").format(date))
                                        : AppLocalizations.of(context)!.delete_fail,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white);

                                await context.read<LoadingProvider>().setIsLoading(false);
                                if (isSuccess) {
                                  await context
                                      .read<MerchantProvider>()
                                      .getSpecialHourOperationGrouped();
                                  context.read<DateTimeProvider>().resetDateTimeList(true);
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ),
        bottomNavigationBar: Consumer<LoadingProvider>(
          builder: (context, LoadingProvider loadingProvider, child) {
            return Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  color: loadingProvider.isLoading ? Colors.white : Colors.orange,
                  child: loadingProvider.isLoading
                      ? const Text("")
                      : widget.specialHourDate == null
                          ? Text(AppLocalizations.of(context)!.confirm_special_hour)
                          : Text(AppLocalizations.of(context)!.edit_special_hour),
                  textColor: Colors.white,
                  onPressed: () async {
                    DateTime date = context.read<DateTimeProvider>().singleDate;
                    //await context.read<LoadingProvider>().setIsLoading(true);

                    List<Map<String, dynamic>> jsonBody = [];

                    if (isTf) {
                      jsonBody.add({
                        "date": DateFormat("yyyy-MM-dd").format(date),
                        "openAt": null,
                        "closeAt": null
                      });
                    } else {
                      List<OpenCloseTime> openCloseTimeList =
                          context.read<DateTimeProvider>().dateTimeList;
                      for (var i = 0; i < openCloseTimeList.length; i++) {
                        jsonBody.add({
                          "date": DateFormat("yyyy-MM-dd").format(date),
                          "openAt": DateFormat("HH:mm:ss").format(openCloseTimeList[i].openAt),
                          "closeAt": DateFormat("HH:mm:ss").format(openCloseTimeList[i].closedAt)
                        });
                      }
                    }

                    bool isSuccess = await context
                        .read<MerchantProvider>()
                        .insertUpdateOperationHourException(jsonBody);
                    await context.read<LoadingProvider>().setIsLoading(false);
                    Fluttertoast.showToast(
                        msg: widget.specialHourDate == null
                            ? (isSuccess
                                ? AppLocalizations.of(context)!
                                    .special_hour_insert_success
                                    .replaceAll(
                                        "[###Date###]", DateFormat("yyyy-MM-dd").format(date))
                                : AppLocalizations.of(context)!.insert_fail)
                            : (isSuccess
                                ? AppLocalizations.of(context)!
                                    .special_hour_update_success
                                    .replaceAll(
                                        "[###Date###]", DateFormat("yyyy-MM-dd").format(date))
                                : AppLocalizations.of(context)!.update_fail),
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white);

                    if (isSuccess) {
                      await context.read<MerchantProvider>().getSpecialHourOperationGrouped();
                      context.read<DateTimeProvider>().resetDateTimeList(true);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            );
          },
        ));
  }

  getSpecific() async {
    SpecialHourGrouped specialHourGrouped = context
        .read<MerchantProvider>()
        .specialHourGrouped
        .firstWhere((element) => element.date == widget.specialHourDate);

    setState(() {
      date = DateTime.parse("${widget.specialHourDate}");
      isTf = specialHourGrouped.time.isEmpty ? true : false;
    });

    if (isTf) {
      context.read<DateTimeProvider>().resetDateTimeList(false);
    } else {
      List<OpenCloseTime> openCloseTimeList = [];
      List<OperationHourException> operationHourExceptionList =
          context.read<MerchantProvider>().operationHourException;

      for (int i = 0; i < operationHourExceptionList.length; i++) {
        openCloseTimeList.add(OpenCloseTime(
          isDelete: false,
          id: int.parse(operationHourExceptionList[i].id.toString()),
          openAt: DateFormat("hh:mm:ss").parse(operationHourExceptionList[i].openedAt.toString()),
          closedAt: DateFormat("hh:mm:ss").parse(operationHourExceptionList[i].closedAt.toString()),
        ));
      }

      context.read<DateTimeProvider>().setList(openCloseTimeList);
    }
  }

  stopLoading() async {
    await context.read<LoadingProvider>().setIsLoading(false);
  }
}
