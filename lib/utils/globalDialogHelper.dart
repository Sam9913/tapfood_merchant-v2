import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:tapfood_v2/utils/locator.dart';

class GlobalDiaLogHelper extends BaseViewModel {
	final _dialogService = locator<DialogService>();

	late bool _confirmationResult;
	bool get confirmationResult => _confirmationResult;

	late DialogResponse _dialogResponse;
	DialogResponse get customDialogResult => _dialogResponse;

	Future showAPIErrorDialog(
			{required String dialogTitle, required String dialogDescription}) async {
		DialogResponse? response = await _dialogService.showDialog(
				title: dialogTitle,
				description: dialogDescription,
				barrierDismissible: true);
	}
}
