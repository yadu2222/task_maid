// Taskモデルのクラス
class Task {
  // ID
  String taskid;
  // タイトル
  String title;
  // 詳細
  String contents;
  // 状態を定義
  int status;
  // 作成日時
  String taskLimit;
  // このタスクを管理している人たち
  // これなににつかってるの？
  // List leaders;
  // 労働者
  String worker;
  // タスクが属する部屋
  String roomid;

  // コンストラクタ
  Task(this.taskid, this.title, this.contents, this.status, this.taskLimit, this.worker, this.roomid);

  // Mapに変換する
  // 保存で使う
  Map<String,dynamic> toJson() {
    return {
      'task_id': taskid, 
      'task_limit': taskLimit,
      'status_progress': status, 
      'worker': worker, 
      'room_id': roomid, 
      'title': title, 
      'contents': contents};
  }
}
