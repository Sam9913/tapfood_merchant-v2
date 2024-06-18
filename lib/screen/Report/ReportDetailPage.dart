import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/provider/ControlProvider.dart';
import 'package:tapfood_v2/provider/ReportProvider.dart';
import 'package:tapfood_v2/widgets/OrderListItem.dart';
import 'package:tapfood_v2/widgets/StackLoadingScreen.dart';

class ReportDetailPage extends StatefulWidget {
  final String datetime;
  const ReportDetailPage({Key? key, required this.datetime}) : super(key: key);

  @override
  _ReportDetailPageState createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  bool isClickLoading = false;
  
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title:
                Text("${AppLocalizations.of(context)!.order_of} ${DateFormat("dd MMM yyyy").format(DateTime.parse(widget.datetime))}"),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.orange,
                size: 20,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
			body: Consumer<ReportProvider>(
              builder: (context, ReportProvider reportProvider, child) {
                return Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: ListView.builder(
                    itemCount: reportProvider.selectedOrderList.length,
                    itemBuilder: (context, index){
                      return OrderListItem(orderItem: reportProvider.selectedOrderList[index]);
                    },
                  ),
                );
              }
          ),
        ),
        Consumer<LoadingProvider>(
          builder: (context, LoadingProvider loadingProvider, child){
            return Offstage(offstage: !loadingProvider.isClickLoading, child: const StackLoadingScreen());
          },
        )
      ],
    );
  }
}
