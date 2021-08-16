class Movie {
  late int id;
  late String movieName;
  late String director;
  late String posterUri;

  Movie({required this.id, required this.movieName, required this.director, required this.posterUri});

  Movie.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    movieName = json['movie_name'];
    director = json['director'];
    posterUri = json['poster_uri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['movie_name'] = this.movieName;
    data['director'] = this.director;
    data['poster_uri'] = this.posterUri;
    return data;
  }
}
