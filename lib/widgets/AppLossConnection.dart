import 'package:flutter/material.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';

class AppLossConnection extends StatelessWidget {
  const AppLossConnection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "images/logo.png",
              width: MediaQuery.of(context).size.width * 0.7,
            ),
            const CircularProgressIndicator(
              color: Colors.orange,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5), borderRadius: BorderRadius.circular(8.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.warning_amber_rounded),
                        Text(AppLocalizations.of(context)!.internet_not_found),
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
