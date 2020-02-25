import 'dart:async';

import 'package:qrscanner/src/pages/models/scan_model.dart';

class Validators{
  final validateGeo = StreamTransformer<List<ScanModel>,List<ScanModel>>.fromHandlers(
    handleData: (scans, sink){
      final geoScans = scans.where((s) => s.type == 'geo').toList();
      sink.add(geoScans);
    }
  );

  final validateHttp = StreamTransformer<List<ScanModel>,List<ScanModel>>.fromHandlers(
      handleData: (scans, sink){
        final httpScans = scans.where((s) => s.type == 'http').toList();
        sink.add(httpScans);
      }
  );
}