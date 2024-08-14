import 'package:android_smartscholl/models/detailPembayaranModel.dart';

class PembayaranModel {
  PembayaranModel(
      {this.kodePost = '',
      this.tahunAkademik = '',
      this.totalNominal = 0,
      this.namaTagihan = '',
      this.tanggalBayar = '',
      this.detailPembayaran = const []});

  String tahunAkademik;
  String namaTagihan;
  String kodePost;
  String tanggalBayar;
  int totalNominal;
  List<DetailPembayaranModel> detailPembayaran;
}
