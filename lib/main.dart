import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tester_1/cubit/cubit.dart';
import 'package:tester_1/cubit/states.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tester 1',
      home: BlocProvider(
        create: (context) => AppCubit()..getData(),
        child: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    ControlPage(),
    StatisticsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tester 1'),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.control_camera),
            label: 'Control',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Statistics',
          ),
        ],
      ),
    );
  }
}

class ControlPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tester 1', style: TextStyle(fontSize: 24)),
            JoystickWidget(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                cubit.updateVehicleDirection(cubit.vehicleDirection == 'forward'
                    ? 'backward'
                    : 'forward');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: cubit.powerState ? Colors.green : Colors.red,
              ),
              child: Text(
                cubit.powerState ? 'Power is ON' : 'Power is OFF',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}

class JoystickWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replace this placeholder widget with your actual joystick implementation
    return Container(
      height: 200,
      width: 200,
      child: Center(child: Text('Joystick Placeholder')),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
    );
  }
}

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sensor 1: ${cubit.sensorReading1}',
                  style: TextStyle(fontSize: 18)),
              Text('Sensor 2: ${cubit.sensorReading2}',
                  style: TextStyle(fontSize: 18)),
              Text('Sensor 3: ${cubit.sensorReading3}',
                  style: TextStyle(fontSize: 18)),
              Text('Vehicle Direction: ${cubit.vehicleDirection}',
                  style: TextStyle(fontSize: 18)),
              Text('Power State: ${cubit.powerState ? "On" : "Off"}',
                  style: TextStyle(fontSize: 18)),
            ],
          ),
        );
      },
    );
  }
}
