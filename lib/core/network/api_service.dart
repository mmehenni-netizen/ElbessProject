import 'package:dio/dio.dart';
import 'package:elbess/core/network/api_exception.dart';
import 'package:elbess/core/network/dio_client.dart';

class ApiService {
  final DioClient _dioClient=DioClient();

Future<dynamic> get(String endpoint)async{
 try{
    // Debug: log GET endpoint
    try{
      // ignore: avoid_print
      print('ApiService.get -> endpoint=$endpoint');
    }catch(_){ }

    final response=await _dioClient.dio.get(endpoint);
    try{
      // ignore: avoid_print
      print('ApiService.get -> response=${response.data}');
    }catch(_){ }

    return response.data;
  }on DioException catch (e){
    return ApiException.handleError(e);
  }
}



Future<dynamic> post(String endpoint, dynamic body)async{
 try{
    // Debug: log POST endpoint and body
    try{
      // ignore: avoid_print
      print('ApiService.post -> endpoint=$endpoint body=${body}');
    }catch(_){ }

    final response=await _dioClient.dio.post(endpoint,data : body);
    try{
      // ignore: avoid_print
      print('ApiService.post -> response=${response.data}');
    }catch(_){ }

    return response.data;
  }on DioException catch (e){
    return ApiException.handleError(e);
  }
}

Future<dynamic> put(String endpoint, dynamic body)async{
 try{
 final response=await _dioClient.dio.put(endpoint,data: body);
  return response.data;
  

 }on DioException catch (e){
 return ApiException.handleError(e);
 }
}


Future<dynamic> delete(String endpoint, dynamic body)async{
 try{
 final response=await _dioClient.dio.delete(endpoint,data: body);
  return response.data;
  

 }on DioException catch (e){
 return ApiException.handleError(e);
 }
}

}
