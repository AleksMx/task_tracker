import 'package:appflowy_board/appflowy_board.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/dashboard/domain/entities/dashboard_task_model.dart';
import 'package:task_tracker/dashboard/presentation/pages/dashboard/logic/dashboard_screen_cubit.dart';

import 'dashboard_widget_item.dart';
import 'daskboard_widget_add_task_button.dart';

class DashboardWidget extends StatelessWidget {
  const DashboardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var logic = context.read<DashboardScreenCubit>();

    return AppFlowyBoard(
      controller: logic.boardController,
      boardScrollController: logic.boardScrollController,
      config: AppFlowyBoardConfig(
        groupBackgroundColor: Colors.grey[100]!,
        cardPadding: const EdgeInsets.all(0),
        groupPadding: const EdgeInsets.symmetric(horizontal: 10),
        groupItemPadding: const EdgeInsets.symmetric(horizontal: 10)
      ),
      headerBuilder: (context, AppFlowyGroupData groupData) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: getHeaderArea(groupData)
        );
      },
      cardBuilder: getCardArea,
      footerBuilder: getFooterArea,
      groupConstraints: const BoxConstraints.tightFor(width: 170),
    );
  }

  Widget getHeaderArea(AppFlowyGroupData groupData) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.2),
        borderRadius: const BorderRadius.all(Radius.circular(5))
      ),
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(groupData.id.toString(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.green))
    );
  }

  Widget getFooterArea(context, AppFlowyGroupData groupData) {
    DashboardTaskState dashboardTaskState = groupData.customData['state'] as DashboardTaskState;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: DashboardWidgetAddTaskButton(dashboardTaskState: dashboardTaskState)
    );
  }

  Widget getCardArea(context, group, groupItem) {
    final textItem = groupItem as TextItem;

    return AppFlowyGroupCard(
      key: ObjectKey(textItem),
      decoration: const BoxDecoration(
        color: Colors.transparent
      ),
      child: SizedBox(
        width: double.infinity,
        child: DashboardWidgetItem(textItem: textItem)
      )
    );
  }
}