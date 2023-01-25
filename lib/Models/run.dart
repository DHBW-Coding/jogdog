// Class used for accessing data of runs
class Run {
  Duration duration;
  double avgSpeed;
  double maxDeviation;
  DateTime date;
  DateTime timestampstart;

  Run(this.duration, this.avgSpeed, this.maxDeviation, this.date,
      this.timestampstart);
}
