import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_tracker/dashboard/domain/entities/dashboard_task_model.dart';
import 'package:task_tracker/services/LocalizationService.dart';
import 'package:task_tracker/utils/utils.dart';

class DashboardViewTaskWorksItem extends StatelessWidget {
  final DashboardTaskWorkModel work;

  const DashboardViewTaskWorksItem({Key? key, required this.work}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.all(Radius.circular(10))
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          Expanded(child: Text(getStartTime())),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 5),
            child: Text(getWorkTime())
          )
        ]
      )
    );
  }

  String getStartTime() {
    DateTime dtNow = DateTime.now();
    var eventTimeDt = DateTime.fromMillisecondsSinceEpoch(work.startTime * 1000);
    return Utils.formatSmartTime(dtNow, eventTimeDt);
  }

  String getFinishTime() {
    var eventTimeDt = DateTime.fromMillisecondsSinceEpoch(work.endTime * 1000);
    return DateFormat.jm(LocalizationService.getCurrentDateLocale()).format(eventTimeDt);
  }

  String getWorkTime() {
    int workTime = work.endTime - work.startTime;
    return Utils.formatTimeToFinishEx(workTime);
  }
}