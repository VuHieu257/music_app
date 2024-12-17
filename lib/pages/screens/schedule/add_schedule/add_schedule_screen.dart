import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_app/core/assets.dart';
import 'package:music_app/core/colors/color.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';
import 'package:music_app/pages/screens/schedule/recomment_playlist/recomment_playlist_screen.dart';

import '../../../widget_small/custom_button.dart';

class AddScheduleScreen extends StatefulWidget {
  const AddScheduleScreen({super.key});

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  String? selectedTime = '7:30 PM';
  String? selectedMood;

  Map<String, bool> daysOfWeek = {
    'Monday': true,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false,
  };
  List<String> moods = ['Relaxed', 'Happy', 'Focused', 'Sad', 'Energetic'];
  List<String> fullDayTimes = []; // Danh sách thời gian 24 giờ

  @override
  void initState() {
    super.initState();
    _generateFullDayTimes();
  }

  void _generateFullDayTimes() {
    for (int hour = 0; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        final formattedTime =
            '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
        fullDayTimes.add(formattedTime);
      }
    }
    setState(() {
      selectedTime = fullDayTimes.first;
    });
  }
  Future<void> uploadMusicSchedule() async {
    try {
      if (selectedTime == null || selectedMood == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Please choose the time and mood!")),
        );
        return;
      }

      // Lọc ra các ngày được chọn
      List<String> selectedDays = daysOfWeek.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      Map<String, dynamic> data = {
        'time': selectedTime,
        'selectedDays': selectedDays,
        'mood': selectedMood,
        'createdAt': Timestamp.now(),
      };

      await FirebaseFirestore.instance.collection('music_schedules').add(data);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("The music plan has been successfully created!")),
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
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios),
            ),
            const Spacer(),
            Center(
              child: Text(
                "Schedule",
                style: context.theme.textTheme.headlineLarge
                    ?.copyWith(fontWeight: FontWeight.w400),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Styles.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: context.height * 0.1,
                  width: context.height * .1,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(Asset.iconImageIconClock),
                          fit: BoxFit.cover)),
                ),
              ),
              Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Every day and every week",
                    style: context.theme.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                  )),
              SizedBox(
                height: context.height * 0.01,
              ),
              Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                      width: context.width * 0.85,
                      child: Text(
                        "This trigger fires on specific days of the week and fires daily at the time you provide.",
                        style: context.theme.textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ))),
              Text('Time',
                  style: context.theme.textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Set màu nền
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: DropdownButton<String>(
                  value: selectedTime,
                  items: fullDayTimes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTime = newValue;
                    });
                  },
                  isExpanded: true,
                  underline: const SizedBox(),
                  dropdownColor: Colors.white,
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     color: Styles.greyLight, // Set the background color to white
              //     borderRadius:
              //         BorderRadius.circular(8.0), // Optional: Add border radius
              //   ),
              //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
              //   // Add padding inside the container
              //   child: DropdownButton<String>(
              //     value: selectedTime,
              //     items: <String>['7:30 PM', '8:00 PM', '8:30 PM', '9:00 PM', '9:30 PM', '10:30 PM','11:00 PM','11:30 PM', '12:00 PM', '12:30 PM', '13:00 PM', '13:30 PM', '14:00 PM']
              //         .map((String value) {
              //       return DropdownMenuItem<String>(
              //         value: value,
              //         child: Text(value),
              //       );
              //     }).toList(),
              //     onChanged: (String? newValue) {
              //       setState(() {
              //         selectedTime = newValue;
              //       });
              //     },
              //     isExpanded: true,
              //     underline: const SizedBox(),
              //     // Removes the default underline
              //     dropdownColor:
              //         Colors.white, // Set the dropdown menu color to white
              //   ),
              // ),
              const SizedBox(height: 8),
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
              const SizedBox(height: 16),
              Text('Day of the week',
                  style: context.theme.textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              ...daysOfWeek.keys.map((String day) {
                return SwitchListTile(
                  activeTrackColor: Styles.blue,
                  title: Text(
                    day,
                    style: context.theme.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w400),
                  ),
                  value: daysOfWeek[day]!,
                  onChanged: (bool value) {
                    setState(() {
                      daysOfWeek[day] = value;
                    });
                  },
                );
              }),
              InkWell(
                  onTap: () {
                    uploadMusicSchedule();
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => const RecommentPlaylistScreen(),
                    //     ));
                  },
                  child: CusButton(
                    text: "Create",
                    color: Styles.blueIcon,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
