import 'package:flutter/material.dart';

import '../../../../core/assets.dart';
import '../../../../core/colors/color.dart';
import '../update_account_screen/update_account_screen.dart';
class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin cá nhân'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_outlined, color: Colors.black),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder:  (context) => const UpdateAccountScreen(),));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Avatar and change button
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(Asset.bgImageAvatar), // Replace with your image asset
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Đổi ảnh đại diện'),
              ),
              const SizedBox(height: 20),

              // Personal Info Section
              InfoSection(
                title: 'Giới thiệu về bạn',
                items: [
                  InfoItem(
                    label: 'Tên tài khoản',
                    value: 'phanhien.123',
                    onTap: () {
                      // Handle tap
                    },
                  ),
                  InfoItem(
                    label: 'Sinh nhật',
                    value: '12/12/2003',
                    onTap: () {
                      // Handle tap
                    },
                  ),
                  InfoItem(
                    label: 'Giới tính',
                    value: 'Khác',
                    onTap: () {
                      // Handle tap
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Account Info Section
              InfoSection(
                title: 'Thông tin tài khoản',
                items: [
                  InfoItem(
                    label: 'Số điện thoại',
                    value: '0931231232',
                    onTap: () {
                      // Handle tap
                    },
                  ),
                  InfoItem(
                    label: 'Email',
                    value: 'phanhien@gmail.com',
                    onTap: () {
                      // Handle tap
                    },
                  ),
                  InfoItem(
                    label: 'Mật khẩu',
                    value: 'Thêm',
                    onTap: () {
                      // Handle tap
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoSection extends StatelessWidget {
  final String title;
  final List<InfoItem> items;

  const InfoSection({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: Styles.grey
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }
}

class InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const InfoItem({super.key, required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Styles.grey
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: onTap,
    );
  }
}