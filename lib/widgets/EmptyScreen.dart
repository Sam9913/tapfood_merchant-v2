import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  final String content;
  final String imageUrl;
  final double height;
  const EmptyScreen({Key? key, required this.content, required this.imageUrl, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.height * height - 50,
                child: Image.asset(imageUrl)),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                content,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
