import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/model/Menu.dart';
import 'package:tapfood_v2/provider/MenuProvider.dart';
import 'package:tapfood_v2/widgets/EmptyScreen.dart';
import 'package:tapfood_v2/widgets/MenuItemWidget.dart';

class MenuList extends StatefulWidget {
  const MenuList({Key? key}) : super(key: key);

  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  bool isPressAvailable = false;
  bool isPressUnavailable = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
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
                        color: isPressAvailable ? Colors.orange : Colors.white, width: 2.0)),
                child: Text(
                  AppLocalizations.of(context)!.available,
                  style: TextStyle(color: isPressAvailable ? Colors.orange : Colors.black54),
                ),
                onPressed: () {
                  setState(() {
                    isPressUnavailable = false;
                    isPressAvailable = true;
                  });
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
                        color: isPressUnavailable ? Colors.orange : Colors.white, width: 2.0)),
                child: Text(
                  AppLocalizations.of(context)!.unavailable,
                  style: TextStyle(color: isPressUnavailable ? Colors.orange : Colors.black54),
                ),
                onPressed: () {
                  setState(() {
                    isPressUnavailable = true;
                    isPressAvailable = false;
                  });
                },
              )
            ],
          ),
        ), //need do sticky
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Consumer<MenuProvider>(
            builder: (context, MenuProvider menuProvider, child) {
              return (isPressAvailable
                          ? menuProvider.activeMenuList.length
                          : isPressUnavailable
                              ? menuProvider.inactiveMenuList.length
                              : menuProvider.menuList.length) ==
                      0
                  ? EmptyScreen(
                      content: AppLocalizations.of(context)!.no_menu,
                      imageUrl: "images/undraw_Blank_canvas_re_2hwy.png",
                      height: 0.64,
                    )
                  : ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: isPressAvailable
                          ? menuProvider.activeMenuList.length
                          : isPressUnavailable
                              ? menuProvider.inactiveMenuList.length
                              : menuProvider.menuList.length,
                      itemBuilder: (context, index) {
                        List<Menu> menuList = [];

                        if (isPressAvailable) {
                          menuList = menuProvider.activeMenuList;
                        } else if (isPressUnavailable) {
                          menuList = menuProvider.inactiveMenuList;
                        } else {
                          menuList = menuProvider.menuList;
                        }

                        return MenuItemWidget(menu: menuList[index]);
                      },
                    );
            },
          ),
        ),
      ],
    );
  }
}
