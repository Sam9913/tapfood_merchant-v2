import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/provider/AddonProvider.dart';
import 'package:tapfood_v2/provider/MenuProvider.dart';
import 'package:tapfood_v2/services/PusherServices.dart';
import 'package:tapfood_v2/widgets/LinkedMenuWidget.dart';
import 'package:tapfood_v2/widgets/LoadingScreen.dart';

class LinkedMenuList extends StatefulWidget {
  final int addonCategoryId;
  const LinkedMenuList({Key? key, required this.addonCategoryId})
      : super(key: key);

  @override
  State<LinkedMenuList> createState() => _LinkedMenuListState();
}

class _LinkedMenuListState extends State<LinkedMenuList> {
  bool isLoading = true;

  @override
  void initState() {
    getAllMenu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.edit_linked_menu),
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
      body: isLoading
          ? const LoadingScreen()
          : Consumer<AddonProvider>(
              builder: (context, AddonProvider addonProvider, child) {
              return ListView.builder(
                itemCount: addonProvider.menuAddonList.length,
                itemBuilder: (context, index) {
                  return LinkedMenuWidget(
                    menu: addonProvider.menuAddonList[index],
                    addonCategoryId: widget.addonCategoryId,
                  );
                },
              );
            }),
    );
  }

  getAllMenu() async {
    bool tempIsLoading = await context
        .read<AddonProvider>()
        .getLinkedMenu(widget.addonCategoryId);

    setState(() {
      isLoading = !tempIsLoading;
    });
  }
}
