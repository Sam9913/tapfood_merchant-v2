
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_zh.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations returned
/// by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ms'),
    Locale('zh')
  ];

  /// No description provided for @newer_version_found.
  ///
  /// In en, this message translates to:
  /// **'Found newer version'**
  String get newer_version_found;

  /// No description provided for @newer_version_found_content.
  ///
  /// In en, this message translates to:
  /// **'Please download latest version to proceed'**
  String get newer_version_found_content;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @log_in.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get log_in;

  /// No description provided for @log_in_content.
  ///
  /// In en, this message translates to:
  /// **'Log In to your account'**
  String get log_in_content;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcome_back;

  /// No description provided for @login_fail.
  ///
  /// In en, this message translates to:
  /// **'Wrong password or email'**
  String get login_fail;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get setting;

  /// No description provided for @app_version.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get app_version;

  /// No description provided for @log_out.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get log_out;

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// No description provided for @vehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicle;

  /// No description provided for @delivery_vehicle_message.
  ///
  /// In en, this message translates to:
  /// **'Delivery vehicle updated to '**
  String get delivery_vehicle_message;

  /// No description provided for @preparation_time.
  ///
  /// In en, this message translates to:
  /// **'Preparation Time (minute)'**
  String get preparation_time;

  /// No description provided for @preparation_time_message.
  ///
  /// In en, this message translates to:
  /// **'Delivery preparation time updated to '**
  String get preparation_time_message;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @operation_hour.
  ///
  /// In en, this message translates to:
  /// **'Regular Operation Hours'**
  String get operation_hour;

  /// No description provided for @special_operation_hour.
  ///
  /// In en, this message translates to:
  /// **'Special Hours'**
  String get special_operation_hour;

  /// No description provided for @special_hour_message.
  ///
  /// In en, this message translates to:
  /// **'Special hour on '**
  String get special_hour_message;

  /// No description provided for @edit_operation_hour.
  ///
  /// In en, this message translates to:
  /// **'Edit Operation Hours'**
  String get edit_operation_hour;

  /// No description provided for @add_another_time.
  ///
  /// In en, this message translates to:
  /// **'Add another time'**
  String get add_another_time;

  /// No description provided for @confirm_operation_hour.
  ///
  /// In en, this message translates to:
  /// **'Confirm Regular Hour'**
  String get confirm_operation_hour;

  /// No description provided for @add_special_hour.
  ///
  /// In en, this message translates to:
  /// **'Add Special Hour'**
  String get add_special_hour;

  /// No description provided for @edit_special_hour.
  ///
  /// In en, this message translates to:
  /// **'Edit Special Hour'**
  String get edit_special_hour;

  /// No description provided for @special_hour_date.
  ///
  /// In en, this message translates to:
  /// **'Special hour date'**
  String get special_hour_date;

  /// No description provided for @all_day.
  ///
  /// In en, this message translates to:
  /// **'All day'**
  String get all_day;

  /// No description provided for @confirm_special_hour.
  ///
  /// In en, this message translates to:
  /// **'Confirm Special Hour'**
  String get confirm_special_hour;

  /// No description provided for @open_at.
  ///
  /// In en, this message translates to:
  /// **'Open At'**
  String get open_at;

  /// No description provided for @close_at.
  ///
  /// In en, this message translates to:
  /// **'Close At'**
  String get close_at;

  /// No description provided for @app_settings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get app_settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @store_settings.
  ///
  /// In en, this message translates to:
  /// **'Store Settings'**
  String get store_settings;

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'minute'**
  String get minute;

  /// No description provided for @special_hour_removed.
  ///
  /// In en, this message translates to:
  /// **'Special hour on [###Date###] removed.'**
  String get special_hour_removed;

  /// No description provided for @auto_print_receipt.
  ///
  /// In en, this message translates to:
  /// **'Auto Print Receipt'**
  String get auto_print_receipt;

  /// No description provided for @printer_setting.
  ///
  /// In en, this message translates to:
  /// **'Printer Setting'**
  String get printer_setting;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @preparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get preparing;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @order_details.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get order_details;

  /// No description provided for @rider.
  ///
  /// In en, this message translates to:
  /// **'Rider'**
  String get rider;

  /// No description provided for @order_summary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get order_summary;

  /// No description provided for @customer_notes_title.
  ///
  /// In en, this message translates to:
  /// **'Notes from customers'**
  String get customer_notes_title;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @cancel_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Cancel confirmation'**
  String get cancel_confirmation;

  /// No description provided for @confirm_to_cancel.
  ///
  /// In en, this message translates to:
  /// **'Confirm to cancel TF-[###OrderID###] by [###Name###]'**
  String get confirm_to_cancel;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @unpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaid;

  /// No description provided for @delivery_order_description.
  ///
  /// In en, this message translates to:
  /// **'[###ItemCount###] items for [###UserName###]'**
  String get delivery_order_description;

  /// No description provided for @others_order_description.
  ///
  /// In en, this message translates to:
  /// **'[###UserName###] ordered [###ItemCount###] items'**
  String get others_order_description;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @item_count.
  ///
  /// In en, this message translates to:
  /// **'[###ItemCount###] items'**
  String get item_count;

  /// No description provided for @for_user.
  ///
  /// In en, this message translates to:
  /// **'for [###UserName###]'**
  String get for_user;

  /// No description provided for @user_ordered.
  ///
  /// In en, this message translates to:
  /// **'[###UserName###] ordered'**
  String get user_ordered;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @order_total.
  ///
  /// In en, this message translates to:
  /// **'Grand Total'**
  String get order_total;

  /// No description provided for @table_no.
  ///
  /// In en, this message translates to:
  /// **'Table No'**
  String get table_no;

  /// No description provided for @customer_name.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customer_name;

  /// No description provided for @order_preference.
  ///
  /// In en, this message translates to:
  /// **'Order Preference'**
  String get order_preference;

  /// No description provided for @dine_in.
  ///
  /// In en, this message translates to:
  /// **'Dine In'**
  String get dine_in;

  /// No description provided for @self_pick_up.
  ///
  /// In en, this message translates to:
  /// **'Self Pick Up'**
  String get self_pick_up;

  /// No description provided for @drive_thru.
  ///
  /// In en, this message translates to:
  /// **'Drive Thru'**
  String get drive_thru;

  /// No description provided for @campus_delivery.
  ///
  /// In en, this message translates to:
  /// **'Campus Delivery'**
  String get campus_delivery;

  /// No description provided for @order_time.
  ///
  /// In en, this message translates to:
  /// **'Order Time'**
  String get order_time;

  /// No description provided for @pickup_at.
  ///
  /// In en, this message translates to:
  /// **'Pick Up At'**
  String get pickup_at;

  /// No description provided for @order_note.
  ///
  /// In en, this message translates to:
  /// **'Order Note'**
  String get order_note;

  /// No description provided for @track.
  ///
  /// In en, this message translates to:
  /// **'Track #'**
  String get track;

  /// No description provided for @order_complete.
  ///
  /// In en, this message translates to:
  /// **'Order Received'**
  String get order_complete;

  /// No description provided for @new_order.
  ///
  /// In en, this message translates to:
  /// **'New Order'**
  String get new_order;

  /// No description provided for @new_schedule_order.
  ///
  /// In en, this message translates to:
  /// **'New Scheduled Order'**
  String get new_schedule_order;

  /// No description provided for @order_time_arrive.
  ///
  /// In en, this message translates to:
  /// **'Schedule Order Time Arrive'**
  String get order_time_arrive;

  /// No description provided for @delivery_fee.
  ///
  /// In en, this message translates to:
  /// **'Delivery Fee'**
  String get delivery_fee;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// No description provided for @platform_tax.
  ///
  /// In en, this message translates to:
  /// **'Platform Tax'**
  String get platform_tax;

  /// No description provided for @service_charge.
  ///
  /// In en, this message translates to:
  /// **'Service Charge'**
  String get service_charge;

  /// No description provided for @government_tax.
  ///
  /// In en, this message translates to:
  /// **'Government Tax'**
  String get government_tax;

  /// No description provided for @queue_no.
  ///
  /// In en, this message translates to:
  /// **'Queue No'**
  String get queue_no;

  /// No description provided for @addon.
  ///
  /// In en, this message translates to:
  /// **'Addon'**
  String get addon;

  /// No description provided for @addon_item.
  ///
  /// In en, this message translates to:
  /// **'Addon Item'**
  String get addon_item;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @edit_linked_menu.
  ///
  /// In en, this message translates to:
  /// **'Edit Linked Menu'**
  String get edit_linked_menu;

  /// No description provided for @remove_link.
  ///
  /// In en, this message translates to:
  /// **'Remove Link'**
  String get remove_link;

  /// No description provided for @link.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get link;

  /// No description provided for @search_addon.
  ///
  /// In en, this message translates to:
  /// **'Search Addon'**
  String get search_addon;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @menu_item.
  ///
  /// In en, this message translates to:
  /// **'Menu Item'**
  String get menu_item;

  /// No description provided for @image_description.
  ///
  /// In en, this message translates to:
  /// **'Accepted any images'**
  String get image_description;

  /// No description provided for @take_away_price.
  ///
  /// In en, this message translates to:
  /// **'Take Away Price'**
  String get take_away_price;

  /// No description provided for @delivery_price.
  ///
  /// In en, this message translates to:
  /// **'Delivery Price'**
  String get delivery_price;

  /// No description provided for @search_menu.
  ///
  /// In en, this message translates to:
  /// **'Search Menu'**
  String get search_menu;

  /// No description provided for @menu_category.
  ///
  /// In en, this message translates to:
  /// **'Menu Category'**
  String get menu_category;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @order_of.
  ///
  /// In en, this message translates to:
  /// **'Order of'**
  String get order_of;

  /// No description provided for @start_date.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get start_date;

  /// No description provided for @end_date.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get end_date;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @total_sales.
  ///
  /// In en, this message translates to:
  /// **'Total Sales'**
  String get total_sales;

  /// No description provided for @total_refund.
  ///
  /// In en, this message translates to:
  /// **'Total Refund'**
  String get total_refund;

  /// No description provided for @total_settlement.
  ///
  /// In en, this message translates to:
  /// **'Total Settlement'**
  String get total_settlement;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @removed.
  ///
  /// In en, this message translates to:
  /// **'removed'**
  String get removed;

  /// No description provided for @availability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get availability;

  /// No description provided for @add_a.
  ///
  /// In en, this message translates to:
  /// **'Add a'**
  String get add_a;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Dine In Price'**
  String get price;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @add_category.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get add_category;

  /// No description provided for @add_item.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get add_item;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @insert.
  ///
  /// In en, this message translates to:
  /// **'Insert'**
  String get insert;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @photo.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photo;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get items;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @beverage.
  ///
  /// In en, this message translates to:
  /// **'Beverage'**
  String get beverage;

  /// No description provided for @no_orders_within_date_range.
  ///
  /// In en, this message translates to:
  /// **'No orders in the date range selected'**
  String get no_orders_within_date_range;

  /// No description provided for @no_addon.
  ///
  /// In en, this message translates to:
  /// **'No addon'**
  String get no_addon;

  /// No description provided for @no_menu.
  ///
  /// In en, this message translates to:
  /// **'No menu'**
  String get no_menu;

  /// No description provided for @no_addon_found.
  ///
  /// In en, this message translates to:
  /// **'No addon related found'**
  String get no_addon_found;

  /// No description provided for @no_menu_found.
  ///
  /// In en, this message translates to:
  /// **'No menu related found'**
  String get no_menu_found;

  /// No description provided for @internet_not_found.
  ///
  /// In en, this message translates to:
  /// **'Internet connection not found'**
  String get internet_not_found;

  /// No description provided for @no_order_currently.
  ///
  /// In en, this message translates to:
  /// **'No order in the current time'**
  String get no_order_currently;

  /// No description provided for @tf_hours.
  ///
  /// In en, this message translates to:
  /// **'24 Hours'**
  String get tf_hours;

  /// No description provided for @error_name.
  ///
  /// In en, this message translates to:
  /// **'Name is required field'**
  String get error_name;

  /// No description provided for @error_menuCategory.
  ///
  /// In en, this message translates to:
  /// **'Menu Category is required field'**
  String get error_menuCategory;

  /// No description provided for @error_price.
  ///
  /// In en, this message translates to:
  /// **'Price is required field'**
  String get error_price;

  /// No description provided for @error_description.
  ///
  /// In en, this message translates to:
  /// **'Description is required field'**
  String get error_description;

  /// No description provided for @cover_most.
  ///
  /// In en, this message translates to:
  /// **'Unable to add because previous operation time already cover 22 hours'**
  String get cover_most;

  /// No description provided for @illogic_operation_add.
  ///
  /// In en, this message translates to:
  /// **'Unable to add because crash on previous operation time'**
  String get illogic_operation_add;

  /// No description provided for @illogic_operation_edit.
  ///
  /// In en, this message translates to:
  /// **'Unable to edit because crash on previous operation time'**
  String get illogic_operation_edit;

  /// No description provided for @special_hour_delete_success.
  ///
  /// In en, this message translates to:
  /// **'Special operation hour on [###Date###] deleted'**
  String get special_hour_delete_success;

  /// No description provided for @special_hour_insert_success.
  ///
  /// In en, this message translates to:
  /// **'Special operation hour on [###Date###] added'**
  String get special_hour_insert_success;

  /// No description provided for @special_hour_update_success.
  ///
  /// In en, this message translates to:
  /// **'Special operation hour on [###Date###] updated'**
  String get special_hour_update_success;

  /// No description provided for @operation_hour_delete_success.
  ///
  /// In en, this message translates to:
  /// **'Operation hour deleted'**
  String get operation_hour_delete_success;

  /// No description provided for @operation_hour_insert_success.
  ///
  /// In en, this message translates to:
  /// **'Operation hour added'**
  String get operation_hour_insert_success;

  /// No description provided for @operation_hour_update_success.
  ///
  /// In en, this message translates to:
  /// **'Operation hour updated'**
  String get operation_hour_update_success;

  /// No description provided for @addon_delete_success.
  ///
  /// In en, this message translates to:
  /// **'Addon([###Name###]) is deleted'**
  String get addon_delete_success;

  /// No description provided for @addon_insert_success.
  ///
  /// In en, this message translates to:
  /// **'Addon([###Name###]) is added'**
  String get addon_insert_success;

  /// No description provided for @addon_update_success.
  ///
  /// In en, this message translates to:
  /// **'Addon([###Name###]) is updated'**
  String get addon_update_success;

  /// No description provided for @addon_status_update_success.
  ///
  /// In en, this message translates to:
  /// **'Addon([###Name###]) status updated'**
  String get addon_status_update_success;

  /// No description provided for @addon_category_delete_success.
  ///
  /// In en, this message translates to:
  /// **'Addon category([###Name###]) is deleted'**
  String get addon_category_delete_success;

  /// No description provided for @addon_category_insert_success.
  ///
  /// In en, this message translates to:
  /// **'Addon category([###Name###]) is added'**
  String get addon_category_insert_success;

  /// No description provided for @addon_category_update_success.
  ///
  /// In en, this message translates to:
  /// **'Addon category([###Name###]) is updated'**
  String get addon_category_update_success;

  /// No description provided for @addon_category_status_update_success.
  ///
  /// In en, this message translates to:
  /// **'Addon category([###Name###]) status updated'**
  String get addon_category_status_update_success;

  /// No description provided for @menu_delete_success.
  ///
  /// In en, this message translates to:
  /// **'Menu([###Name###]) is deleted'**
  String get menu_delete_success;

  /// No description provided for @menu_insert_success.
  ///
  /// In en, this message translates to:
  /// **'Menu([###Name###]) is added'**
  String get menu_insert_success;

  /// No description provided for @menu_update_success.
  ///
  /// In en, this message translates to:
  /// **'Menu([###Name###]) is updated'**
  String get menu_update_success;

  /// No description provided for @menu_status_update_success.
  ///
  /// In en, this message translates to:
  /// **'Menu([###Name###]) status updated'**
  String get menu_status_update_success;

  /// No description provided for @menu_category_delete_success.
  ///
  /// In en, this message translates to:
  /// **'Menu category([###Name###]) is deleted'**
  String get menu_category_delete_success;

  /// No description provided for @menu_category_insert_success.
  ///
  /// In en, this message translates to:
  /// **'Menu category([###Name###]) is added'**
  String get menu_category_insert_success;

  /// No description provided for @menu_category_update_success.
  ///
  /// In en, this message translates to:
  /// **'Menu category([###Name###]) is updated'**
  String get menu_category_update_success;

  /// No description provided for @menu_category_status_update_success.
  ///
  /// In en, this message translates to:
  /// **'Menu category([###Name###]) status updated'**
  String get menu_category_status_update_success;

  /// No description provided for @order_payment_update.
  ///
  /// In en, this message translates to:
  /// **'TF-[###OrderID###] update to paid'**
  String get order_payment_update;

  /// No description provided for @order_cancel_success.
  ///
  /// In en, this message translates to:
  /// **'TF-[###OrderID###] cancelled'**
  String get order_cancel_success;

  /// No description provided for @order_status_update_success.
  ///
  /// In en, this message translates to:
  /// **'TF-[###OrderID###] completed'**
  String get order_status_update_success;

  /// No description provided for @delete_fail.
  ///
  /// In en, this message translates to:
  /// **'Fail to delete, please try again later'**
  String get delete_fail;

  /// No description provided for @update_fail.
  ///
  /// In en, this message translates to:
  /// **'Fail to update, please try again later'**
  String get update_fail;

  /// No description provided for @insert_fail.
  ///
  /// In en, this message translates to:
  /// **'Fail to insert, please try again later'**
  String get insert_fail;

  /// No description provided for @cancel_fail.
  ///
  /// In en, this message translates to:
  /// **'Fail to cancel, please try again later'**
  String get cancel_fail;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @no_special_hour.
  ///
  /// In en, this message translates to:
  /// **'No special hour'**
  String get no_special_hour;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ms', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ms': return AppLocalizationsMs();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
