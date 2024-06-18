 import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/config/enum.dart';
import 'package:tapfood_v2/function/ChangeFocus.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/model/Addon.dart';
import 'package:tapfood_v2/model/AddonCategory.dart';
import 'package:tapfood_v2/provider/AddonProvider.dart';
import 'package:tapfood_v2/provider/ControlProvider.dart';
import 'package:tapfood_v2/services/PusherServices.dart';
import 'package:tapfood_v2/widgets/AvailabilityField.dart';
import 'package:tapfood_v2/widgets/LoadingScreen.dart';

class AddonItemPage extends StatefulWidget {
  const AddonItemPage({Key? key}) : super(key: key);

  @override
  _AddonItemPageState createState() => _AddonItemPageState();
}

class _AddonItemPageState extends State<AddonItemPage> {
  int categoryId = 0;
  int? addonId;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _priceFocus = FocusNode();
  List<AddonCategory> addonCategoryList = [];

  @override
  void initState() {
    getAddonCategory();
    getAddonItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${addonId == null ? AppLocalizations.of(context)!.add_a : AppLocalizations.of(context)!.edit} ${AppLocalizations.of(context)!.addon_item}"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.orange,
            size: 20,
          ),
          onPressed: () {
            context.read<AddonProvider>().setEmptyAddon();
            Navigator.of(context).pop();
          },
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
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          ),
                          onEditingComplete: () {
                            ChangeFocus().fieldFocusChange(context, _nameFocus, _priceFocus);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text("${AppLocalizations.of(context)!.price} *"),
                        ),
                        TextField(
                          controller: _priceController,
                          focusNode: _priceFocus,
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true, signed: false),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                          ],
                          decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange, width: 1.0),
                            ),
                            hintText: "0.00",
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          ),
                          onEditingComplete: () {
                            _priceFocus.unfocus();
                          },
                        ),
                        const AvailabilityField(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text("${AppLocalizations.of(context)!.category} *"),
                        ),
                        DropdownButtonFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          items: addonCategoryList
                              .map((label) => DropdownMenuItem(
                                    child: Text(label.name.toString()),
                                    value: int.parse(label.id.toString()),
                                  ))
                              .toList(),
                          value: categoryId,
                          onChanged: (int? value) {
                            setState(() {
                              categoryId = value!;
                            });
                          },
                        ),
                        Offstage(
                          offstage: addonId == null,
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
                                    await context.read<AddonProvider>().deleteAddon(addonId!);

                                Fluttertoast.showToast(
                                    msg: isSuccess
                                        ? AppLocalizations.of(context)!
                                            .addon_delete_success
                                            .replaceAll("[###Name###]", _nameController.text)
                                        : AppLocalizations.of(context)!
                                            .delete_fail,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white);

                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ));
        },
      ),
      bottomNavigationBar:
          Consumer<LoadingProvider>(builder: (context, LoadingProvider loadingProvider, child) {
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
                bool isSuccess;

                if (addonId == null) {
                  isSuccess = await context.read<AddonProvider>().insertAddon(
                      _nameController.text,
                      _priceController.text,
                      availability == Availability.available ? true : false,
                      categoryId);
                } else {
                  isSuccess = await context.read<AddonProvider>().updateAddon(
                      int.parse(addonId.toString()),
                      _nameController.text,
                      _priceController.text,
                      availability == Availability.available ? true : false,
                      categoryId);
                }
                await context.read<LoadingProvider>().setIsLoading(false);

                Fluttertoast.showToast(
                    msg: addonId == null
                        ? (isSuccess
                            ? AppLocalizations.of(context)!
                                .addon_insert_success
                                .replaceAll("[###Name###]", _nameController.text)
                            : AppLocalizations.of(context)!.insert_fail)
                        : (isSuccess
                            ? AppLocalizations.of(context)!
                                .addon_update_success
                                .replaceAll("[###Name###]", _nameController.text)
                            : AppLocalizations.of(context)!.update_fail),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white);

                Navigator.of(context).pop();
              },
            ),
          ),
        );
      }),
    );
  }

  getAddonItem() {
    Addon _addon = Provider.of<AddonProvider>(context, listen: false).addon;

    if (_addon.addonId != null) {
      setState(() {
        addonId = _addon.addonId;
        _nameController.text = _addon.name.toString();
        _priceController.text = _addon.price.toString();
        categoryId = int.parse(_addon.addonCategoryId.toString());
      });
    }
  }

  getAddonCategory() {
    
    List<AddonCategory> _addonCategoryList =
        Provider.of<AddonProvider>(context, listen: false).dropDownCategoryList;

    setState(() {
      addonCategoryList = _addonCategoryList;
      if (categoryId == 0 && _addonCategoryList.isNotEmpty) {
        categoryId = int.parse(_addonCategoryList[0].id.toString());
      }
    });
  }
}
