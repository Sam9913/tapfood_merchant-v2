import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/widgets/EmptyScreen.dart';
import 'package:tapfood_v2/widgets/LoadingScreen.dart';

class PrinterSetting extends StatefulWidget {
  const PrinterSetting({Key? key}) : super(key: key);

  static BluetoothDevice? device;
  @override
  State<PrinterSetting> createState() => _PrinterSettingState();
}

class _PrinterSettingState extends State<PrinterSetting> {
  bool isConnecting = false;
  bool connected = false;
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  bool scanning = false;
  List<BluetoothDevice> _devices = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.printer_setting),
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
      body: isConnecting
          ? const LoadingScreen()
          : Container(
              color: Colors.white,
              child: _devices.isEmpty
                  ? EmptyScreen(
                      content: "No bluetooth device found",
                      imageUrl: "images/undraw_Blank_canvas_re_2hwy.png",
                      height: MediaQuery.of(context).size.height * 0.9)
                  : ListView.builder(
                      itemCount: _devices.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            setState(() {
                              PrinterSetting.device = _devices[index];
                              _connect(_devices[index]);
                            });
                          },
                          title: Text(_devices[index].name.toString()),
                          trailing: Container(
                              decoration: BoxDecoration(
                                color: PrinterSetting.device != null &&
                                        _devices[index].name == PrinterSetting.device!.name
                                    ? Colors.lightGreen
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  PrinterSetting.device != null &&
                                          _devices[index].name == PrinterSetting.device!.name
                                      ? "Connected"
                                      : "Disconnected",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              )),
                        );
                      },
                    )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isConnecting = !isConnecting;
          });

          if (isConnecting) {
            initPlatformState();
          } else {
            bluetooth.disconnect();
          }
        },
        backgroundColor: isConnecting ? Colors.redAccent : Colors.orangeAccent,
        child: Icon(
          isConnecting ? Icons.stop : Icons.search,
          color: Colors.white,
        ),
      ),
    );
  }

  getRequest() async {
    var bluetoothScanStatus = await Permission.bluetoothScan.status;
    var locationStatus = await Permission.location.status;
    if (locationStatus.isDenied && bluetoothScanStatus.isDenied) {
      await [
        Permission.location,
        Permission.bluetoothConnect,
      ].request();
    } else if (locationStatus.isDenied) {
      await Permission.location.request();
    } else if (bluetoothScanStatus.isDenied) {
      await Permission.bluetoothScan.request();
    }
  }

  Future<void> initPlatformState() async {
    await getRequest();
    bool? isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {

    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            connected = true;
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            connected = false;
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
      scanning = false;
    });

    if (isConnected!) {
      setState(() {
        connected = true;
      });
    }

    setState(() {
      isConnecting = !isConnecting;
    });
  }

  void _connect(BluetoothDevice bluetoothDevice) {
    bluetooth.isConnected.then((isConnected) {
      if (!isConnected!) {
        bluetooth.connect(bluetoothDevice).catchError((error) {
          setState(() => connected = false);
        });
        setState(() => connected = true);
      }
    });
  }
}
