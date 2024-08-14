import 'package:android_smartscholl/models/detailTagihanModel.dart';

class TagihanModel {
  TagihanModel(
      {this.namaTagihan = '',
      this.kodeTagihan = '',
      this.totalNominal = 0,
      this.tahunAkademik = '',
      this.detailTagihan = const []});

  String namaTagihan;
  String kodeTagihan;
  int totalNominal;
  String tahunAkademik;
  List<DetailTagihanModel> detailTagihan;
}
