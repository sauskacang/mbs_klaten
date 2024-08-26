import 'package:mbs_klaten/models/detailTagihanModel.dart';

class TagihanModel {
  TagihanModel(
      {this.namaTagihan = '',
      this.kodeTagihan = '',
      this.totalNominal = 0,
      this.tahunAkademik = '',
      this.cicil = '',
      this.allow = '',
      this.billId = '',
      this.detailTagihan = const []});

  String namaTagihan;
  String kodeTagihan;
  String billId;
  String cicil;
  String allow;
  int totalNominal;
  String tahunAkademik;
  List<DetailTagihanModel> detailTagihan;
}
