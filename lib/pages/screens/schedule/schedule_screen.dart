import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_app/core/colors/color.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';

import 'add_schedule/add_schedule_screen.dart';
class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Center(
              child: Text("Schedule",style: context.theme.textTheme.headlineLarge?.copyWith(color: Styles.blueIcon,fontWeight: FontWeight.bold,fontSize: 26),),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>const AddScheduleScreen(),));
              },
              child: const Icon(Icons.add_circle_outline),
            )
          ],
        ),
      ),
      body:  StreamBuilder<QuerySnapshot>(
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
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Các ngày trong tuần
                      const Text(
                        "Days of the Week:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (data['selectedDays'] as List<dynamic>?)
                            ?.join(', ') ??
                            'No days selected',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 8),

                      // Ngày tạo
                      const Text(
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
                        style: const TextStyle(
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
  Container customSchedule(BuildContext context,String title,String content){
    return Container(
      padding:EdgeInsets.all(Styles.defaultPadding/2),
      margin: EdgeInsets.only(bottom:Styles.defaultPadding),
      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: Styles.greyLight,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.query_builder,),
          SizedBox(height: context.height*.01,),
          SizedBox(width: context.width*.85,child: Text(title,style: context.theme.textTheme.headlineSmall,)),
          SizedBox(height: context.height*.005,),
          SizedBox(width: context.width*.85,child: Text(content,style: context.theme.textTheme.titleMedium?.copyWith(
              color: Styles.dark.withOpacity(0.8)
          ),))
        ],
      ),
    );
  }
}
