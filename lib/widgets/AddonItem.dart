import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/config/enum.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/model/Addon.dart';
import 'package:tapfood_v2/model/AddonCategory.dart';
import 'package:tapfood_v2/provider/AddonProvider.dart';
import 'package:tapfood_v2/provider/ControlProvider.dart';
import 'package:tapfood_v2/screen/Addon/AddonItemPage.dart';
import 'package:tapfood_v2/screen/Addon/AddonPage.dart';

class AddonItem extends StatefulWidget {
  final AddonCategory addonItem;
  const AddonItem({Key? key, required this.addonItem}) : super(key: key);

  @override
  _AddonItemState createState() => _AddonItemState();
}

class _AddonItemState extends State<AddonItem> with TickerProviderStateMixin {
  bool isOpen = false;
  bool isLoading = true;
  late AnimationController _animationController;
  late List<Addon> _addonList = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      upperBound: 0.5,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Material(
        shadowColor: Colors.grey,
        elevation: 2,
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        child: Column(
          children: [
            ListTile(
              onTap: () {
                context.read<AvailabilityProvider>().setAvailability(widget.addonItem.status == 0
                    ? Availability.unavailable
                    : Availability.available);

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddonPage(
                          addonCategory: widget.addonItem,
                        )));
              },
              title: Text(
                "${widget.addonItem.name}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Text(
                          "${widget.addonItem.itemCount} ${AppLocalizations.of(context)!.items}",
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        )),
                    Expanded(
                      flex: 2,
                      child: Offstage(
                        offstage: widget.addonItem.itemCount == 0,
                        child: RotationTransition(
                          turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
                          child: IconButton(
                            icon: const Icon(Icons.keyboard_arrow_down),
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                                if (isOpen) {
                                  _animationController.reverse(from: 0.5);
                                } else {
                                  _animationController.forward(from: 0.0);
                                }
                                isOpen = !isOpen;
                              });

                              if (isOpen) {
                                await getAddonList();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Offstage(
              offstage: !isOpen,
              child: isLoading
                  ? const SizedBox(
                      height: 50,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          color: Colors.orange,
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _addonList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text("${_addonList[index].name}"),
                          subtitle: Text("RM ${_addonList[index].price}"),
                          trailing: Switch(
                            onChanged: (bool value) async {
                              await context.read<AddonProvider>().updateAddonAvailability(
                                  value ? 1 : 0, int.parse(_addonList[index].addonId.toString()));

                              setState(() {
                                _addonList[index].status = value ? 1 : 0;
                              });
                            },
                            value: _addonList[index].status == 0 ? false : true,
                            activeColor: Colors.orange,
                          ),
                          onTap: () async {
                            await context
                                .read<AddonProvider>()
                                .getById(int.parse(_addonList[index].addonId.toString()));

                            context.read<AvailabilityProvider>().setAvailability(
                                _addonList[index].status == 0
                                    ? Availability.unavailable
                                    : Availability.available);

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AddonItemPage()),
                            );
                          },
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }

  getAddonList() async {
    final addonList = await context
        .read<AddonProvider>()
        .getByCategory(int.parse(widget.addonItem.id.toString()));
    setState(() {
      _addonList = addonList;
      isLoading = false;
    });
  }
}
