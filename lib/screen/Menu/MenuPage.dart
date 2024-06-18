import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/config/enum.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/model/Menu.dart';
import 'package:tapfood_v2/provider/ControlProvider.dart';
import 'package:tapfood_v2/provider/MenuProvider.dart';
import 'package:tapfood_v2/widgets/AvailabilityField.dart';
import 'package:tapfood_v2/widgets/LoadingScreen.dart';

class MenuPage extends StatefulWidget {
  final Menu menu;
  const MenuPage({Key? key, required this.menu}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  int typeId = 0;
  late var menuId;

  @override
  void initState() {
    getMenuDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              "${menuId == 0 ? AppLocalizations.of(context)!.add_a : AppLocalizations.of(context)!.edit} ${AppLocalizations.of(context)!.menu}"),
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
        body: Consumer<LoadingProvider>(
          builder: (context, LoadingProvider loadingProvider, child) {
            return loadingProvider.isLoading
                ? const LoadingScreen()
                : Container(
                    color: Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text("${AppLocalizations.of(context)!.name} *"),
                            ),
                            TextField(
                              controller: _nameController,
                              focusNode: _nameFocus,
                              decoration: const InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange, width: 1.0),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                              ),
                              onEditingComplete: () {
                                _nameFocus.unfocus();
                              },
                            ),
                            const AvailabilityField(),
                            Offstage(
                              offstage: menuId == 0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: MaterialButton(
                                  minWidth: MediaQuery.of(context).size.width,
                                  color: Colors.red,
                                  child: Text(AppLocalizations.of(context)!.delete),
                                  textColor: Colors.white,
                                  onPressed: () async {
                                    await context.read<LoadingProvider>().setIsLoading(true);
                                    bool isSuccess =
                                        await context.read<MenuProvider>().deleteMenu(menuId!);

                                    Fluttertoast.showToast(
                                        msg: isSuccess
                                            ? AppLocalizations.of(context)!
                                                .menu_category_delete_success
                                                .replaceAll("[###Name###]", _nameController.text)
                                            : AppLocalizations.of(context)!.delete_fail,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.black,
                                        textColor: Colors.white);

                                    await context.read<LoadingProvider>().setIsLoading(false);
                                    if (isSuccess) {
                                      await context.read<MenuProvider>().getAll();
                                      Navigator.of(context).pop();
                                    }
                                  },
                                ),
                              ),
                            )
                          ],
                        )));
          },
        ),
        bottomNavigationBar: Consumer<LoadingProvider>(
          builder: (context, LoadingProvider loadingProvider, child) {
            return Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  color: loadingProvider.isLoading ? Colors.white : Colors.orange,
                  child: loadingProvider.isLoading
                      ? const Text("")
                      : Text(AppLocalizations.of(context)!.save),
                  textColor: Colors.white,
                  onPressed: () async {
                    await context.read<LoadingProvider>().setIsLoading(true);

                    final Availability availability =
                        Provider.of<AvailabilityProvider>(context, listen: false).availability;
                    bool isSuccess = false;

                    if (menuId == 0) {
                      isSuccess = await context.read<MenuProvider>().insertMenu(
                          _nameController.text,
                          availability == Availability.available ? true : false,
                          typeId);
                    } else {
                      isSuccess = await context.read<MenuProvider>().updateMenu(
                          _nameController.text,
                          availability == Availability.available ? true : false,
                          typeId,
                          int.parse(menuId.toString()));
                    }

                    Fluttertoast.showToast(
                        msg: menuId == 0
                            ? (isSuccess
                                ? AppLocalizations.of(context)!
                                    .menu_category_insert_success
                                    .replaceAll("[###Name###]", _nameController.text)
                                : AppLocalizations.of(context)!.insert_fail)
                            : (isSuccess
                                ? AppLocalizations.of(context)!
                                    .menu_category_update_success
                                    .replaceAll("[###Name###]", _nameController.text)
                                : AppLocalizations.of(context)!.update_fail),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white);

                    await context.read<LoadingProvider>().setIsLoading(false);
                    if(isSuccess){
                      await context.read<MenuProvider>().getAll();
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            );
          },
        ));
  }

  getMenuDetail() {
    
    setState(() {
      _nameController.text = widget.menu.menuId == 0 ? "" : widget.menu.name.toString();
      menuId = widget.menu.menuId;
      typeId = widget.menu.menuId == 0 ? 0 : int.parse(widget.menu.type.toString());
    });
  }
}
