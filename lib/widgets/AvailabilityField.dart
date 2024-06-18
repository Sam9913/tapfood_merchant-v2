import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/config/enum.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/provider/ControlProvider.dart';

class AvailabilityField extends StatefulWidget {
  const AvailabilityField({Key? key}) : super(key: key);

  @override
  _AvailabilityFieldState createState() => _AvailabilityFieldState();
}

class _AvailabilityFieldState extends State<AvailabilityField> {
  @override
  Widget build(BuildContext context) {
    final Availability availability = Provider.of<AvailabilityProvider>(context).availability;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text("${AppLocalizations.of(context)!.availability} *"),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0), border: Border.all(color: Colors.grey)),
          child: Row(
            children: [
              Radio(
                activeColor: Colors.orange,
                groupValue: availability,
                onChanged: (_) {
                  setState(() {
                    Provider.of<AvailabilityProvider>(context, listen: false)
                        .setAvailability(Availability.available);
                  });
                },
                value: Availability.available,
              ),
              Text(AppLocalizations.of(context)!.available),
              Radio(
                activeColor: Colors.orange,
                groupValue: availability,
                onChanged: (_) {
                  setState(() {
                    Provider.of<AvailabilityProvider>(context, listen: false)
                        .setAvailability(Availability.unavailable);
                  });
                },
                value: Availability.unavailable,
              ),
              Text(AppLocalizations.of(context)!.unavailable),
            ],
          ),
        ),
      ],
    );
  }
}
