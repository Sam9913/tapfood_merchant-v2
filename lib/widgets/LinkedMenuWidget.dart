import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/model/MenuAddon.dart';
import 'package:tapfood_v2/provider/AddonProvider.dart';

class LinkedMenuWidget extends StatefulWidget {
  final int addonCategoryId;
  final MenuAddon menu;
  const LinkedMenuWidget({Key? key, required this.menu, required this.addonCategoryId})
      : super(key: key);

  @override
  _LinkedMenuWidgetState createState() => _LinkedMenuWidgetState();
}

class _LinkedMenuWidgetState extends State<LinkedMenuWidget> with TickerProviderStateMixin {
  bool isOpen = false;
  late AnimationController _animationController;

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
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            title: Text(
              "${widget.menu.name}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("${widget.menu.totalLinkedCount} ${AppLocalizations.of(context)!.items}"),
            trailing: RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
              child: IconButton(
                icon: const Icon(Icons.keyboard_arrow_down),
                onPressed: () async {
                  setState(() {
                    if (isOpen) {
                      _animationController.reverse(from: 0.5);
                    } else {
                      _animationController.forward(from: 0.0);
                    }
                    isOpen = !isOpen;
                  });
                },
              ),
            ),
          ),
          Offstage(
              offstage: !isOpen,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.menu.menuItems?.length,
                  itemBuilder: (context, index) {
                    int? lastIndex = widget.menu.menuItems?.length;

                    return Column(
                      children: [
                        ListTile(
                          title: Text("${widget.menu.menuItems?[index].name}"),
                          trailing: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: InkWell(
                                onTap: () async {
                                  if ((widget.menu.menuItems?[index].linkedCount ?? 0) >= 1) {
                                    bool isSuccess = await context.read<AddonProvider>().removeLink(
                                        int.parse("${widget.menu.menuItems?[index].menuItemId}"),
                                        widget.addonCategoryId);

                                    if (isSuccess) {
                                      setState(() {
                                        widget.menu.menuItems?[index].linkedCount = 0;
                                        widget.menu.totalLinkedCount =
                                            (widget.menu.totalLinkedCount ?? 0) - 1;
                                      });
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: AppLocalizations.of(context)!.update_fail,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.black,
                                          textColor: Colors.white);
                                    }
                                  } else {
                                    bool isSuccess = await context.read<AddonProvider>().link(
                                        int.parse("${widget.menu.menuItems?[index].menuItemId}"),
                                        widget.addonCategoryId);

                                    if (isSuccess) {
                                      setState(() {
                                        widget.menu.menuItems?[index].linkedCount = 1;
                                        widget.menu.totalLinkedCount =
                                            (widget.menu.totalLinkedCount ?? 0) + 1;
                                      });
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: AppLocalizations.of(context)!.update_fail,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.black,
                                          textColor: Colors.white);
                                    }
                                  }
                                },
                                child: (widget.menu.menuItems?[index].linkedCount ?? 0) >= 1
                                    ? Text(
                                        AppLocalizations.of(context)!.remove_link,
                                        style: const TextStyle(
                                            color: Colors.redAccent, fontWeight: FontWeight.bold),
                                      )
                                    : Text(
                                        AppLocalizations.of(context)!.link,
                                        style: const TextStyle(
                                            color: Colors.orange, fontWeight: FontWeight.bold),
                                      )),
                          ),
                          subtitle: Text("RM ${widget.menu.menuItems?[index].price}"),
                        ),
                        Offstage(
                          offstage: index == (lastIndex ?? 1) - 1,
                          child: const Divider(),
                        )
                      ],
                    );
                  },
                ),
              )),
          const Divider(),
        ],
      ),
    );
  }
}
