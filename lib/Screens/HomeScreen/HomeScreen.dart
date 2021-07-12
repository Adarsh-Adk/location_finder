import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Location location = Location();

  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  // TextStyle customStyle=GoogleFonts.ubuntu(fontSize: 20,color:Colors.lightBlue);

  Future<bool> checkServiceEnabled() async {
    print("check service called");
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  Future<bool> checkPermission() async {
    print("check permission called");
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied ||
        _permissionGranted == PermissionStatus.deniedForever) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  getLocation() async {
    bool? a, b;
    await checkServiceEnabled()
        .then((value) async {
          print("checkservice value:$value");
          a = value;
        })
        .then((value) async => await checkPermission().then((val) {
              print("check permission value:$val");
              return b = val;
            }))
        .then((value) async {
          if (a == true && b == true) {
            await location.getLocation().then((valu) {
              print("location found ${valu.provider}");
              return _locationData = valu;
            }).then((value) {
              setState(() {});
            });
          }
        });
  }

  @override
  void initState() {
    getLocation();
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        getLocation();
      });
    }
    // else if (state == AppLifecycleState.inactive) {
    //   setState(() {
    //     getLocation();
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      return Stack(
        children: [
          SvgPicture.asset('assets/Grid1.svg',height: size.maxHeight,fit: BoxFit.fitHeight,),
          Scaffold(
            appBar: AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      onPressed: () {
                        showCustomBottomSheet(context, size);
                      },
                      icon: Icon(
                        Icons.help_outline_outlined,
                        color: Theme.of(context).primaryColor,
                      )),
                )
              ],
              centerTitle: true,
              title: Text(
                "Location Data",
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            body: LayoutBuilder(
              builder: (context, size) {
                return Container(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    child: SafeArea(
                        child: Center(
                            child: _serviceEnabled == false
                                ? Text("Service not enabled",
                                    style: Theme.of(context).textTheme.headline1)
                                : (_permissionGranted == PermissionStatus.denied ||
                                        _permissionGranted ==
                                            PermissionStatus.deniedForever)
                                    ? Text("Permission not granted",
                                        style:
                                            Theme.of(context).textTheme.headline1)
                                    : _locationData == null
                                        ? Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Waiting for response...",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline1,
                                              ),
                                              SizedBox(
                                                height: 25,
                                              ),
                                              Container(
                                                  width: size.maxWidth * 0.7,
                                                  child: LinearProgressIndicator(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  )),
                                            ],
                                          )
                                        : Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              DetailsWidget(
                                                locationData: _locationData,
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              MaterialButton(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10, horizontal: 20),
                                                  color: Colors.transparent,
                                                  disabledColor: Colors.transparent,
                                                  shape: RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: Theme.of(context)
                                                              .primaryColor,
                                                          width: 2),
                                                      borderRadius:
                                                          BorderRadius.circular(5)),
                                                  child: Text(
                                                    "Refresh",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline1,
                                                  ),
                                                  onPressed: () {
                                                    getLocation();
                                                    setState(() {});
                                                  }),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  MaterialButton(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: 10, horizontal: 20),
                                                      color: Colors.transparent,
                                                      disabledColor: Colors.transparent,
                                                      shape: RoundedRectangleBorder(
                                                          side: BorderSide(
                                                              color: Theme.of(context)
                                                                  .primaryColor,
                                                              width: 2),
                                                          borderRadius:
                                                          BorderRadius.circular(5)),

                                                      child: Icon(Icons.share,color: Theme.of(context).primaryColor,),
                                                      onPressed: () {
                                                        String shareString="""Hi,here's my location,\nLatitude: ${_locationData!.latitude},\nLongitude: ${_locationData!.longitude},\nAccuracy: ${_locationData!.accuracy} meter""";
                                                        Share.share(shareString,subject: "My Location");
                                                      }),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  MaterialButton(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: 10, horizontal: 20),
                                                      color: Colors.transparent,
                                                      disabledColor: Colors.transparent,
                                                      shape: RoundedRectangleBorder(
                                                          side: BorderSide(
                                                              color: Theme.of(context)
                                                                  .primaryColor,
                                                              width: 2),
                                                          borderRadius:
                                                          BorderRadius.circular(5)),
                                                      child: Icon(Icons.location_on,color: Theme.of(context).primaryColor,),
                                                      onPressed: () async{
                                                        String shareString="https://www.google.com/search?q=${_locationData!.latitude}%2C${_locationData!.longitude}";
                                                        // Share.share(shareString,);
                                                        try{
                                                          await launch(shareString);
                                                        }catch(e){
                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An error occurred")));
                                                        }
                                                      }),
                                                ],
                                              )
                                            ],
                                          ))));
              },
            ),
          ),
        ],
      );
    });
  }

  void showCustomBottomSheet(BuildContext context, BoxConstraints size) {
    showModalBottomSheet(
        enableDrag: true,
        backgroundColor: Theme.of(context).backgroundColor,
        shape: RoundedRectangleBorder(
            // side: BorderSide(color:Theme.of(context).primaryColor,width: 3),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (context) {
          return Container(
              padding: EdgeInsets.all(10),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.maxFinite,
                      child: Text("Notes",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 25)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: double.maxFinite,
                        child: Text(
                          "Latitude and Longitude are in degrees.",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(fontSize: 18),
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                        width: double.maxFinite,
                        child: Text(
                          "Altitude is in meters above the WGS 84 reference ellipsoid.",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(fontSize: 18),
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                        width: double.maxFinite,
                        child: Text(
                          "Accuracy is the estimated horizontal accuracy of the location, radial, in meters.",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(fontSize: 18),
                        )),
                  ],
                ),
              ));
        });
  }
}

class DetailsWidget extends StatefulWidget {
  final LocationData? locationData;
  DetailsWidget({
    Key? key,
    @required this.locationData,
  }) : super(key: key);

  @override
  _DetailsWidgetState createState() => _DetailsWidgetState();
}

class _DetailsWidgetState extends State<DetailsWidget> {
  double _height = 20;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      return Container(
        width: size.maxWidth * 0.9,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 3, color: Theme.of(context).primaryColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Latitude",
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(
                  height: _height,
                ),
                Text(
                  "Longitude",
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(
                  height: _height,
                ),
                Text(
                  "Altitude",
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(
                  height: _height,
                ),
                Text(
                  "Accuracy",
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(
                  height: _height,
                ),
                Text(
                  "Vertical accuracy",
                  style: Theme.of(context).textTheme.headline1,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "${widget.locationData!.latitude}",
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(
                  height: _height,
                ),
                Text(
                  "${widget.locationData!.longitude}",
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(
                  height: _height,
                ),
                Text(
                  "${widget.locationData!.altitude?.toStringAsFixed(7)}",
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(
                  height: _height,
                ),
                Text(
                  "${widget.locationData!.accuracy?.toStringAsFixed(7)}",
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(
                  height: _height,
                ),
                Text(
                  "${widget.locationData!.verticalAccuracy?.toStringAsFixed(7)}",
                  style: Theme.of(context).textTheme.headline1,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
