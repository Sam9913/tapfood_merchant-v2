import 'package:flutter/material.dart';

class ChangeFocus{
	fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
		currentFocus.unfocus();
		FocusScope.of(context).requestFocus(nextFocus);
	}
}