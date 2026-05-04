/// id : "0"
/// name_ar : "إبراهيم الأخضر"
/// name_en : "Ibrahim Al-Akhdar"
/// rewaya_ar : "حفص عن عاصم"
/// rewaya_en : "Hafs from Asim"
/// musshaf_type_ar : "مرتل"
/// musshaf_type_en : "Murattal"
/// audio_url_bit_rate_32 : "https://verse.mp3quran.net/arabic/ibrahim_alakhdar/32/"
/// audio_url_bit_rate_64 : ""
/// audio_url_bit_rate_128 : ""
library;

class AudioModel {
  AudioModel({
      String? id, 
      String? nameAr, 
      String? nameEn, 
      String? rewayaAr, 
      String? rewayaEn, 
      String? musshafTypeAr, 
      String? musshafTypeEn, 
      String? audioUrlBitRate32, 
      String? audioUrlBitRate64, 
      String? audioUrlBitRate128,}){
    _id = id;
    _nameAr = nameAr;
    _nameEn = nameEn;
    _rewayaAr = rewayaAr;
    _rewayaEn = rewayaEn;
    _musshafTypeAr = musshafTypeAr;
    _musshafTypeEn = musshafTypeEn;
    _audioUrlBitRate32 = audioUrlBitRate32;
    _audioUrlBitRate64 = audioUrlBitRate64;
    _audioUrlBitRate128 = audioUrlBitRate128;
}

  AudioModel.fromJson(dynamic json) {
    _id = json['id'];
    _nameAr = json['name_ar'];
    _nameEn = json['name_en'];
    _rewayaAr = json['rewaya_ar'];
    _rewayaEn = json['rewaya_en'];
    _musshafTypeAr = json['musshaf_type_ar'];
    _musshafTypeEn = json['musshaf_type_en'];
    _audioUrlBitRate32 = json['audio_url_bit_rate_32'];
    _audioUrlBitRate64 = json['audio_url_bit_rate_64'];
    _audioUrlBitRate128 = json['audio_url_bit_rate_128'];
  }
  String? _id;
  String? _nameAr;
  String? _nameEn;
  String? _rewayaAr;
  String? _rewayaEn;
  String? _musshafTypeAr;
  String? _musshafTypeEn;
  String? _audioUrlBitRate32;
  String? _audioUrlBitRate64;
  String? _audioUrlBitRate128;
AudioModel copyWith({  String? id,
  String? nameAr,
  String? nameEn,
  String? rewayaAr,
  String? rewayaEn,
  String? musshafTypeAr,
  String? musshafTypeEn,
  String? audioUrlBitRate32,
  String? audioUrlBitRate64,
  String? audioUrlBitRate128,
}) => AudioModel(  id: id ?? _id,
  nameAr: nameAr ?? _nameAr,
  nameEn: nameEn ?? _nameEn,
  rewayaAr: rewayaAr ?? _rewayaAr,
  rewayaEn: rewayaEn ?? _rewayaEn,
  musshafTypeAr: musshafTypeAr ?? _musshafTypeAr,
  musshafTypeEn: musshafTypeEn ?? _musshafTypeEn,
  audioUrlBitRate32: audioUrlBitRate32 ?? _audioUrlBitRate32,
  audioUrlBitRate64: audioUrlBitRate64 ?? _audioUrlBitRate64,
  audioUrlBitRate128: audioUrlBitRate128 ?? _audioUrlBitRate128,
);
  String? get id => _id;
  String? get nameAr => _nameAr;
  String? get nameEn => _nameEn;
  String? get rewayaAr => _rewayaAr;
  String? get rewayaEn => _rewayaEn;
  String? get musshafTypeAr => _musshafTypeAr;
  String? get musshafTypeEn => _musshafTypeEn;
  String? get audioUrlBitRate32 => _audioUrlBitRate32;
  String? get audioUrlBitRate64 => _audioUrlBitRate64;
  String? get audioUrlBitRate128 => _audioUrlBitRate128;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name_ar'] = _nameAr;
    map['name_en'] = _nameEn;
    map['rewaya_ar'] = _rewayaAr;
    map['rewaya_en'] = _rewayaEn;
    map['musshaf_type_ar'] = _musshafTypeAr;
    map['musshaf_type_en'] = _musshafTypeEn;
    map['audio_url_bit_rate_32'] = _audioUrlBitRate32;
    map['audio_url_bit_rate_64'] = _audioUrlBitRate64;
    map['audio_url_bit_rate_128'] = _audioUrlBitRate128;
    return map;
  }

}