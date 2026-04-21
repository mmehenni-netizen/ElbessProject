import 'package:dio/dio.dart';
import 'package:elbess/core/network/api_exception.dart';
import 'package:elbess/core/network/dio_client.dart';

class ApiService {
  final DioClient _dioClient=DioClient();

Future<dynamic> get(String endpoint)async{
 try{
 final response=await _dioClient.dio.get(endpoint);
  return response.data;
  

 }on DioException catch (e){
 return ApiException.handleError(e);
 }
}



Future<dynamic> post(String endpoint, dynamic body)async{
 try{
 final response=await _dioClient.dio.post(endpoint,data : body);
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
