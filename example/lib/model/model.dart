import 'package:sig_pagination/model/model.dart';

class Pagination implements APagination {
  @override
  int page;
  @override
  int total;
  @override
  int size;
  @override
  String? search;
  @override
  String? id;

  Pagination({
    this.page = 0,
    this.total = 100,
    this.size = 50,
    this.search,
    this.id,
  });

  @override
  void reset() {
    page = 0;
    total = 100;
  }

  @override
  void increment() {
    page++;
  }
}

class CustomError {
  final String? message;

  CustomError({
    required this.message,
  });

  factory CustomError.fromJson(Map<String, dynamic> data) {
    return CustomError(
      message: data['message'],
    );
  }
}

class AirlineModel {
  final String country;
  final String logo;
  final String slogan;

  AirlineModel({
    required this.country,
    required this.logo,
    required this.slogan,
  });

  static AirlineModel fromJson(Map<String, dynamic> data) => AirlineModel(
        country: data['country'],
        logo: data['logo'],
        slogan: data['slogan'],
      );
}

class AirPlaneModel {
  final String id;
  final String name;
  final AirlineModel airlineModel;
  AirPlaneModel(
      {required this.airlineModel, required this.id, required this.name});

  static AirPlaneModel fromJson(Map<String, dynamic> data) => AirPlaneModel(
        id: data['_id'],
        name: data['name'],
        airlineModel: AirlineModel.fromJson(data['airline'][0]),
      );
}
