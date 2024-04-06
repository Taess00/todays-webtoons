class WebtoonNaverModel {
  late final String title, thumb, id;

  WebtoonNaverModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        thumb = json['thumb'],
        id = json['id'];
}
