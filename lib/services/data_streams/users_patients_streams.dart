
import 'package:hemospectra/services/database/patient_database_helper.dart';

import 'data_stream.dart';

class UsersPatientsStream extends DataStream<List<String>> {
  @override
  void reload() {
    final usersPatientsFuture = PatientDatabaseHelper().usersPatientsList;
    usersPatientsFuture.then((data) {
      addData(data);
    }).catchError((e) {
      addError(e);
    });
  }
}
