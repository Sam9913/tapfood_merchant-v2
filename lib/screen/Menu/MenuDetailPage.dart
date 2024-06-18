import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/config/appConfig.dart';
import 'package:tapfood_v2/config/enum.dart';
import 'package:tapfood_v2/function/ChangeFocus.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/model/Menu.dart';
import 'package:tapfood_v2/model/MenuItem.dart' as model;
import 'package:tapfood_v2/provider/ControlProvider.dart';
import 'package:tapfood_v2/provider/MenuProvider.dart';
import 'package:tapfood_v2/services/PusherServices.dart';
import 'package:tapfood_v2/widgets/AvailabilityField.dart';
import 'package:path/path.dart' as path;
import 'package:tapfood_v2/widgets/LoadingScreen.dart';
import 'package:tapfood_v2/widgets/MenuCategoryField.dart';

class MenuDetailPage extends StatefulWidget {
  final int menuItemId;
  const MenuDetailPage({Key? key, required this.menuItemId}) : super(key: key);

  @override
  State<MenuDetailPage> createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _takeAwayPriceController = TextEditingController();
  final TextEditingController _deliveryPriceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _priceFocus = FocusNode();
  final FocusNode _takeAwayPriceFocus = FocusNode();
  final FocusNode _deliveryPriceFocus = FocusNode();
  List<Menu> menuCategoryList = [];
  var categoryId = 0;
  late model.MenuItem menuItem;
  bool gotData = false;
  File _imageFile = File("");

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
              "${gotData ? AppLocalizations.of(context)!.edit : AppLocalizations.of(context)!.add_a} ${AppLocalizations.of(context)!.menu_item}"),
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
        body: SingleChildScrollView(child:
            Consumer<LoadingProvider>(builder: (context, LoadingProvider loadingProvider, child) {
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
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.35,
                                height: MediaQuery.of(context).size.height * 0.15,
                                child: _imageFile.path != ""
                                    ? Image.file(
                                        _imageFile,
                                      )
                                    : Image.network(
                                        menuItem.menuItemImage == null
                                            ? "https://cdn4.iconfinder.com/data/icons/ionicons/512/icon-image-512.png"
                                            : Config().imageUrl + "${menuItem.menuItemImage}",
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MaterialButton(
                                      onPressed: () async {
                                        final picker = ImagePicker();
                                        var image =
                                            await picker.pickImage(source: ImageSource.gallery);
                                        String? imagePath = image?.path.toString();

                                        setState(() {
                                          _imageFile = File(imagePath.toString());
                                        });
                                      },
                                      color: Colors.orange,
                                      child: Text(
                                        "${menuItem.menuItemImage == null ? AppLocalizations.of(context)!.insert : AppLocalizations.of(context)!.change} ${AppLocalizations.of(context)!.photo}",
                                        style: const TextStyle(
                                            color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.image_description,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontStyle: FontStyle.italic),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
                          onSubmitted: (String value) {
                            ChangeFocus().fieldFocusChange(context, _nameFocus, _descriptionFocus);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(AppLocalizations.of(context)!.description),
                        ),
                        TextField(
                          maxLines: 3,
                          controller: _descriptionController,
                          focusNode: _descriptionFocus,
                          decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange, width: 1.0),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          ),
                          onSubmitted: (String value) {
                            ChangeFocus().fieldFocusChange(context, _descriptionFocus, _priceFocus);
                          },
                        ),
                        /*Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text("${AppLocalizations.of(context)!.type} *"),
                  ),
                  DropdownButtonFormField(
                    value: menuItem.category,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: typeList
                        .map((label) => DropdownMenuItem(
                              child: Text(label.name.toString()),
                              value: int.parse(label.id.toString()),
                            ))
                        .toList(),
                    onChanged: (Object? value) {},
                  ),*/
                        const Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: MenuCategoryField(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text("${AppLocalizations.of(context)!.menu_category} *"),
                        ),
                        DropdownButtonFormField(
                          value: menuItem.menuId,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          items: menuCategoryList
                              .map((label) => DropdownMenuItem(
                                    child: Text(label.name.toString()),
                                    value: int.parse(label.menuId.toString()),
                                  ))
                              .toList(),
                          onChanged: (Object? value) {
                            setState(() {
                              categoryId = value as int;
                            });
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
                          onSubmitted: (String value) {
                            ChangeFocus()
                                .fieldFocusChange(context, _priceFocus, _takeAwayPriceFocus);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(AppLocalizations.of(context)!.take_away_price),
                        ),
                        TextField(
                          controller: _takeAwayPriceController,
                          focusNode: _takeAwayPriceFocus,
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
                          onSubmitted: (String value) {
                            ChangeFocus().fieldFocusChange(
                                context, _takeAwayPriceFocus, _deliveryPriceFocus);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(AppLocalizations.of(context)!.delivery_price),
                        ),
                        TextField(
                          controller: _deliveryPriceController,
                          focusNode: _deliveryPriceFocus,
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
                          onSubmitted: (String value) {
                            _deliveryPriceFocus.unfocus();
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: AvailabilityField(),
                        ),
                        Offstage(
                          offstage: widget.menuItemId == 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: MaterialButton(
                              minWidth: MediaQuery.of(context).size.width,
                              color: Colors.red,
                              child: Text(AppLocalizations.of(context)!.delete),
                              textColor: Colors.white,
                              onPressed: () async {
                                await context.read<LoadingProvider>().setIsLoading(true);
                                bool isSuccess = await context
                                    .read<MenuProvider>()
                                    .deleteMenuItem(widget.menuItemId);

                                Fluttertoast.showToast(
                                    msg: isSuccess
                                        ? AppLocalizations.of(context)!.menu_delete_success.replaceAll("[###Name###]", menuItem.name.toString())
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
                    ),
                  ),
                );
        })),
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
                    if (_nameController.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)!.error_name,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white);
                    } else if (_priceController.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)!.error_price,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white);
                    }

                    await context.read<LoadingProvider>().setIsLoading(true);

                    final Availability availability =
                        Provider.of<AvailabilityProvider>(context, listen: false).availability;
                    final MenuCategory menuCategory =
                        Provider.of<MenuCategoryProvider>(context, listen: false).menuCategory;
                    bool isSuccess = false;
                    MultipartFile? multipartFile;

                    if (_imageFile.path.isNotEmpty) {
                      multipartFile = await MultipartFile.fromFile(_imageFile.path,
                          filename: path.basename(_imageFile.path));
                    }

                    if (widget.menuItemId == 0) {
                      isSuccess = await context.read<MenuProvider>().insertMenuItem(
                          _nameController.text,
                          menuCategory == MenuCategory.food ? 1 : 0,
                          _descriptionController.text,
                          _priceController.text,
                          _takeAwayPriceController.text,
                          _deliveryPriceController.text,
                          categoryId,
                          availability == Availability.available ? 1 : 0,
                          1,
                          multipartFile);
                    } else {
                      isSuccess = await context.read<MenuProvider>().updateMenuItem(
                          _nameController.text,
                          menuCategory == MenuCategory.food ? 1 : 0,
                          _descriptionController.text,
                          _priceController.text,
                          _takeAwayPriceController.text,
                          _deliveryPriceController.text,
                          categoryId,
                          availability == Availability.available ? 1 : 0,
                          1,
                          widget.menuItemId,
                          multipartFile);
                    }

                    Fluttertoast.showToast(
                        msg: widget.menuItemId == 0
                            ? (isSuccess
                            ? AppLocalizations.of(context)!
                            .menu_insert_success
                            .replaceAll("[###Name###]", _nameController.text)
                            : AppLocalizations.of(context)!.insert_fail)
                            : (isSuccess
                            ? AppLocalizations.of(context)!
                            .menu_update_success
                            .replaceAll("[###Name###]", _nameController.text)
                            : AppLocalizations.of(context)!.update_fail),
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
            );
          },
        ));
  }

  getMenuDetail() {
    setState(() {
      menuCategoryList = context.read<MenuProvider>().menuList;
      gotData = false;
      menuItem = model.MenuItem();
      categoryId = menuCategoryList[0].menuId;
    });

    if (widget.menuItemId != 0) {
      var _selectedMenuItem = context.read<MenuProvider>().selectedMenuItem;

      setState(() {
        menuItem = _selectedMenuItem;
        if (_selectedMenuItem.name != null) {
          _nameController.text = _selectedMenuItem.name.toString();
          _priceController.text = _selectedMenuItem.price.toString();
          _descriptionController.text =
              _selectedMenuItem.description == null ? "" : _selectedMenuItem.description.toString();
          _takeAwayPriceController.text = _selectedMenuItem.takeAwayPrice.toString();
          _deliveryPriceController.text = _selectedMenuItem.deliveryPrice.toString();
          categoryId = menuItem.menuId ?? menuCategoryList[0].menuId;
          //print(menuItem.detail.menuItemImage);
        }
        gotData = true;
      });
    }
  }
}
