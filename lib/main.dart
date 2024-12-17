import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:music_app/pages/layout/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:music_app/pages/screens/musicplayerscreen/provider.dart';
import 'package:music_app/pages/screens/user_profile/playlist_screen/playlist%20_screen/provider.dart';
import 'package:music_app/pages/screens/user_profile/playlist_screen/provider.dart';
import 'package:music_app/themeprovider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  options:
  kIsWeb || Platform.isAndroid
      ? await Firebase.initializeApp(
          // name:"b-idea-b5e02",
          options: const FirebaseOptions(
              apiKey: 'AIzaSyCNbo2_xo8CEgU-c39RlIjyWQnj7HGDqNg',
              appId: '1:641383178154:android:cae2793a4aeaeb042215d3',
              messagingSenderId: '641383178154',
              projectId: 'academy-app-400f3',
              storageBucket: "academy-app-400f3.appspot.com"))
      : await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MusicPlayerProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PlaylistAddProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PlaylistProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: themeProvider.themeData,
        debugShowCheckedModeBanner: false,
        // home: const MusicScheduleListScreen(),
        // home: const MusicScheduleScreen(),
        home: const BottomNavigaBar(),
        // home: const SignIn(),
        // home: const IntroductionAnimationScreen(),
      );
    });
  }
}

class MusicScheduleListScreen extends StatefulWidget {
  const MusicScheduleListScreen({super.key});

  @override
  State<MusicScheduleListScreen> createState() =>
      _MusicScheduleListScreenState();
}

class _MusicScheduleListScreenState extends State<MusicScheduleListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Music Schedules"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('music_schedules')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No schedules available",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            );
          }

          final schedules = snapshot.data!.docs;

          return ListView.builder(
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final schedule = schedules[index];
              final data = schedule.data() as Map<String, dynamic>;

              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thời gian
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Time:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            data['time'] ?? '',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Tâm trạng
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Mood:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            data['mood'] ?? '',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Các ngày trong tuần
                      Text(
                        "Days of the Week:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (data['selectedDays'] as List<dynamic>?)?.join(', ') ??
                            'No days selected',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 8),

                      // Ngày tạo
                      Text(
                        "Created At:",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data['createdAt'] != null
                            ? (data['createdAt'] as Timestamp)
                                .toDate()
                                .toString()
                            : 'N/A',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MusicScheduleScreen extends StatefulWidget {
  const MusicScheduleScreen({super.key});

  @override
  State<MusicScheduleScreen> createState() => _MusicScheduleScreenState();
}

class _MusicScheduleScreenState extends State<MusicScheduleScreen> {
  String? selectedTime; // Thời gian được chọn
  String? selectedMood; // Tâm trạng được chọn

  // Danh sách các tâm trạng và các ngày trong tuần
  List<String> moods = ['Relaxed', 'Happy', 'Focused', 'Sad', 'Energetic'];
  Map<String, bool> daysOfWeek = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false,
  };

  // Hàm đẩy dữ liệu lên Firestore
  Future<void> uploadMusicSchedule() async {
    try {
      if (selectedTime == null || selectedMood == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Vui lòng chọn thời gian và tâm trạng!")),
        );
        return;
      }

      // Lọc ra các ngày được chọn
      List<String> selectedDays = daysOfWeek.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      // Tạo dữ liệu
      Map<String, dynamic> data = {
        'time': selectedTime,
        'selectedDays': selectedDays,
        'mood': selectedMood,
        'createdAt': Timestamp.now(),
      };

      // Đẩy lên Firestore
      await FirebaseFirestore.instance.collection('music_schedules').add(data);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Kế hoạch nghe nhạc đã được tạo thành công!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Music Schedule")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon ở giữa
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/icon_clock.png'),
                      // Thay bằng icon của bạn
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tiêu đề chính
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Every day and every week",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "This trigger fires on specific days of the week and fires daily at the time you provide.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ),
              const SizedBox(height: 24),

              // Chọn thời gian
              const Text('Time',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: selectedTime,
                  hint: const Text("Select Time"),
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: ['7:30 PM', '8:00 PM', '8:30 PM', '9:00 PM']
                      .map((time) => DropdownMenuItem(
                            value: time,
                            child: Text(time),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTime = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Chọn tâm trạng
              const Text('Mood',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: selectedMood,
                  hint: const Text("Select Mood"),
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: moods
                      .map((mood) => DropdownMenuItem(
                            value: mood,
                            child: Text(mood),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMood = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Chọn ngày trong tuần
              const Text('Days of the Week',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              ...daysOfWeek.keys.map((day) {
                return SwitchListTile(
                  title: Text(day),
                  value: daysOfWeek[day]!,
                  activeColor: Colors.blue,
                  onChanged: (bool value) {
                    setState(() {
                      daysOfWeek[day] = value;
                    });
                  },
                );
              }),

              const SizedBox(height: 24),

              // Nút "Create"
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: uploadMusicSchedule,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Create",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
