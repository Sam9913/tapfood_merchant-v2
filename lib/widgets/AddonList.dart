import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/model/AddonCategory.dart';
import 'package:tapfood_v2/provider/AddonProvider.dart';
import 'package:tapfood_v2/widgets/AddonItem.dart';
import 'package:tapfood_v2/widgets/EmptyScreen.dart';
import 'package:tapfood_v2/widgets/LoadingScreen.dart';

class AddonList extends StatefulWidget {
  const AddonList({Key? key}) : super(key: key);

  @override
  _AddonListState createState() => _AddonListState();
}

class _AddonListState extends State<AddonList> {
  bool isPressAvailable = false;
  bool isPressUnavailable = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    MaterialButton(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          side: BorderSide(
                              color: isPressAvailable
                                  ? Colors.orange
                                  : Colors.white,
                              width: 2.0)),
                      child: Text(
                        AppLocalizations.of(context)!.available,
                        style: TextStyle(
                            color: isPressAvailable
                                ? Colors.orange
                                : Colors.black54),
                      ),
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                          isPressUnavailable = false;
                          isPressAvailable = true;
                        });

                        Timer(
                            const Duration(milliseconds: 500),
                            () => setState(() {
                                  isLoading = false;
                                }));
                      },
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    MaterialButton(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          side: BorderSide(
                              color: isPressUnavailable
                                  ? Colors.orange
                                  : Colors.white,
                              width: 2.0)),
                      child: Text(
                        AppLocalizations.of(context)!.unavailable,
                        style: TextStyle(
                            color: isPressUnavailable
                                ? Colors.orange
                                : Colors.black54),
                      ),
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                          isPressUnavailable = true;
                          isPressAvailable = false;
                        });

                        Timer(
                            const Duration(milliseconds: 500),
                                () => setState(() {
                              isLoading = false;
                            }));
                      },
                    )
                  ],
                ),
              ),
              isLoading
                  ? const LoadingScreen(isCut: true)
                  : Consumer<AddonProvider>(
                      builder: (context, AddonProvider addonProvider, child) {
                        return (isPressAvailable
                                    ? addonProvider.activeAddonCategory.length
                                    : isPressUnavailable
                                        ? addonProvider
                                            .inactiveAddonCategory.length
                                        : addonProvider
                                            .addonCategoryList.length) ==
                                0
                            ? EmptyScreen(
                                content: AppLocalizations.of(context)!.no_addon,
                                imageUrl:
                                    "images/undraw_Blank_canvas_re_2hwy.png",
                                height: 0.64,
                              )
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: isPressAvailable
                                    ? addonProvider.activeAddonCategory.length
                                    : isPressUnavailable
                                        ? addonProvider
                                            .inactiveAddonCategory.length
                                        : addonProvider
                                            .addonCategoryList.length,
                                itemBuilder: (context, index) {
                                  List<AddonCategory> addonCategoryList = [];

                                  if (isPressAvailable) {
                                    addonCategoryList =
                                        addonProvider.activeAddonCategory;
                                  } else if (isPressUnavailable) {
                                    addonCategoryList =
                                        addonProvider.inactiveAddonCategory;
                                  } else {
                                    addonCategoryList =
                                        addonProvider.addonCategoryList;
                                  }

                                  return AddonItem(
                                      addonItem: addonCategoryList[index]);
                                });
                      },
                    ),
            ],
          )),
    );
  }
}
