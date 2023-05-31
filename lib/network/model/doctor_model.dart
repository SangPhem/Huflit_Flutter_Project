class DoctorModel {
  final String? idDoctor;
  final String? hoten;
  final String? chuyennganh;
  final String? ngaysinh;
  final String? tuoinghe;
  final String? benhvien;
  final String? sdt;
  final String? avatar;

  DoctorModel({
    this.idDoctor,
    this.hoten,
    this.chuyennganh,
    this.ngaysinh,
    this.tuoinghe,
    this.benhvien,
    this.sdt,
    this.avatar,
  });

  factory DoctorModel.fromJson(Map<dynamic, dynamic> data) {
    return DoctorModel(
      idDoctor: data['idDoctor'],
      hoten: data['hoten'],
      chuyennganh: data['chuyennganh'],
      ngaysinh: data['ngaysinh'],
      tuoinghe: data['tuoinghe'],
      benhvien: data['benhvien'],
      sdt: data['sdt'],
      avatar: data['avatar'],
    );
  }
}
