class JobInfo {
  static final JobInfo _instance = JobInfo._internal();

  factory JobInfo() => _instance;

  JobInfo._internal();

  String jobNo = '';
  String endUserCode = '';
}
