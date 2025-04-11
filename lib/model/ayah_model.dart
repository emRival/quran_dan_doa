class AyahModel {
  int? nomor;
  String? nama;
  String? namaLatin;
  int? jumlahAyat;
  String? tempatTurun;
  String? arti;
  String? deskripsi;
  AudioFull? audioFull;
  List<Ayat>? ayat;
  SuratSelanjutnya? suratSelanjutnya;
  SuratSelanjutnya? suratSebelumnya;

  AyahModel({
    this.nomor,
    this.nama,
    this.namaLatin,
    this.jumlahAyat,
    this.tempatTurun,
    this.arti,
    this.deskripsi,
    this.audioFull,
    this.ayat,
    this.suratSelanjutnya,
    this.suratSebelumnya,
  });

  AyahModel.fromJson(Map<String, dynamic>? json) {
    nomor = json?['nomor'];
    nama = json?['nama'];
    namaLatin = json?['namaLatin'];
    jumlahAyat = json?['jumlahAyat'];
    tempatTurun = json?['tempatTurun'];
    arti = json?['arti'];
    deskripsi = json?['deskripsi'];
    audioFull = json?['audioFull'] != null
        ? AudioFull.fromJson(json?['audioFull'])
        : null;
    if (json?['ayat'] != null) {
      ayat = <Ayat>[];
      json?['ayat'].forEach((v) {
        ayat!.add(Ayat.fromJson(v));
      });
    }
    suratSelanjutnya = json?['suratSelanjutnya'] != false
        ? SuratSelanjutnya.fromJson(json?['suratSelanjutnya'])
        : null;
    suratSebelumnya = json?['suratSebelumnya'] != false
        ? SuratSelanjutnya.fromJson(json?['suratSebelumnya'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nomor'] = nomor;
    data['nama'] = nama;
    data['namaLatin'] = namaLatin;
    data['jumlahAyat'] = jumlahAyat;
    data['tempatTurun'] = tempatTurun;
    data['arti'] = arti;
    data['deskripsi'] = deskripsi;
    if (audioFull != null) {
      data['audioFull'] = audioFull!.toJson();
    }
    if (ayat != null) {
      data['ayat'] = ayat!.map((v) => v.toJson()).toList();
    }
    if (suratSelanjutnya != null) {
      data['suratSelanjutnya'] = suratSelanjutnya!.toJson();
    }
    if (suratSebelumnya != null) {
      data['suratSebelumnya'] = suratSebelumnya!.toJson();
    }
    return data;
  }
}

class AudioFull {
  String? s01;
  String? s02;
  String? s03;
  String? s04;
  String? s05;

  AudioFull({this.s01, this.s02, this.s03, this.s04, this.s05});

  AudioFull.fromJson(Map<String, dynamic>? json) {
    s01 = json?['01'];
    s02 = json?['02'];
    s03 = json?['03'];
    s04 = json?['04'];
    s05 = json?['05'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['01'] = s01;
    data['02'] = s02;
    data['03'] = s03;
    data['04'] = s04;
    data['05'] = s05;
    return data;
  }
}

class Ayat {
  int? nomorAyat;
  String? teksArab;
  String? teksLatin;
  String? teksIndonesia;
  AudioFull? audio;

  Ayat({
    this.nomorAyat,
    this.teksArab,
    this.teksLatin,
    this.teksIndonesia,
    this.audio,
  });

  Ayat.fromJson(Map<String, dynamic>? json) {
    nomorAyat = json?['nomorAyat'];
    teksArab = json?['teksArab'];
    teksLatin = json?['teksLatin'];
    teksIndonesia = json?['teksIndonesia'];
    audio = json?['audio'] != null ? AudioFull.fromJson(json?['audio']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nomorAyat'] = nomorAyat;
    data['teksArab'] = teksArab;
    data['teksLatin'] = teksLatin;
    data['teksIndonesia'] = teksIndonesia;
    if (audio != null) {
      data['audio'] = audio!.toJson();
    }
    return data;
  }
}

class SuratSelanjutnya {
  int? nomor;
  String? nama;
  String? namaLatin;
  int? jumlahAyat;

  SuratSelanjutnya({
    this.nomor,
    this.nama,
    this.namaLatin,
    this.jumlahAyat,
  });

  SuratSelanjutnya.fromJson(Map<String, dynamic>? json) {
    nomor = json?['nomor'];
    nama = json?['nama'];
    namaLatin = json?['namaLatin'];
    jumlahAyat = json?['jumlahAyat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nomor'] = nomor;
    data['nama'] = nama;
    data['namaLatin'] = namaLatin;
    data['jumlahAyat'] = jumlahAyat;
    return data;
  }
}
