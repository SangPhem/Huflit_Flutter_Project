import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:med_app/network/model/pref_profile_model.dart';
import 'package:med_app/widget/button_primary.dart';
import 'package:med_app/network/model/doctor_model.dart';
import 'package:med_app/network/api/url_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:med_app/network/model/booked_schedule_model.dart';

import 'package:http/http.dart' as http;

class DetailDoctor extends StatefulWidget {
  final DoctorModel doctor;

  DetailDoctor({required this.doctor});

  @override
  _DetailDoctorState createState() => _DetailDoctorState();
}

class _DetailDoctorState extends State<DetailDoctor> {
  String? _selectedDate; // Ban đầu giá trị là null
  String? _selectedTime; // Ban đầu giá trị là null

  bool isBookingSuccess = false;
  // Khai báo danh sách lịch hẹn
  List<BookedScheduleModel> bookedSchedules = [];

  Future<void> _fetchBookedSchedules() async {
    final DoctorModel doctor = widget.doctor;
    var doctorId = doctor.idDoctor;
    var url = Uri.parse(BASEURL.getbooking);
    var response = await http.post(
      url,
      body: {'doctor_id': doctorId},
    );

    if (response.statusCode == 200) {
      // Chuyển đổi dữ liệu từ JSON sang List<BookedScheduleModel>
      List<dynamic> jsonData = json.decode(response.body);
      bookedSchedules =
          jsonData.map((item) => BookedScheduleModel.fromJson(item)).toList();
      setState(() {});
    } else {
      // Xử lý khi lấy dữ liệu không thành công
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông báo'),
            content: Text('Lịch hiển thị đang bị lỗi.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Gọi hàm lấy danh sách lịch hẹn khi màn hình được khởi tạo
    _fetchBookedSchedules();
  }

  Widget _buildBookedScheduleList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 20),
        Text(
          'Lịch đặt của bạn với bác sĩ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          itemCount: bookedSchedules.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
          itemBuilder: (context, index) {
            BookedScheduleModel schedule = bookedSchedules[index];
            bool isBooked =
                true; // Kiểm tra xem ngày đã được đặt hay chưa, bạn cần thay đổi logic này dựa trên dữ liệu thực tế
            return Container(
              decoration: BoxDecoration(
                color: isBooked ? Colors.red : Colors.transparent,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${schedule.bookedDate.day}/${schedule.bookedDate.month}',
                    style: TextStyle(
                      color: isBooked ? Colors.white : Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${schedule.bookedDate.year}',
                    style: TextStyle(
                      color: isBooked ? Colors.white : Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked.toString();
      });
    }
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked.format(context);
      });
    }
  }

  Future<String?> getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(PrefProfile.idUSer);
  }

  void _confirmBooking() async {
    String? userId = await getUserId();
    final DoctorModel doctor = widget.doctor;

    if (_selectedDate == null || _selectedTime == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông báo'),
            content: Text('Vui lòng chọn ngày và giờ muốn đặt với bác sĩ.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Dừng quá trình đặt lịch nếu ngày hoặc giờ chưa được chọn
    }

    // Kiểm tra xem ngày đã được đặt với bác sĩ hay chưa
    bool isDateBooked = bookedSchedules.any((schedule) =>
        schedule.doctorId == doctor.idDoctor &&
        schedule.bookedDate.toString() == _selectedDate);

    if (isDateBooked) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông báo'),
            content: Text('Ngày đã được đặt, vui lòng chọn ngày khác.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Dừng quá trình đặt lịch nếu ngày đã được đặt
    }

    // Gửi yêu cầu đặt lịch hẹn
    var urlBooking = Uri.parse(BASEURL.booking);
    final response = await http.post(
      urlBooking,
      body: {
        'user_id': userId.toString(), // Sử dụng userId từ SharedPreferences
        'doctor_id': doctor.idDoctor.toString(),
        'booked_date': _selectedDate.toString(),
        'booked_time': _selectedTime.toString(),
      },
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông báo'),
            content: Text('Đặt lịch thành công.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    isBookingSuccess = true;
                  });
                  // Refresh lại danh sách lịch đặt
                  _fetchBookedSchedules();

                  // Refresh lại ngày và giờ đã chọn
                  setState(() {
                    _selectedDate = null;
                    _selectedTime = null;
                  });

                  // Refresh lại giao diện sau 2 giây
                  Future.delayed(Duration(seconds: 2), () {
                    setState(() {
                      isBookingSuccess = false;
                    });
                  });
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Xử lý khi đặt lịch không thành công
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông báo'),
            content: Text('Đặt lịch không thành công. Vui lòng thử lại sau.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor;

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
                  doctor.avatar!,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Text(
                doctor.hoten!,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                doctor.chuyennganh!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Ngày sinh: ${doctor.ngaysinh}',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Tuổi nghề: ${doctor.tuoinghe} năm',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Bệnh viện: ${doctor.benhvien}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: 'Số điện thoại: ',
                  style: TextStyle(fontSize: 16),
                  children: [
                    TextSpan(
                      text: doctor.sdt,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              _buildBookedScheduleList(),
              SizedBox(height: 20),
              Text(
                'Chọn ngày:',
                style: TextStyle(fontSize: 16),
              ),
              TextButton(
                onPressed: () => _selectDate(context),
                child: Text(_selectedDate ?? 'Chọn ngày'),
              ),
              SizedBox(height: 10),
              Text(
                'Chọn giờ:',
                style: TextStyle(fontSize: 16),
              ),
              TextButton(
                onPressed: () => _selectTime(context),
                child: Text(_selectedTime ?? 'Chọn giờ'),
              ),
              SizedBox(height: 20),
              ButtonPrimary(
                text: 'Xác nhận đặt lịch hẹn',
                onTap: _confirmBooking,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
