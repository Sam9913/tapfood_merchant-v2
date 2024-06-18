import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/config/enum.dart';
import 'package:tapfood_v2/model/MenuItem.dart' as model;
import 'package:tapfood_v2/provider/ControlProvider.dart';
import 'package:tapfood_v2/provider/MenuProvider.dart';
import 'package:tapfood_v2/screen/Menu/MenuDetailPage.dart';

class MenuItemList extends StatefulWidget {
  final List<model.MenuItem> menuItemList;
  const MenuItemList({Key? key, required this.menuItemList}) : super(key: key);

  @override
  _MenuItemListState createState() => _MenuItemListState();
}

class _MenuItemListState extends State<MenuItemList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.menuItemList.length,
      itemBuilder: (context, index) {
        return ListTile(
          /*leading: CircleAvatar(
              backgroundColor: Colors.orange,
              backgroundImage: NetworkImage(
                  widget.menuItemList[index].menuItemImage == null
                      ? "https://i.stack.imgur.com/ndffg.jpg"
                      : Config().imageUrl +
                          "${widget.menuItemList[index].menuItemImage}")),*/
          title: Text("${widget.menuItemList[index].name}"),
          subtitle: Text("RM ${widget.menuItemList[index].price}"),
          trailing: Switch(
            value: widget.menuItemList[index].availability == 0 ? false : true,
            onChanged: (bool value) async {
              bool isSuccess = await context.read<MenuProvider>().updateMenuItemStatus(
                  value ? 1 : 0, int.parse(widget.menuItemList[index].menuItemId.toString()));

              if (isSuccess) {
                setState(() {
                  widget.menuItemList[index].availability = value ? 1 : 0;
                });
              }
            },
            activeColor: Colors.orange,
          ),
          onTap: () async {
            int menuItemId = int.parse(widget.menuItemList[index].menuItemId.toString());
            await context.read<MenuProvider>().getMenuItemById(menuItemId);

            context.read<AvailabilityProvider>().setAvailability(
                widget.menuItemList[index].availability == 0
                    ? Availability.unavailable
                    : Availability.available);

            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MenuDetailPage(
                      menuItemId: menuItemId,
                    )));
          },
        );
      },
    );
  }
}
