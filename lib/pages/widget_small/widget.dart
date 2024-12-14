
import 'package:flutter/material.dart';
import 'package:music_app/core/size/size.dart';

import '../../core/assets.dart';
import '../../core/colors/color.dart';

void customShowBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ),
    ),
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        height: context.height*0.31,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ListTile(
            //   leading: Icon(Icons.block),
            //   title: Text('Chặn'),
            //   onTap: () {
            //     Navigator.pop(context);
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.delete),
            //   title: Text('Xóa lịch sử trò chuyện'),
            //   onTap: () {
            //     Navigator.pop(context);
            //   },
            // ),
            // Divider(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: context.width*0.3),
              height: 5,
              width: context.width*0.3,decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Styles.grey
            ),),
            ListTile(
              title: const Text('Trong 1 giờ'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Trong 4 giờ'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Đến 8 giờ sáng'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Cho đến khi được mở lại'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}


void customShowReportSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isScrollControlled: true,
    builder: (context) {
      return SizedBox(
          height: context.height*0.75,
          child: const ReportSheet());
    },
  );
}

class ReportSheet extends StatefulWidget {
  const ReportSheet({super.key});

  @override
  _ReportSheetState createState() => _ReportSheetState();
}

class _ReportSheetState extends State<ReportSheet> {
  String? _selectedIssue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: context.width*0.3,vertical: 10),
            height: 5,
            width: context.width*0.3,decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Styles.grey
          ),),
          const Text(
            'Chọn vấn đề bạn muốn báo cáo',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          const Text(
            'Nếu cho rằng đoạn chat này vi phạm nguyên tắc cộng đồng của chúng tôi, bạn có thể báo cáo với chúng tôi. Tài khoản đó sẽ không biết là bạn đã gửi báo cáo này.',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 20),
          _buildRadioOption('Biểu tượng hoặc ngôn từ gây thù ghét'),
          _buildRadioOption('Lừa đảo hoặc gian lận'),
          _buildRadioOption('Bạo lực hoặc tổ chức nguy hiểm'),
          _buildRadioOption('Bán hàng hóa phi pháp hoặc thuốc điện kiểm soát'),
          _buildRadioOption('Giả mạo người khác'),
          _buildRadioOption('Spam'),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 10),
              margin: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(10)),),
              child:  const Text('Báo xấu',style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String title) {
    return RadioListTile<String>(
      title: Text(title),
      value: title,
      groupValue: _selectedIssue,
      onChanged: (value) {
        setState(() {
          _selectedIssue = value;
        });
      },
    );
  }
}


void customShowBlockSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isScrollControlled: true,
    builder: (context) {
      return const BlockSheet();
    },
  );
}

class BlockSheet extends StatelessWidget {
  const BlockSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: context.width*0.3,vertical: 10),
            height: 5,
            width: context.width*0.2,decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Styles.grey
          ),),
          const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(Asset.bgImageAvatar), // Hình đại diện
          ),
          const SizedBox(height: 10),
          const Text(
            'Chặn Martha Craig',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 10),
          const Text(
            'Hành động này cũng chặn mọi tài khoản khác mà họ có thể đang sở hữu hoặc sẽ tạo trong tương lai.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            icon: Icons.block,
            text: 'Họ sẽ không thể nhắn tin hay tìm được trang cá nhân/nội dung của bạn trên YouTextile',
          ),
          const SizedBox(height: 10),
          _buildInfoRow(
            icon: Icons.notifications_off,
            text: 'Họ sẽ không được thông báo là bạn đã chặn họ',
          ),
          const SizedBox(height: 10),
          _buildInfoRow(
            icon: Icons.settings,
            text: 'Bạn có thể bỏ chặn họ bất cứ lúc nào trong phần cài đặt',
          ),
          const SizedBox(height: 30),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 10),
              margin: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(10)),),
              child:  const Text('Chặn',style: TextStyle(color: Colors.white),),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}