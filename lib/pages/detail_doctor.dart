import 'package:flutter/material.dart';
import 'package:med_app/widget/button_primary.dart';
import 'package:med_app/network/model/doctor_model.dart';

class DetailDoctor extends StatefulWidget {
  final DoctorModel doctor; // Thêm thuộc tính doctor

  DetailDoctor({required this.doctor}); // Thêm constructor

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
    final doctor = widget.doctor; // Lấy thông tin bác sĩ từ thuộc tính widget

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
                height: 300,
                child: Image.network(
                  doctor.avatar.toString(),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Họ tên: ${doctor.hoten}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Chuyên ngành: ${doctor.chuyennganh}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Ngày tháng năm sinh: ${doctor.ngaysinh}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Tuổi nghề: ${doctor.tuoinghe} năm',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Bệnh viện trực thuộc: ${doctor.benhvien}',
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
