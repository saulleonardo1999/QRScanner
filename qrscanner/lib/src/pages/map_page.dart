import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrscanner/src/pages/models/scan_model.dart';
import 'package:latlong/latlong.dart';
class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final map = new MapController();

  String mapType = 'streets';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('QR Localization'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: (){
              map.move(scan.getLatLng(), 20);
            },
          )
        ]
      ),
      body: _createFlutterMap(scan),
      floatingActionButton: _createFloatingButton(context),
    );
  }

  Widget _createFlutterMap(ScanModel scan) {
    return FlutterMap(
        mapController: map,
        options: MapOptions(
          center: scan.getLatLng(),
          zoom: 15,
        ),
        layers: [
          _createMap(),
          _createMark(scan)
        ],
    );
  }

  _createMap(){
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
                   '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        'accessToken': 'pk.eyJ1Ijoic2F1bGxlb25hcmRvOTkiLCJhIjoiY2s3MjJvZmgzMDdsZTNsbzF5cWd6MXF3NCJ9.dL3pScR_TNroOvUisiDwVg',
        'id'         : 'mapbox.$mapType'
//        streets, dark, light, outdoors, satellite
      }
    );
  }

  _createMark(ScanModel scan) {
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: (context)=> Container(
            child: Icon(
              Icons.location_on,
              size: 45.0,
            color: Theme.of(context).primaryColor
          )
          )
        )
      ]
    );
  }

  Widget _createFloatingButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: (){
        if( mapType == 'streets' ){
          mapType = 'dark';
        }else if ( mapType == 'dark'){
          mapType = 'light';
        }else if ( mapType == 'light'){
          mapType = 'outdoors';
        }else if ( mapType == 'outdoors'){
          mapType = 'satellite';
        }else{
          mapType = 'streets';
        }
        setState((){});
      },
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,

    );

  }
}
