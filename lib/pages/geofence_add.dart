import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider_boilerplate/bloc/bloc_state.dart';
import 'package:setel_geofence/bloc/geofence.dart';

class GeofenceAddPage extends StatefulWidget {
  GeofenceAddPage({Key key}) : super(key: key);

  @override
  _GeofenceAddPageState createState() => _GeofenceAddPageState();
}

class _GeofenceAddPageState extends BlocState<GeofenceAddPage, GeofenceBloc> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController radiusController = TextEditingController();
  TextEditingController wifiNameController = TextEditingController();
  TextEditingController wifiBSSIDController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Geofence"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "action_geofence",
        onPressed: () => bloc.addGeofence(formKey),
        label: Text("Add"),
        icon: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16)
                .copyWith(bottom: 64, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text("Location",
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(fontWeight: FontWeight.bold))),
                    OutlineButton(
                      onPressed: () async {
                        Position position = await Geolocator()
                            .getCurrentPosition(
                                desiredAccuracy: LocationAccuracy.high);

                        latitudeController.text = "${position.latitude}";
                        longitudeController.text = "${position.longitude}";
                      },
                      child: Text("Using Current GPS"),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: buildTextField(
                        label: "Latitude",
                        controller: latitudeController,
                        validator: bloc.latitudeValidator,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: buildTextField(
                        label: "Longitude",
                        controller: longitudeController,
                        validator: bloc.longitudeValidator,
                        keyboardType: TextInputType.number,
                      ),
                    )
                  ],
                ),
                buildTextField(
                  label: "Radius",
                  controller: radiusController,
                  validator: bloc.radiusValidator,
                  keyboardType: TextInputType.number,
                ),
                Divider(
                  height: 32,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text("WiFi",
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(fontWeight: FontWeight.bold))),
                    OutlineButton(
                      onPressed: () async {
                        String wifiBSSID =
                            await (Connectivity().getWifiBSSID());
                        String wifiName = await (Connectivity().getWifiName());
                        wifiNameController.text = wifiName;
                        wifiBSSIDController.text = wifiBSSID;
                      },
                      child: Text("From connected WiFI"),
                    )
                  ],
                ),
                buildTextField(
                  label: "Name",
                  controller: wifiNameController,
                  validator: bloc.wifiNameValidator,
                  keyboardType: TextInputType.text,
                ),
                buildTextField(
                  label: "BSSID",
                  controller: wifiBSSIDController,
                  validator: bloc.bssidValidator,
                  keyboardType: TextInputType.text,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    String label,
    Function validator,
    TextInputType keyboardType,
    TextEditingController controller,
  }) {
    return Container(
      padding: EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }
}
