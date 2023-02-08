import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/dashboard/presentation/pages/dashboardViewTask/logic/dashboard_view_task_cubit.dart';

import 'dashboard_view_task_works.dart';

class DashboardViewTaskWait extends StatelessWidget {
  const DashboardViewTaskWait({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var logic = context.read<DashboardViewTaskCubit>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: DashboardViewTaskWorks()
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: getStartButton(logic)
        )
      ]
    );
  }

  Widget getStartButton(DashboardViewTaskCubit logic) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 14),
      shadowColor: Colors.transparent,
    );

    return Container(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 60,
        child: ElevatedButton(
          style: style,
          onPressed: () {
            logic.startTask();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             const Icon(CupertinoIcons.play),
             Container(
               margin: const EdgeInsets.only(left: 5),
               child: Text('dashboard.startTask'.tr(), style: const TextStyle(fontSize: 16))
             )
            ]
          )
        )
      ),
    );
  }

}