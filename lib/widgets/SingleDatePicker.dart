import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/provider/ControlProvider.dart';

class SingleDatePicker extends StatefulWidget {
  final DateTime date;
  const SingleDatePicker({Key? key, required this.date}) : super(key: key);

  @override
  _SingleDatePickerState createState() => _SingleDatePickerState();
}

class _SingleDatePickerState extends State<SingleDatePicker> {
  @override
  void initState() {
    context.read<DateTimeProvider>().setDate(widget.date, false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Consumer<DateTimeProvider>(
        builder: (context, DateTimeProvider dateTimeProvider, child){
          return Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(8.0)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: InkWell(
                onTap: () {
                  showPickerDateTime(context, dateTimeProvider.singleDate);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    DateFormat("dd-MM-yyyy").format(dateTimeProvider.singleDate),
                    style: const TextStyle(color: Colors.orange),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  showPickerDateTime(BuildContext context, DateTime date) {
    Picker(
        adapter: DateTimePickerAdapter(
            type: PickerDateTimeType.kMDY,
            minValue: DateTime.now(),
            value: date),
        textAlign: TextAlign.right,
        selectedTextStyle: const TextStyle(color: Colors.orange),
        onConfirm: (Picker picker, List value) {
          Provider.of<DateTimeProvider>(context, listen: false)
              .setDate(DateTime.parse(picker.adapter.toString()), true);
          setState(() {
            date = DateTime.parse(picker.adapter.toString());
          });
        },
        onSelect: (Picker picker, int index, List<int> selected) {
          Provider.of<DateTimeProvider>(context, listen: false)
              .setDate(DateTime.parse(picker.adapter.toString()), true);
          setState(() {
            date = DateTime.parse(picker.adapter.toString());
          });
        }).showModal(context);
  }
}
