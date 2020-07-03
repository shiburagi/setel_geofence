import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider_boilerplate/bloc/base_bloc.dart';
import 'package:setel_geofence/resources/database.dart';

import '../entities/geofence.dart';

class GeofenceBloc extends BaseBloc<List<Geofence>> {
  retrieveData() async {
    List<Geofence> geofences = await AppDatabase.instance.getGeofences();
    sink.add(geofences);
  }

  Stream<List<Geofence>> startStream() {
    if (data == null) retrieveData();
    return stream;
  }

  Geofence _geofence;
  String bssidValidator(String value) {
    if (value.isEmpty) return "BSSID is required";

    _geofence.bssid = value;
    return null;
  }

  String wifiNameValidator(String value) {
    if (value.isEmpty) return "WIfI Name is required";

    _geofence.wifiName = value;
    return null;
  }

  String radiusValidator(String value) {
    if (value.isEmpty) return "Radius is required";
    _geofence.radius = double.tryParse(value);
    return null;
  }

  String latitudeValidator(String value) {
    if (value.isEmpty) return "Latitude is required";
    _geofence.latitude = double.tryParse(value);

    return null;
  }

  String longitudeValidator(String value) {
    if (value.isEmpty) return "Longitude is required";
    _geofence.longitude = double.tryParse(value);

    return null;
  }

  void addGeofence(GlobalKey<FormState> formKey) async {
    _geofence ??= Geofence();
    if (formKey.currentState.validate()) {
      if (await AppDatabase.instance.getGeofence(_geofence.bssid) != null) {
        showSimpleNotification(Text("BSSID already exist in the list."),
            background: Theme.of(context).errorColor);
        return;
      }
      await AppDatabase.instance.addGeofence(_geofence);
      formKey.currentState.reset();
      await retrieveData();
    }
  }

  delete(Geofence geofence) async {
    if (await AppDatabase.instance.deleteGeofence(geofence) > 0)
      await retrieveData();
  }
}