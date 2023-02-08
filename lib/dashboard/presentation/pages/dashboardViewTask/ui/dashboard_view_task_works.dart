import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/dashboard/domain/entities/dashboard_task_model.dart';
import 'package:task_tracker/dashboard/presentation/pages/dashboardViewTask/logic/dashboard_view_task_cubit.dart';

import 'dashboard_view_task_works_item.dart';

class DashboardViewTaskWorks extends StatelessWidget {
  const DashboardViewTaskWorks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var logic = context.read<DashboardViewTaskCubit>();
    List<DashboardTaskWorkModel> works = logic.dashboardTask.works;
    if (works.isEmpty) {
      return getEmptyArea();
    }

    List<Widget> rows = [];
    for (var work in works) {
      rows.add(Container(
        margin: EdgeInsets.only(top: rows.isEmpty?0:7),
        child: DashboardViewTaskWorksItem(work: work)
      ));
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: rows
      )
    );
  }

  Widget getEmptyArea() {
    return Center(
      child: Text('dashboardTaskView.emptyTitle'.tr())
    );
  }
}