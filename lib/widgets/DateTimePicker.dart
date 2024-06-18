import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/provider/ControlProvider.dart';
import 'package:tapfood_v2/provider/ReportProvider.dart';

class DateTimePicker extends StatefulWidget {
  final bool isStart;
  const DateTimePicker({Key? key, required this.isStart}) : super(key: key);

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  @override
  Widget build(BuildContext context) {
    final String date = widget.isStart
        ? DateFormat("yyyy-MM-dd")
            .format(Provider.of<DateTimeProvider>(context).startDateTime)
        : DateFormat("yyyy-MM-dd")
            .format(Provider.of<DateTimeProvider>(context).endDateTime);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.orange, width: 1),
            borderRadius: BorderRadius.circular(8.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: InkWell(
            onTap: () {
              showPickerDateTime(context, widget.isStart, DateTime.parse(date));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  date,
                  style: const TextStyle(color: Colors.orange),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.orange,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  showPickerDateTime(BuildContext context, bool isStartDate, DateTime date) {
    Picker(
        adapter: !widget.isStart
            ? DateTimePickerAdapter(
                type: PickerDateTimeType.kMDY,
                minValue: Provider.of<DateTimeProvider>(context, listen: false)
                    .startDateTime,
                maxValue: DateTime.now(),
                value: date)
            : DateTimePickerAdapter(
                type: PickerDateTimeType.kMDY,
                maxValue: DateTime.now(),
                value: date),
        textAlign: TextAlign.right,
        selectedTextStyle: const TextStyle(color: Colors.orange),
        onConfirm: (Picker picker, List value) {
          setState(() {
            if (isStartDate) {
              Provider.of<DateTimeProvider>(context, listen: false)
                  .setStartDate(DateTime.parse(picker.adapter.toString()));
            } else {
              Provider.of<DateTimeProvider>(context, listen: false)
                  .setEndDate(DateTime.parse(picker.adapter.toString()));
            }
            getReport();
          });
        },
        onSelect: (Picker picker, int index, List<int> selected) {
          /*setState(() {
            if (isStartDate) {
              Provider.of<DateTimeProvider>(context, listen: false)
                  .setStartDate(DateTime.parse(picker.adapter.toString()));
            } else {
              Provider.of<DateTimeProvider>(context, listen: false)
                  .setEndDate(DateTime.parse(picker.adapter.toString()));
            }
          });*/
        }).showModal(context);
  }

  getReport() async {
    await context.read<LoadingProvider>().setIsLoading(true);
    final startDate = DateFormat("yyyy-MM-dd")
        .format(context.read<DateTimeProvider>().startDateTime);
    final endDate = DateFormat("yyyy-MM-dd")
        .format(context.read<DateTimeProvider>().endDateTime);

    await context.read<ReportProvider>().getByDateRange(startDate, endDate);
    var reportList = context.read<ReportProvider>().reportList;
    await context.read<ReportSummaryProvider>().setTotalByList(reportList);
    await context.read<LoadingProvider>().setIsLoading(false);
  }
}
