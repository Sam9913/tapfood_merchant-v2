import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/config/enum.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/model/Menu.dart';
import 'package:tapfood_v2/model/MenuItem.dart' as model;
import 'package:tapfood_v2/provider/ControlProvider.dart';
import 'package:tapfood_v2/provider/MenuProvider.dart';
import 'package:tapfood_v2/screen/Menu/MenuPage.dart';
import 'package:tapfood_v2/widgets/LoadingScreen.dart';
import 'package:tapfood_v2/widgets/MenuItemList.dart';

class MenuItemWidget extends StatefulWidget {
  final Menu menu;
  const MenuItemWidget({Key? key, required this.menu}) : super(key: key);

  @override
  _MenuItemWidgetState createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<MenuItemWidget> with TickerProviderStateMixin {
  bool isOpen = false;
  bool isLoading = true;
  late List<model.MenuItem> _menuItemList = [];
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
              onTap: (){
                context.read<AvailabilityProvider>().setAvailability(
                    widget.menu.status == 0
                        ? Availability.unavailable
                        : Availability.available);

                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MenuPage(menu: widget.menu,)));
              },
              title: Text(
                "${widget.menu.name}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("${widget.menu.itemCount} ${AppLocalizations.of(context)!.items}"),
              trailing: Offstage(
                offstage: widget.menu.itemCount == 0,
                child: RotationTransition(
                  turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
                  child: IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down),
                    onPressed: () async{
                      setState(() {
                        isLoading = true;

                        if (isOpen) {
                          _animationController.reverse(from: 0.5);
                        } else {
                          _animationController.forward(from: 0.0);
                        }
                        isOpen = !isOpen;
                      });

                      if(isOpen){
                        await getMenuItem();
                      }

                    },
                  ),
                ),
              ),
            ),
            Offstage(
                offstage: !isOpen,
                child: isLoading ? const SizedBox(
                  height: 50,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  ),
                ) : MenuItemList(menuItemList: _menuItemList))
          ],
        ),
      ),
    );
  }

  getMenuItem() async{
    final menuItemList = await context.read<MenuProvider>().getByMenuId(widget.menu.menuId);
    setState(() {
      _menuItemList = menuItemList;
      isLoading = false;
    });
  }
}
