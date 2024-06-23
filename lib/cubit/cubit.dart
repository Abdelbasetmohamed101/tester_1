import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tester_1/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitial());
  static AppCubit get(context) => BlocProvider.of(context);

  bool powerState = true;
  int sensorReading1 = 10;
  int sensorReading2 = 0;
  int sensorReading3 = 0;
  String vehicleDirection = 'forward';
  final dataBase = FirebaseDatabase.instance.ref();

  void getData() {
    emit(DataGetting());
    dataBase.child('System').once().then((DatabaseEvent event) {
      final snap = event.snapshot;
      if (snap.value != null && snap.value is Map) {
        final data = snap.value as Map;
        sensorReading1 = data['sensor_1'] as int? ?? sensorReading1;
        sensorReading2 = data['sensor_2'] as int? ?? sensorReading2;
        sensorReading3 = data['sensor_3'] as int? ?? sensorReading3;
        powerState = data['power_button'] == 1;
        vehicleDirection =
            data['vehicle_direction'] as String? ?? vehicleDirection;
        emit(DataGot());
      }
    }).catchError((error) {
      emit(DataError(error.toString()));
    });

    dataBase.child('System').onChildChanged.listen((event) {
      final snap = event.snapshot;
      _updateSensorData(snap);
      emit(DataGot());
    }, onError: (error) {
      emit(DataError(error.toString()));
    });
  }

  void _updateSensorData(DataSnapshot snap) {
    if (snap.key == 'sensor_1') {
      sensorReading1 = snap.value as int? ?? sensorReading1;
    } else if (snap.key == 'sensor_2') {
      sensorReading2 = snap.value as int? ?? sensorReading2;
    } else if (snap.key == 'sensor_3') {
      sensorReading3 = snap.value as int? ?? sensorReading3;
    } else if (snap.key == 'power_button') {
      powerState = snap.value == 1;
    } else if (snap.key == 'vehicle_direction') {
      vehicleDirection = snap.value as String? ?? vehicleDirection;
    }
  }

  void updateVehicleDirection(String direction) {
    dataBase.child('System').update({
      'vehicle_direction': direction,
    }).then((_) {
      emit(DataUpdated());
    }).catchError((error) {
      emit(DataError(error.toString()));
    });
  }
}
