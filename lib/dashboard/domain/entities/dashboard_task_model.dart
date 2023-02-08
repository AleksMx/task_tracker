enum DashboardTaskState {
  toDo,
  inProgress,
  done
}

extension ParseToString on DashboardTaskState {
  String toShortString() {
    return toString().split('.').last;
  }

  int toIndex() {
    switch(this) {
      case DashboardTaskState.toDo:
        return 0;
      case DashboardTaskState.inProgress:
        return 1;
      case DashboardTaskState.done:
        return 2;
    }
  }

  DashboardTaskState? fromIndex(int index) {
    switch(index) {
      case 0: return DashboardTaskState.toDo;
      case 1: return DashboardTaskState.inProgress;
      case 2: return DashboardTaskState.done;
    }
    return null;
  }
}

class DashboardTaskWorkModel {
  final int startTime;
  final int endTime;

  DashboardTaskWorkModel({
    required this.startTime,
    required this.endTime
  });

  static fromJSON(obj) {
    return DashboardTaskWorkModel(
      startTime: obj['startTime'],
      endTime: obj['endTime']
    );
  }
}

class DashboardTaskModel {
  final int id;
  final String title;
  final DashboardTaskState state;
  final List<DashboardTaskWorkModel> works;

  DashboardTaskModel({
    required this.id,
    required this.title,
    required this.state,
    required this.works
  });

  static fromJSON(obj) {
    List<dynamic> worksData = obj['works'];
    List<DashboardTaskWorkModel> works = worksData.map<DashboardTaskWorkModel>((obj) {
      return DashboardTaskWorkModel.fromJSON(obj);
    }).toList();

    return DashboardTaskModel(
      id: obj['id'],
      title: obj['title'],
      state: DashboardTaskState.done.fromIndex(obj['state'])!,
      works: works
    );
  }
}