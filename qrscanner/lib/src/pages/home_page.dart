import 'package:flutter/material.dart';
import 'package:qrscanner/src/pages/bloc/scans_bloc.dart';
import 'package:qrscanner/src/pages/directions_page.dart';
import 'package:qrscanner/src/pages/maps_page.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:qrscanner/src/pages/models/scan_model.dart';
import 'package:qrscanner/src/pages/providers/db_provider.dart';
import 'package:qrscanner/src/pages/utils/utils.dart' as utils;

import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = new ScansBloc();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.deleteAllScans,
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _createBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: _scanQR,
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _scanQR ()async{
    String futureString = '';
    try{
      futureString = await BarcodeScanner.scan();
    }catch(e){
      futureString = e.toString();
    }


    if (futureString != null){
      final scan = ScanModel(value: futureString);
      scansBloc.addScan(scan);
      utils.openScan(context, scan);
    }
  }

  Widget _callPage(int actualPage){
    switch(actualPage ){
      case 0: return MapsPage();
      case 1: return DirectionsPage();

      default:
        return MapsPage();
    }
  }

  Widget _createBottomNavigationBar(){

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index){
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Maps')
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.swap_calls),
            title: Text('Directions')
        ),
      ],
    );
  }
}
