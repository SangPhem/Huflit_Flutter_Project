import 'package:flutter/material.dart';
import 'package:med_app/widget/button_primary.dart';

class DetailDoctor extends StatefulWidget {
  @override
  _DetailDoctorState createState() => _DetailDoctorState();
}

class _DetailDoctorState extends State<DetailDoctor> {
  String _selectedDate = 'Chọn ngày';
  String _selectedTime = 'Chọn giờ';

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked.toString());
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked.format(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin bác sĩ tư vấn'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/Johnny Sins.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Họ tên: Nguyễn Quốc Tiến',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Chuyên ngành: Bác sĩ nội khoa',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Ngày tháng năm sinh: 02/01/2001',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Tuổi nghề: 10 năm',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Bệnh viện trực thuộc: BV Chợ Rẫy',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('Ngày hẹn'),
                subtitle: Text(_selectedDate),
                onTap: () => _selectDate(context),
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text('Giờ hẹn'),
                subtitle: Text(_selectedTime),
                onTap: () => _selectTime(context),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: Text('Xác nhận đặt lịch hẹn'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
