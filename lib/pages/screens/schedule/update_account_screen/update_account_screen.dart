import 'package:flutter/material.dart';
import 'package:music_app/core/themes/theme_extensions.dart';

import '../../../../core/colors/color.dart';
import '../../../widget_small/custom_button.dart';
class UpdateAccountScreen extends StatefulWidget {
  const UpdateAccountScreen({super.key});

  @override
  _UpdateAccountScreenState createState() => _UpdateAccountScreenState();
}

class _UpdateAccountScreenState extends State<UpdateAccountScreen> {
  String? gender = 'Nam';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cập nhật thông tin tài khoản',
          style: context.theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w500
          ),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Giới tính',
              style: context.theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold
              ),
            ),
            Row(
              children: [
                Radio<String>(
                  value: 'Nam',
                  groupValue: gender,
                  onChanged: (String? value) {
                    setState(() {
                      gender = value;
                    });
                  },
                ),
                Text('Nam',style: context.theme.textTheme.titleMedium,),
                const SizedBox(width: 20),
                Radio<String>(
                  value: 'Nữ',
                  groupValue: gender,
                  onChanged: (String? value) {
                    setState(() {
                      gender = value;
                    });
                  },
                ),
                Text('Nữ',style: context.theme.textTheme.titleMedium,),
              ],
            ),
            const SizedBox(height: 20),

            // Name Field
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Tên của bạn',
                hintText: 'Nhập tên của bạn',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Phone Number Field
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Số điện thoại',
                hintText: 'Số điện thoại của bạn',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Email Field
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Email của bạn',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Password Field
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                hintText: '........',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Date of Birth Field
            TextFormField(
              controller: dobController,
              decoration: InputDecoration(
                labelText: 'Ngày sinh',
                hintText: 'dd/mm/yy',
                filled: true,
                fillColor: Colors.grey[200],
                suffixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    dobController.text =
                    "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                  });
                }
              },
            ),
            const SizedBox(height: 40),

            // Update Button
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       // Handle update action
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.blue,
            //       padding: EdgeInsets.symmetric(vertical: 16),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //     ),
            //     child: Text(
            //       'Cập nhật',
            //       style: TextStyle(fontSize: 16),
            //     ),
            //   ),
            // ),
            const CusButton(text: "Cập nhật", color: Styles.blue)
          ],
        ),
      ),
    );
  }
}