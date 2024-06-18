import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/config/enum.dart';
import 'package:tapfood_v2/function/ChangeFocus.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/model/AddonCategory.dart';
import 'package:tapfood_v2/model/General.dart';
import 'package:tapfood_v2/provider/AddonProvider.dart';
import 'package:tapfood_v2/provider/ControlProvider.dart';
import 'package:tapfood_v2/screen/Addon/LinkedMenuList.dart';
import 'package:tapfood_v2/widgets/AvailabilityField.dart';
import 'package:tapfood_v2/widgets/LoadingScreen.dart';

class AddonPage extends StatefulWidget {
  final AddonCategory addonCategory;
  const AddonPage({Key? key, required this.addonCategory}) : super(key: key);

  @override
  State<AddonPage> createState() => _AddonPageState();
}

class _AddonPageState extends State<AddonPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  List<ItemType> typeList = [];
  late int previousTypeId;
  late var typeId;
  int? addonCategoryId;

  @override
  void initState() {
    getAddonDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (typeList.isEmpty) {
      typeList.add(ItemType.fromJson({"name": AppLocalizations.of(context)!.optional, "id": 0}));
      typeList.add(ItemType.fromJson({"name": AppLocalizations.of(context)!.required, "id": 1}));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${addonCategoryId == null ? AppLocalizations.of(context)!.add_a : AppLocalizations.of(context)!.edit} ${AppLocalizations.of(context)!.addon}"),
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
      body: Consumer<LoadingProvider>(builder: (context, LoadingProvider loadingProvider, child) {
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
                            focusedBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.orange, width: 1.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          ),
                          onEditingComplete: () {
                            ChangeFocus().fieldFocusChange(context, _nameFocus, _descriptionFocus);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text("${AppLocalizations.of(context)!.description} *"),
                        ),
                        TextField(
                          controller: _descriptionController,
                          focusNode: _descriptionFocus,
                          decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange, width: 1.0),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          ),
                          onEditingComplete: () {},
                        ),
                        const AvailabilityField(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text("${AppLocalizations.of(context)!.type} *"),
                        ),
                        DropdownButtonFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          items: typeList
                              .map((label) => DropdownMenuItem(
                                    child: Text(label.name.toString()),
                                    value: int.parse(label.id.toString()),
                                  ))
                              .toList(),
                          value: typeId,
                          onChanged: (Object? value) {
                            setState(() {
                              typeId = value!;
                            });
                          },
                        ),
                        Offstage(
                          offstage: addonCategoryId == null,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: MaterialButton(
                              minWidth: MediaQuery.of(context).size.width,
                              color: Colors.white,
                              child: Text(AppLocalizations.of(context)!.edit_linked_menu),
                              textColor: Colors.orange,
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LinkedMenuList(
                                          addonCategoryId: int.parse(addonCategoryId.toString()),
                                        )));
                              },
                            ),
                          ),
                        ),
                        Offstage(
                          offstage: addonCategoryId == null,
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            color: Colors.red,
                            child: Text(AppLocalizations.of(context)!.delete),
                            textColor: Colors.white,
                            onPressed: () async {
                              await context.read<LoadingProvider>().setIsLoading(true);

                              bool isSuccess = await context
                                  .read<AddonProvider>()
                                  .deleteAddonCategory(addonCategoryId!);

                              Fluttertoast.showToast(
                                  msg: isSuccess
                                      ? AppLocalizations.of(context)!
                                          .addon_category_delete_success
                                          .replaceAll("[###Name###]", _nameController.text)
                                      : AppLocalizations.of(context)!.delete_fail,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white);

                              await context.read<AddonProvider>().getAllCategory();
                              await context.read<AddonProvider>().getCategoryByType(typeId);

                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    )));
      }),
      bottomNavigationBar: Consumer<LoadingProvider>(
        builder: (context, LoadingProvider loadingProvider, child) {
          return Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                color: loadingProvider.isLoading ? Colors.white : Colors.orange,
                child:
                    loadingProvider.isLoading ? const Text("") : Text(AppLocalizations.of(context)!.save),
                textColor: Colors.white,
                elevation: 0.0,
                onPressed: () async {
                  await context.read<LoadingProvider>().setIsLoading(true);

                  final Availability availability =
                      Provider.of<AvailabilityProvider>(context, listen: false).availability;
                  bool isSuccess = false;

                  if (addonCategoryId == null) {
                    isSuccess = await context.read<AddonProvider>().insertAddonCategory(
                        _nameController.text,
                        _descriptionController.text,
                        availability == Availability.available ? true : false,
                        typeId!);
                  } else {
                    isSuccess = await context.read<AddonProvider>().updateAddonCategory(
                        int.parse(addonCategoryId.toString()),
                        _nameController.text,
                        _descriptionController.text,
                        availability == Availability.available ? true : false,
                        typeId!);
                  }

                  Fluttertoast.showToast(
                      msg: addonCategoryId == null
                          ? (isSuccess
                              ? AppLocalizations.of(context)!
                                  .addon_category_insert_success
                                  .replaceAll("[###Name###]", _nameController.text)
                              : AppLocalizations.of(context)!.insert_fail)
                          : (isSuccess
                              ? AppLocalizations.of(context)!
                                  .addon_category_update_success
                                  .replaceAll("[###Name###]", _nameController.text)
                              : AppLocalizations.of(context)!.update_fail),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white);

                  await context.read<LoadingProvider>().setIsLoading(false);
                  if (isSuccess) {
                    await context.read<AddonProvider>().getAllCategory();
                    await context.read<AddonProvider>().getCategoryByType(previousTypeId);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  getAddonDetail() {
    
    setState(() {
      if (widget.addonCategory.id != null) {
        _nameController.text = widget.addonCategory.name.toString();
        _descriptionController.text = widget.addonCategory.description.toString();
        typeId = int.parse(widget.addonCategory.type.toString());
        addonCategoryId = int.parse(widget.addonCategory.id.toString());
      } else {
        typeId = 0;
      }

      previousTypeId = typeId;
    });
  }
}
