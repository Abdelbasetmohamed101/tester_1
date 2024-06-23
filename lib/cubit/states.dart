abstract class AppStates {}

class AppInitial extends AppStates {}

class DataGetting extends AppStates {}

class DataGot extends AppStates {}

class LedPressed extends AppStates {}

class LedChanged extends AppStates {}

class DataUpdated extends AppStates {}

class DataError extends AppStates {
  DataError(String string);
  var error;
}
