import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/config/enum.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/provider/ControlProvider.dart';

class MenuCategoryField extends StatefulWidget {
  const MenuCategoryField({Key? key}) : super(key: key);

  @override
  _MenuCategoryFieldState createState() => _MenuCategoryFieldState();
}

class _MenuCategoryFieldState extends State<MenuCategoryField> {
  @override
  Widget build(BuildContext context) {
    final MenuCategory menuCategory = Provider.of<MenuCategoryProvider>(context).menuCategory;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text("${AppLocalizations.of(context)!.type} *"),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0), border: Border.all(color: Colors.grey)),
          child: Row(
            children: [
              Radio(
                activeColor: Colors.orange,
                groupValue: menuCategory,
                onChanged: (_) {
                  setState(() {
                    Provider.of<MenuCategoryProvider>(context, listen: false)
                        .setMenuCategory(MenuCategory.food);
                  });
                },
                value: MenuCategory.food,
              ),
              Text(AppLocalizations.of(context)!.food),
              Radio(
                activeColor: Colors.orange,
                groupValue: menuCategory,
                onChanged: (_) {
                  setState(() {
                    Provider.of<MenuCategoryProvider>(context, listen: false)
                        .setMenuCategory(MenuCategory.beverage);
                  });
                },
                value: MenuCategory.beverage,
              ),
              Text(AppLocalizations.of(context)!.beverage),
            ],
          ),
        ),
      ],
    );
  }
}
