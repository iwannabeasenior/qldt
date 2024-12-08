

import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:qldt/data/model/class.dart';
import 'package:qldt/data/remote/api_service_it4788.dart';
import 'package:qldt/data/request/get_class_list_request.dart';
import 'package:qldt/helper/constant.dart';
import 'package:qldt/helper/failure.dart';
import 'package:http/http.dart' as http;



abstract class ApiServiceIT5023E {
  Future<Either<Failure, List<Class>>> getAllClass(GetClassListRequest request);
}

class ApiServiceIT5023EImpl extends ApiServiceIT5023E {
  @override
  Future<Either<Failure, List<Class>>> getAllClass(GetClassListRequest request) async {
    try {
      final String endpoint = '/it5023e/get_class_list';

      final Uri url = Uri.parse(Constant.BASEURL + endpoint);

      var response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(request.toJson())
      );
      var body = jsonDecode(response.body);

      if (response.statusCode == 200) {

        return Right((body['data']['page_content'] as List<dynamic>).map((value) => Class.fromJson(value)).toList());

      } else {

        return Left(Failure(message: body['message'], code: body['code']));

      }
    } on SocketException {
      return Left(Failure(message: 'No Internet connection', code: 0));
    } on FormatException {
      return Left(Failure(message: 'Bad response format', code: 0));
    }
    catch(e) {
      return Left(Failure(code: 0, message: e.toString()));
    }

  }

}

//{
//     "token": "BccxRt",
//     "role" : "LECTURER",
//     "account_id" : "237",
//     "pageable_request" : {
//         "page" : "0",
//         "page_size" : "10"
//     }
// }