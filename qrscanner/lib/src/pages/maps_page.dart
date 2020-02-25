import 'package:flutter/material.dart';
import 'package:qrscanner/src/pages/bloc/scans_bloc.dart';
import 'package:qrscanner/src/pages/providers/db_provider.dart';
import 'package:qrscanner/src/pages/utils/utils.dart' as utils;
class MapsPage extends StatelessWidget {
  final scansBloc = new ScansBloc();
  @override
  Widget build(BuildContext context) {
    scansBloc.getScans();
    return StreamBuilder<List<ScanModel>>(
        stream: scansBloc.scansStream,
        builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot){
          if (!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }
          final scans = snapshot.data;

          print(scans.toString());

          if (scans.length == 0){
            return Center(
              child: Text('There is not information'),
            );
          }else{
            return ListView.builder(
                itemBuilder: (context, i) => Dismissible(
                    key: UniqueKey(),
                    background: Container( color: Colors.red),
                    onDismissed: (direction) => scansBloc.deleteScan(scans[i].id) ,
                    child: ListTile(
                      onTap: ()=>utils.openScan(context,scans[i]),
                      leading : Icon (Icons.cloud_queue, color: Theme.of(context).primaryColor,),
                      title: Text(scans[i].value),
                      subtitle: Text('ID: ${scans[i].id}'),
                      trailing: Icon (Icons.keyboard_arrow_right, color: Colors.grey),
                    ),
                ),
                itemCount: scans.length,
            );
          }
        }
    );
  }
}
