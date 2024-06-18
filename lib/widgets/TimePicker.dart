import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/model/General.dart';
import 'package:tapfood_v2/provider/ControlProvider.dart';
import 'package:tapfood_v2/provider/MerchantProvider.dart';

class TimePicker extends StatefulWidget {
  final OpenCloseTime openCloseTime;
  final int index;
  final int? normalIndex;
  final int? secondaryIndex;
  const TimePicker(
      {Key? key,
      required this.openCloseTime,
      required this.index,
      this.normalIndex,
      this.secondaryIndex})
      : super(key: key);

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key(widget.openCloseTime.id.toString()),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.open_at),
                  InkWell(
                    onTap: () {
                      showPickerTime(context, widget.openCloseTime.openAt, true);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          DateFormat("hh:mm aa").format(widget.openCloseTime.openAt),
                          style: const TextStyle(fontSize: 16, color: Colors.black45),
                        ),
                        const Icon(Icons.keyboard_arrow_down, color: Colors.grey)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(" - "),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.close_at),
                  InkWell(
                    onTap: () {
                      showPickerTime(context, widget.openCloseTime.closedAt, false);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          DateFormat("hh:mm aa").format(widget.openCloseTime.closedAt),
                          style: const TextStyle(fontSize: 16, color: Colors.black45),
                        ),
                        const Icon(Icons.keyboard_arrow_down, color: Colors.grey)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  if (widget.index != -1) {
                    Provider.of<DateTimeProvider>(context, listen: false)
                        .removeDateTimeList(widget.index);
                  } else {
                    context
                        .read<MerchantProvider>()
                        .removeOpenCloseTime(widget.normalIndex ?? 0, widget.secondaryIndex ?? 0);
                  }
                },
                child: const Icon(
                  Icons.remove_circle_outline,
                  color: Colors.red,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  showPickerTime(BuildContext context, DateTime time, bool isOpen) {
    if (DateFormat("hh").format(time) == "00" || DateFormat("hh").format(time) == "12") {
      time = time.add(const Duration(hours: 12));
    }

    Picker(
            adapter: DateTimePickerAdapter(type: PickerDateTimeType.kHM_AP, value: time),
            textAlign: TextAlign.right,
            selectedTextStyle: const TextStyle(color: Colors.orange),
            onConfirm: (Picker picker, List value) {
              DateTime selectedDateTime = DateTime.parse(picker.adapter.toString());
              if (DateFormat("hh").format(selectedDateTime) == "12") {
                selectedDateTime = selectedDateTime.add(const Duration(hours: 12));
              }

              if (widget.index == -1) {
                Provider.of<MerchantProvider>(context, listen: false).setOpenCloseTime(
                    widget.openCloseTime.id,
                    isOpen,
                    selectedDateTime,
                    isOpen ? widget.openCloseTime.closedAt : widget.openCloseTime.openAt,
                    widget.normalIndex ?? 0,
                    widget.secondaryIndex ?? 0,
                    AppLocalizations.of(context)!.illogic_operation_edit);
              } else {
                Provider.of<DateTimeProvider>(context, listen: false).setOpenCloseTime(
                    widget.openCloseTime.id,
                    isOpen,
                    selectedDateTime,
                    widget.index,
                    AppLocalizations.of(context)!.illogic_operation_add);
              }
            },
            onSelect: (Picker picker, int index, List<int> selected) {
              /*if (widget.index == -1) {
            if (isOpen) {
              Provider.of<MerchantProvider>(context, listen: false)
                  .operationHourGroup[widget.normalIndex ?? 0]
                  .openCloseTime[widget.secondaryIndex ?? 0]
                  .openAt = DateTime.parse(picker.adapter.toString());
            } else {
              Provider.of<MerchantProvider>(context, listen: false)
                  .operationHourGroup[widget.normalIndex ?? 0]
                  .openCloseTime[widget.secondaryIndex ?? 0]
                  .closedAt = DateTime.parse(picker.adapter.toString());
            }
          } else {
            Provider.of<DateTimeProvider>(context, listen: false)
                .setOpenCloseTime(widget.openCloseTime.id, isOpen,
                    DateTime.parse(picker.adapter.toString()), widget.index);
          }*/
            })
        .showModal(context);
  }
}
