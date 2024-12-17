import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';

import '../../../../core/assets.dart';
import '../../../../core/colors/color.dart';
import '../../../widget_small/widget_music.dart';
class RecentPlayedScreen extends StatefulWidget {
  const RecentPlayedScreen({super.key});

  @override
  State<RecentPlayedScreen> createState() => _RecentPlayedScreenState();
}

class _RecentPlayedScreenState extends State<RecentPlayedScreen> {
  bool isCheck=false;
  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('hh:mm a').format(dateTime); // dd/MM/yyyy hh:mm AM/PM
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },child: const Icon(Icons.keyboard_arrow_down),
        ),
        title: Center(child: Text(
          "Recent played",style: context.theme.textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        ),),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.more_horiz),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Styles.defaultPadding),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isCheck=!isCheck;
                      });
                    },
                    child: Column(
                      children: [
                        Text('Songs',style: context.theme.textTheme.headlineMedium?.copyWith(
                            color: isCheck==false?Styles.dark:Styles.grey
                        ),),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          height: context.height*0.003,
                          width: context.width*0.15,
                          decoration: BoxDecoration(
                              color:isCheck==false?Styles.blueIcon:Styles.light,
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: context.width*0.06,),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isCheck=!isCheck;
                      });
                    },
                    child: Column(
                      children: [
                        Text('Album',style: context.theme.textTheme.headlineMedium?.copyWith(
                            color: isCheck==true?Styles.dark:Styles.grey
                        ),),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          height: context.height*0.003,
                          width: context.width*0.15,
                          decoration: BoxDecoration(
                              color:isCheck==true?Styles.blueIcon:Styles.light,
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.height*0.02,),
              Row(
                children: [
                  const Spacer(),
                  const Icon(Icons.search),
                  SizedBox(width: context.width*0.02,),
                  const Icon(Icons.checklist),
                ],
              ),
              SizedBox(height: context.height*0.02,),
              SizedBox(
                height: context.height * 0.8,
                width: context.width,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('db_listening_history')
                      .where('user_id', isEqualTo: "hafqF9xuWgXLQ9keqCmembit2L43")
                      .orderBy('timestamp', descending: true)
                      // .limit(4)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final history = snapshot.data!.docs;

                    if (history.isEmpty) {
                      return const Center(child: Text('Bạn chưa nghe bài hát nào.'));
                    }

                    return ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final song = history[index];
                        String formattedTimestamp =
                        song['timestamp'] != null
                            ? formatTimestamp(song['timestamp'])
                            : "No timestamp";
                        return Container(
                          margin: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4.0,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading:Container(
                              width: context.height * 0.1,
                              height: context.height * 0.1,
                              margin: const EdgeInsets.only(
                                  right: 10, top: 10),
                              alignment: Alignment.bottomRight,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(8)),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      song['image_url']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(song['title']??""),
                            subtitle: Text(song['artist']??""),
                            trailing: Text(formattedTimestamp),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}