import 'dart:io';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:task_tracker/dashboard/domain/entities/dashboard_task_model.dart';
import 'package:task_tracker/utils/utils.dart';

import 'dashboard_repository.dart';

class ReportsRepository {
  static final ReportsRepository _singleton = ReportsRepository._internal();

  factory ReportsRepository() {
    return _singleton;
  }

  ReportsRepository._internal();

  Future<ReportsSaveResult?> downloadAndSaveReport() async {
    String fileName = 'report.txt';
    String tempPath = await _getDownloadPath();
    String filePath = '$tempPath/$fileName';

    String? report = await _formatCSVReport();
    if (report == null) {
      return null;
    }
    _writeFile(_convertStringToUint8List(report), filePath);

    return ReportsSaveResult(
      savedPath: filePath
    );
  }

  Future<String?> _formatCSVReport() async {
    List<DashboardTaskModel>? tasks = await DashboardRepository().getTasks();
    if (tasks == null) {
      return null;
    }

    List<List<dynamic>> reportItems = [];
    reportItems.add([
      'Task Id',
      'Title',
      'State',
      'Start time',
      'End time'
    ]);

    for (DashboardTaskModel task in tasks) {
      for (var work in task.works) {
        reportItems.add([
          task.id,
          task.title,
          task.state.toShortString(),
          DateTime.fromMillisecondsSinceEpoch(work.startTime * 1000).toIso8601String(),
          DateTime.fromMillisecondsSinceEpoch(work.endTime * 1000).toIso8601String()
        ]);
      }
    }

    return const ListToCsvConverter().convert(reportItems);
  }

  Uint8List _convertStringToUint8List(String str) {
    final List<int> codeUnits = str.codeUnits;
    final Uint8List unit8List = Uint8List.fromList(codeUnits);
    return unit8List;
  }

  Future<String> _getDownloadPath() async {
    Directory? directory;
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = Directory('/storage/emulated/0/Download');
      if (!(await directory.exists())) {
        directory = await getExternalStorageDirectory();
      }
    }
    return directory!.path;
  }

  void _writeFile(Uint8List data, String filePath) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    var bytes = ByteData.view(data.buffer);
    final buffer = bytes.buffer;
    File(filePath).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
}

class ReportsSaveResult {
  final String savedPath;

  ReportsSaveResult({
    required this.savedPath
  });
}