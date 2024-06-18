import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
	final bool? isCut;
  const LoadingScreen({Key? key, this.isCut}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
			height: MediaQuery.of(context).size.height * (isCut == true ? 0.7 : 1.0),
			color: Colors.white,
			child: const Center(
			  child: CircularProgressIndicator(
			  	color: Colors.orange,
			  ),
			),
		);
  }
}
