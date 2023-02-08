import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/dashboard/presentation/pages/dashboardViewTask/logic/dashboard_view_task_cubit.dart';
import 'package:task_tracker/utils/utils.dart';


class DashboardViewTaskPlaying extends StatelessWidget {
  const DashboardViewTaskPlaying({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var logic = context.read<DashboardViewTaskCubit>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: getInfoArea(logic)
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: getStopButton(context, logic)
        )
      ]
    );
  }

  Widget getInfoArea(DashboardViewTaskCubit logic) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        logic.lastTimeFromStart!,
        style: const TextStyle(fontSize: 24, color: Colors.blueAccent)
      )
    );
  }

  Widget getStopButton(BuildContext context, DashboardViewTaskCubit logic) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 14),
      shadowColor: Colors.transparent,
    );

    return SizedBox(
      height: 60,
      child: ElevatedButton(
        style: style,
        onPressed: () {
          logic.stopTask(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           const Icon(CupertinoIcons.play),
           Container(
             margin: const EdgeInsets.only(left: 5),
             child: Text('dashboard.stopTask'.tr(), style: const TextStyle(fontSize: 16))
           )
          ]
        )
      )
    );
  }

}