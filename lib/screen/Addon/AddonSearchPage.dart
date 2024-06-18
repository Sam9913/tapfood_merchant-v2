import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/model/SearchResult.dart';
import 'package:tapfood_v2/provider/AddonProvider.dart';
import 'package:tapfood_v2/screen/Addon/AddonItemPage.dart';
import 'package:tapfood_v2/screen/Addon/AddonPage.dart';
import 'package:tapfood_v2/widgets/EmptyScreen.dart';
import 'package:tapfood_v2/widgets/LoadingScreen.dart';

class AddonSearchPage extends StatefulWidget {
  const AddonSearchPage({Key? key}) : super(key: key);

  @override
  State<AddonSearchPage> createState() => _AddonSearchPageState();
}

class _AddonSearchPageState extends State<AddonSearchPage> {
  final TextEditingController _keywordController = TextEditingController();
  List<SearchResult> searchResultListing = [];
  bool isLoading = false;

  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Transform.translate(
          offset: const Offset(-16, 0),
          child: TextField(
            controller: _keywordController,
            autofocus: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: AppLocalizations.of(context)!.search_addon,
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: (String value) async {
              setState(() {
                isLoading = true;
              });

              final response =
                  await context.read<AddonProvider>().search(value);
              setState(() {
                searchResultListing = response;
                isLoading = false;
              });
            },
          ),
        ),
        titleSpacing: 8.0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.orange,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading
          ? const LoadingScreen()
          : searchResultListing.isEmpty
          ? EmptyScreen(
              content: AppLocalizations.of(context)!.no_addon_found,
              imageUrl: 'images/undraw_Blank_canvas_re_2hwy.png',
              height: 1.0,
            )
          : Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: ListView.builder(
                itemCount: searchResultListing.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0)),
                      child: ListTile(
                        title: Text("${searchResultListing[index].name}"),
                        subtitle: Text(searchResultListing[index].type == 0
                            ? AppLocalizations.of(context)!.category
                            : AppLocalizations.of(context)!.addon_item),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () async {
                          if (searchResultListing[index].type == 0) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AddonPage(
                                    addonCategory: searchResultListing[index]
                                        .addonCategory)));
                          } else {
                            await context
                                .read<AddonProvider>()
                                .setAddon(searchResultListing[index].addon);

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const AddonItemPage()));
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
