import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/screen/Order/TrackOrder.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonDetail extends StatefulWidget {
  final String contactNumber;
  final String tableNo;
  final String trackingUrl;
  final String personRole;
  final String personName;
  final int orderPreference;
  final String orderId;
  final DateTime orderTime;
  final int queueId;
  const PersonDetail(
      {Key? key,
      required this.contactNumber,
      required this.tableNo,
      required this.trackingUrl,
      required this.personRole,
      required this.personName,
      required this.orderPreference,
      required this.orderId,
      required this.orderTime,
      required this.queueId})
      : super(key: key);

  @override
  _PersonDetailState createState() => _PersonDetailState();
}

class _PersonDetailState extends State<PersonDetail> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.personRole,
            style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0,
                widget.personRole == AppLocalizations.of(context)!.rider ? 8.0 : 0.0),
            child: Row(
              children: [
                Expanded(flex: 5, child: Text(widget.personName)),
                Expanded(
                  flex: (widget.orderPreference == 0 &&
                          widget.personRole != AppLocalizations.of(context)!.rider)
                      ? 2
                      : 1,
                  child: widget.personRole == AppLocalizations.of(context)!.rider
                      ? InkWell(
                          child: const Icon(
                            Icons.location_on_outlined,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TrackOrder(
                                    orderId: widget.orderId, trackingUrl: widget.trackingUrl)));
                          },
                        )
                      : const Text(""),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    child: const Icon(
                      Icons.phone_outlined,
                      color: Colors.grey,
                    ),
                    onTap: () async {
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: widget.contactNumber,
                      );
                      await launchUrl(launchUri);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Offstage(
          offstage: widget.queueId == 0,
          child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 0.0),
                child: Text("${AppLocalizations.of(context)!.queue_no} : ${widget.queueId}"),
              )),
        ),
        Offstage(
          offstage: widget.personRole == AppLocalizations.of(context)!.rider,
          child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 0.0),
                child: Text(
                    "${AppLocalizations.of(context)!.order_time} : ${DateFormat("yyyy-MM-dd HH:mm a").format(widget.orderTime)}"),
              )),
        ),
        Offstage(
          offstage: widget.tableNo == "null",
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${AppLocalizations.of(context)!.table_no}: "),
                  Flexible(
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.orange, borderRadius: BorderRadius.circular(8.0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            widget.tableNo,
                            style: const TextStyle(color: Colors.white),
                            maxLines: 2,
                          ),
                        )),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
