import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/provider/ControlProvider.dart';

class BottomTab extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Widget navigationPage;
  final bool isCurrentPage = false;
  const BottomTab(
      {Key? key,
      required this.title,
      required this.iconData,
      required this.navigationPage,
      isCurrentPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
          child: Column(
            children: <Widget>[
              Icon(
                iconData,
                color: Colors.orange,
              ),
              Text(
                title,
                style: const TextStyle(color: Colors.orange, fontSize: 12),
              ),
            ],
          ),
          onTap: () async{
            await Provider.of<LoadingProvider>(context, listen: false).setIsLoading(true);

            isCurrentPage
                ? {}
                : Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => navigationPage,
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                    //MaterialPageRoute(builder: (context) => navigationPage),
                  );
          }),
    );
  }
}
