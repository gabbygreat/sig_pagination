import 'package:example/model/model.dart';
import 'package:example/services/network.dart';

class PlaneRequest extends NetworkService {
  static final PlaneRequest instance = PlaneRequest._init();
  PlaneRequest._init();

  Future<List<AirPlaneModel>> fetchPlanes({
    required Pagination pagination,
  }) async {
    var path = 'passenger';
    final response = await getRequestHandler(path, queryPatameters: {
      "page": pagination.page,
      "size": pagination.size,
    });
    pagination.total = response.data['totalPassengers'] as int;
    pagination.increment();
    return (response.data['data'] as List)
        .map((e) => AirPlaneModel.fromJson(e))
        .toList();
  }
}
