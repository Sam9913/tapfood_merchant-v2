import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';

var locator = GetIt.instance;

@injectableInit
void setupLocator() => $initGetIt(locator);

/*
 References:
 https://github.com/FilledStacks/stacked-example/blob/part-7-dialog-service
*/
GetIt $initGetIt(
		GetIt get, {
			String? environment,
			EnvironmentFilter? environmentFilter,
		}) {
	final gh = GetItHelper(get, environment, environmentFilter);
	final thirdPartyServicesModule = _$ThirdPartyServicesModule();
	gh.lazySingleton<DialogService>(() => thirdPartyServicesModule.dialogService);

	return get;
}

class _$ThirdPartyServicesModule extends ThirdPartyServicesModule {
	@override
	DialogService get dialogService => DialogService();
	@override
	NavigationService get navigationService => NavigationService();
}

@module
abstract class ThirdPartyServicesModule {
	@lazySingleton
	NavigationService get navigationService;
	@lazySingleton
	DialogService get dialogService;
}
