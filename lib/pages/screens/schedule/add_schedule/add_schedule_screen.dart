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
  Map<String, bool> daysOfWeek = {
    'Monday': true,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false,
  };

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
                "Lịch cá nhân",
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
                  color: Styles.greyLight, // Set the background color to white
                  borderRadius:
                      BorderRadius.circular(8.0), // Optional: Add border radius
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                // Add padding inside the container
                child: DropdownButton<String>(
                  value: selectedTime,
                  items: <String>['7:30 PM', '8:00 PM', '8:30 PM', '9:00 PM']
                      .map((String value) {
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
                  underline: SizedBox(),
                  // Removes the default underline
                  dropdownColor:
                      Colors.white, // Set the dropdown menu color to white
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RecommentPlaylistScreen(),
                        ));
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
