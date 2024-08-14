import 'package:android_smartscholl/models/detailPembayaranSPPModel.dart';

class PembayaranSPPModel {
  PembayaranSPPModel(
      {this.namaTagihan = '',
      this.kodeTagihan = '',
      this.totalNominal = 0,
      this.tahunAkademik = '',
      this.detailTagihan = const []});

  String namaTagihan;
  String kodeTagihan;
  int totalNominal;
  String tahunAkademik;
  List<DetailPembayaranSPPModel> detailTagihan;
}
