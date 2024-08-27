import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';

import '../../../../core/assets.dart';
import '../../../../core/colors/color.dart';
class GroupCreationScreen extends StatefulWidget {
  const GroupCreationScreen({super.key});

  @override
  State<GroupCreationScreen> createState() => _GroupCreationScreenState();
}

class _GroupCreationScreenState extends State<GroupCreationScreen> {
  void _showNewGroupModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const NewGroupModal(),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Hủy',
            style: TextStyle(color: Colors.blue),
          ),
        ),
        title: Text(
          'Tin nhắn mới',
          style: context.theme.textTheme.headlineLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.group_add, color: Colors.black),
              title: Text(
                'Tạo nhóm mới',
                style: context.theme.textTheme.headlineMedium,
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: context.theme.iconTheme.color),
              onTap: () {
                _showNewGroupModal(context);
              },
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            SizedBox(height: context.height*0.01),
            Text(
              'Gợi ý',
             style: context.theme.textTheme.headlineSmall,
            ),
            SizedBox(height: context.height*0.01),
            SizedBox(
              height: context.height*0.5,
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    leading: const CircleAvatar(
                        backgroundImage: AssetImage(Asset.bgImageAvatar) ),
                    title: Text(
                      'Ung Sang',
                      style: context.theme.textTheme.headlineSmall,
                    ),
                    onTap: () {
                      // Add user selection functionality here
                    },
                  ),
                );
              },),
            ),
          ],
        ),
      ),
    );
  }
}
class NewGroupModal extends StatelessWidget {
  const NewGroupModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Hủy',
                  style: context.theme.textTheme.headlineSmall?.copyWith(
                    color: Styles.blueIcon
                  ),
                ),
              ),
              Text('Nhóm mới',
                style: context.theme.textTheme.headlineMedium,
              ),
              TextButton(
                onPressed: () {
                  // Add create group functionality here
                },
                child: Text('Tạo',
                  style: context.theme.textTheme.headlineSmall?.copyWith(
                      color: Styles.blueIcon
                  ),),
              ),
            ],
          ),
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              fillColor: Colors.grey[200],
              filled: true,
            ),
          ),
          const SizedBox(height: 10),
          const ListTile(
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage:AssetImage(
                    Asset.bgImageAvatar
                  )
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Styles.blueIcon,
                    child: Icon(Icons.close,color: Styles.light, size: 13),
                  ),
                ),
              ],
            ),
            title: Text('Phan Hien'),
          ),
          const SizedBox(height: 10),
          Text('Gợi ý',style: context.theme.textTheme.headlineMedium,),
          ListTile(
            leading:  const CircleAvatar(
                radius: 20,
                backgroundImage:AssetImage(
                    Asset.bgImageAvatar
                )
            ),
            title: const Text('Phuong Vi'),
            trailing: const Icon(Icons.radio_button_unchecked),
            onTap: () {
              // Add select functionality here
            },
          ),
          ListTile(
            leading: const CircleAvatar(
                radius: 20,
                backgroundImage:AssetImage(
                    Asset.bgImageAvatar
                )
            ),
            title: const Text('Phan Hien'),
            trailing: const Icon(Icons.check_circle, color: Colors.blue),
            onTap: () {
              // Add select functionality here
            },
          ),
        ],
      ),
    );
  }
}