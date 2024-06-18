import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:tapfood_v2/config/appConfig.dart';
import 'package:tapfood_v2/function/PrintReceipt.dart';
import 'package:tapfood_v2/model/Merchant.dart';
import 'package:tapfood_v2/model/OrderDetail.dart';
import 'package:tapfood_v2/provider/OrderProvider.dart';
import 'package:tapfood_v2/services/OrderServices.dart';

class PusherServices{
  final OrderProvider? orderProvider;
  PusherServices(this.orderProvider);

  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();
  late BuildContext _context;
  PusherChannelsFlutter get pusher => _pusher;
  OrderServices orderServices = OrderServices();
  BuildContext get context => _context;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  bool isSunmi = false;
  int newOrderID = 0;


  setContext(buildContext){
    _context = buildContext;
  }

  Future<bool> initPusher() async{
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    if (androidDeviceInfo.brand == "SUNMI") {
      isSunmi = true;
    }

    try{
      await _pusher.init(
        apiKey: Config().pusherKey,
        cluster: Config().pusherCluster,
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onEvent: onEvent,
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        // authEndpoint: "<Your Authendpoint Url>",
        // onAuthorizer: onAuthorizer
      );
    }catch(e){
      return false;
    }

    return true;
  }

  void onConnect(Merchant auth) async {
    if(!_pusher.channels.containsValue("merchantId-${auth.merchantId}") && _pusher.connectionState != "CONNECTED"){
      try{
        await _pusher.subscribe(channelName: "merchantId-${auth.merchantId}");
        await _pusher.connect();
      }catch(e){
        reconnect(auth);
      }
    }
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {}

  void onSubscriptionError(String message, dynamic e) {}

  void onDecryptionFailure(String event, String reason) {
    if (kDebugMode) {
      print("onDecryptionFailure: $event reason: $reason");
    }
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    if (kDebugMode) {
      print("Connection: $currentState");
    }
  }

  void onEvent(PusherEvent event) async {
    print("onEvent: $event");
    final data = jsonDecode(event.data);
    //onEvent: { channelName: merchantId-18, eventName: order_update, data: {"orderId":27128,"status":0}, userId: null }
    //onEvent: { channelName: merchantId-18, eventName: push_notification, data: {"title":"TapFood | New Order","body":"New order received"}, userId: null }

    if (event.eventName == "order_update") {
      if(data["status"] == 0) {
        newOrderID = data["orderId"];
        if (isSunmi) {
          OrderDetail currentOrder = await orderServices.getDetailById(data["orderId"]);
          await PrintReceipt().printWithSunmi(currentOrder);
        }
      }

      int index = data["status"];
      if(index < 3){
        await orderProvider?.setIsLoading(index, true);
        if (index == 0) {
          await orderProvider?.getNormalOrder();
        } else if (index == 2) {
          await orderProvider?.getScheduledOrder();
        } else if (index == 1) {
          await orderProvider?.getCompletedOrder();
        }
      }
    }
  }

  void onError(String message, int? code, dynamic e) {
    if (kDebugMode) {
      print("onError: $message code: $code exception: $e");
    }
  }

  void disconnect(Merchant auth) async{
    await _pusher.unsubscribe(channelName: "merchantId-${auth.merchantId}");
    await _pusher.disconnect();

  }

  reconnect(Merchant auth) async{
    try{
      await _pusher.unsubscribe(channelName: "merchantId-${auth.merchantId}");
      await _pusher.disconnect();

      await _pusher.subscribe(channelName: "merchantId-${auth.merchantId}");
      await _pusher.connect();
    }catch(e){
      reconnect(auth);
    }

  }

  Future<void> clear(String channelName) async {
    try{
      await _pusher.unsubscribe(channelName: channelName);
      await _pusher.disconnect();
    }catch(e){
      print(e);
    }

  }
}