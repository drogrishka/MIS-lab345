import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lab3_test/Models/user.dart';
import 'package:lab3_test/Pages/authentication.dart';
import 'package:lab3_test/Pages/calendar_page.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'Models/directions_model.dart';
import 'Models/list_item.dart';
import 'Pages/login_page.dart';
import 'Widgets/nov_element.dart';
import 'directions_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<User>? _userItemsList;

  User? _user;

  void initState() {
    _userItemsList = [
      User(id: "T1", username: "ana", password: "ana", listItems: [
        ListItem(
          id: "T1",
          subject: "MIS",
          date: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 9, 0, 0),
          latitude: 37.779100,
          longitude: -122.439900,
        ),
        ListItem(
          id: "T2",
          subject: "VBS",
          date: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day, 9, 0, 0)
              .add(const Duration(days: 1, hours: 2)),
          latitude: 37.779600,
          longitude: -122.439100,
        ),
      ]),
    ];
    _user = _userItemsList?[0];
    super.initState();
  }

  void _addItemFunction(BuildContext ct) {
    showModalBottomSheet(
        context: ct,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              child: NovElement(_addNewItemToList),
              behavior: HitTestBehavior.opaque);
        });
  }

  void _addNewItemToList(ListItem item) {
    setState(() {
      _user?.listItems.add(item);
    });
  }

  void _deleteItem(String id) {
    setState(() {
      _user?.listItems.removeWhere((elem) => elem.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Subject is deleted from the calendar"),
        duration: Duration(seconds: 1),
      ),
    );
  }

  bool _login(String username, String password) {
    _user = null;
    _userItemsList?.forEach((element) {
      if (element.username == username && element.password == password) {
        setState(() {
          _user = element;
        });
      }
    });

    return (_user != null);
  }

  bool _addNewUserToList(User item) {
    setState(() {
      _userItemsList?.add(item);
    });
    _user = item;
    return (item != null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(""), actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginPage(login: _login))),
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AuthenticationPage(addItem: _addNewUserToList))),
            child: const Text(
              "Register",
              style: TextStyle(color: Colors.white),
            ),
          ),

          TextButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CalendarPage(list: _user!.listItems))),
            child: const Text(
              "Calendar",
              style: TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _addItemFunction(context),
          ),
        ]),

        body: Center(
          child: _user!.listItems.isEmpty
              ? Text('No elements')
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        child: ListTile(
                            title: Text(
                              _user!.listItems[index].subject,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text( 
                              "${_user!.listItems[index].date}\nlatitude: ${_user!.listItems[index].latitude}\nlongitude: ${_user!.listItems[index].longitude}",
                              style: TextStyle(
                                  color: Colors.grey.withOpacity(1.0)),
                            ),
                            trailing: Column(
                              children: [
                              
                                IconButton(
                                  icon: const Icon(Icons.location_on),
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MapScreen(latitude: _user!.listItems[index].latitude,longitude: _user!.listItems[index].longitude))),
                                ),
                                SizedBox(height: 5,),
                                //   IconButton(
                                //   icon: Icon(Icons.delete),
                                //   onPressed: () {
                                //     _deleteItem(_user!.listItems[index].id);
                                //   },
                                // ),
                              ],
                            )));
                  },
                  itemCount: _user!.listItems.length),
        ));
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.latitude, required this.longitude});
  final double latitude;
  final double longitude;

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: 11.5,
  );

  late GoogleMapController _googleMapController;
  late Marker _origin;
  late Marker _destination;
  Directions? _info;

  void initState() {
    _origin = Marker(
      markerId: const MarkerId('origin'),
      infoWindow: const InfoWindow(title: 'Origin'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      position: LatLng(37.773972, -122.431297),
    );
    _destination = Marker(
      markerId: const MarkerId('destination'),
      infoWindow: const InfoWindow(title: 'Destination'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      position: LatLng(37.779400, -122.439500),
    );
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Google Maps'),
        actions: [
          if (_origin != null)
            TextButton(
              onPressed: () => _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _origin.position,
                    zoom: 14.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.green,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('ORIGIN'),
            ),
          if (_destination != null)
            TextButton(
              onPressed: () => _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _destination.position,
                    zoom: 14.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.blue,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('DEST'),
            )
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _googleMapController = controller,
            markers: {
              if (_origin != null) _origin,
              if (_destination != null) _destination
            },
            polylines: {
              if (_info != null)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: Colors.red,
                  width: 5,
                  points: _info!.polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                ),
            },
            onLongPress: _addMarker,
          ),
          if (_info != null)
            Positioned(
              top: 20.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    )
                  ],
                ),
                child: Text(
                  '${_info!.totalDistance}, ${_info!.totalDuration}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () {
          _googleMapController.animateCamera(
            _info != null
                ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.0)
                : CameraUpdate.newCameraPosition(_initialCameraPosition),
          );
          _directions();
        },
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  void _directions() async {
    final directions = await DirectionsRepository().getDirections(
        origin: _origin.position, destination: _destination.position);
    setState(() => _info = directions);
  }

  void _addMarker(LatLng pos) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      // Origin is not set OR Origin/Destination are both set
      // Set origin
      setState(() {
        _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );
        // Reset destination
        // _destination = null;

        // // Reset info
        // _info = null;
      });
    } else {
      // Origin is already set
      // Set destination
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });

      // Get directions
      final directions = await DirectionsRepository()
          .getDirections(origin: _origin.position, destination: pos);
      setState(() => _info = directions);
    }
  }
}
