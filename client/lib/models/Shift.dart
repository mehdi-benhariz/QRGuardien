class Shift {
  final DateTime date;
  final String worker;
  final bool done;

  Shift(this.date, this.worker, this.done);
  Shift.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        worker = json['worker'],
        done = json['done'];

  Map<String, dynamic> toJson() =>
      {'date': date, 'worker': worker, 'done': done};
}
