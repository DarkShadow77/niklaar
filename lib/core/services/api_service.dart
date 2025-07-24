import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

import '../model/api_model.dart';

class ApiService {
  static ApiService? _apiService;

  ApiService._();

  static ApiService? get instance {
    _apiService ??= ApiService._();
    return _apiService;
  }

  Dio dio = Dio();

  // Update Cookie for API calls
  updateCookie(Headers headers) {
    //Get the value of the cookie passed in the response
    final rawCookie = headers['set-cookie'];

    if (rawCookie != null) {
      Logger().i("Cookies: $rawCookie");

      //Get the index of the equals symbol
      int indexOfEquals = rawCookie[0].indexOf('=');
      //Get index of the first semiColon symbol
      int indexOfSemiColon = rawCookie[0].indexOf(';');

      //Stores the value of the token
      String token = "";

      // Handle cases where the string might not contain an equals symbol
      if (indexOfEquals != -1 &&
          indexOfSemiColon != -1 &&
          indexOfEquals < indexOfSemiColon) {
        //Get the string after the first equals symbol
        token = rawCookie[0].substring(indexOfEquals + 1, indexOfSemiColon);

        //Store the token in the localStorage
        // LocalStorageHelper().setUserToken(token);

        Logger().i("Auth: $token");
      } else {
        // Optionally handle cases where the string doesn't have an equals symbol
        token = "";

        //Store the token in the localStorage
        // LocalStorageHelper().setUserToken(token);

        Logger().i("Auth: $token");
      }
    }
  }

  Future<ApiResponse<T>> postRequestHandler<T>(
    String url,
    dynamic body, {
    T Function(dynamic)? transform,
    Options? options,
    String? accessToken,
    bool interchange = false,
  }) async {
    transform ??= (dynamic r) => r.body as T;
    final ApiResponse<T> apiResponse = ApiResponse<T>();

    Logger().i("Request Path ${dotenv.env["BASE_URL"]}$url");
    Logger().i("Request body $body");

    try {
      // Set headers locally for this request
      final Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Cookie': 'auth=$accessToken',
      };

      final requestOptions =
          options?.copyWith(headers: headers) ?? Options(headers: headers);

      /*dio.options.headers['Authorization'] = 'Bearer $accessToken';
      dio.options.headers['Cookie'] = 'auth=$accessToken';*/

      Logger().i("Authorization: $accessToken ");

      final res = await dio.post("${dotenv.env["BASE_URL"]}$url",
          data: body, options: requestOptions);
      final dynamic data = res.data;

      Logger().i("Response body $data");
      final payload = data['data'] as Map<String, dynamic>;

      if (res.statusCode == 200 || res.statusCode == 201) {
        //Call the update Cookie function
        await updateCookie(res.headers);

        apiResponse.responseSuccessful =
            data['status'] == true || data['status'] == 'true';
        apiResponse.responseMessage = payload['message'] ?? 'Request completed';
        apiResponse.responseBody = transform(payload);
      } else {
        apiResponse.responseSuccessful =
            data['status'] == false || data['status'] == 'false';
        apiResponse.responseMessage =
            (payload['message'] ?? 'Error encountered');
      }
      Logger().i("Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Response Message: ${apiResponse.responseMessage}");
      Logger().i("Response Body: ${apiResponse.responseBody}");
    } on DioException catch (e) {
      Logger().i("Dio Response Full Message: ${e.response?.data}");
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage =
          e.response?.data['data']["message"] ?? 'An error occurred';
      // //apiResponse.responseBody = e.response?.data['responseBody'] ?? 'No Body';

      Logger().i("Dio Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Dio Response Message: ${apiResponse.responseMessage}");
    } on SocketException catch (_) {
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage = "An Error occurred";

      Logger()
          .i("Socket Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Socket Response Successful: ${apiResponse.responseMessage}");
    }
    return apiResponse;
  }

  Future<ApiResponse> postRequest(
    String url,
    dynamic body, {
    Options? options,
    String? accessToken,
  }) async {
    final ApiResponse apiResponse = ApiResponse();

    Logger().i("Request Path ${dotenv.env["BASE_URL"]}$url");
    Logger().i("Request body $body");

    try {
      // Set headers locally for this request
      final Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Cookie': 'auth=$accessToken',
      };

      final requestOptions =
          options?.copyWith(headers: headers) ?? Options(headers: headers);

      /* dio.options.headers['Authorization'] = 'Bearer $accessToken';
      dio.options.headers['Cookie'] = 'auth=$accessToken';
*/
      Logger().i("Authorization: $accessToken");

      final res = await dio.post(
        "${dotenv.env["BASE_URL"]}$url",
        data: body,
        options: requestOptions,
      );
      final dynamic rawData = res.data;

      // Convert JSON string to Map<String, dynamic>
      Map<String, dynamic> data = {};
      if (rawData.runtimeType == String) {
        data = jsonDecode(rawData);
      } else {
        data = rawData;
      }

      Logger().i("Response body $data ${data.runtimeType}");
      final payload = data['data'] as Map<String, dynamic>;

      if (res.statusCode == 200 || res.statusCode == 201) {
        //Call the update Cookie function
        await updateCookie(res.headers);

        apiResponse.responseSuccessful =
            data['status'] == true || data['status'] == 'true';
        apiResponse.responseMessage =
            data['data']["message"] ?? 'Request completed';
        apiResponse.responseBody = data['responseBody'] ?? 'No Body';
      } else {
        apiResponse.responseSuccessful =
            data['status'] == false || data['status'] == 'false';
        apiResponse.responseMessage =
            (payload['message'] ?? 'Error encountered');
        apiResponse.responseBody = data['responseBody'] ?? 'No Body';
      }

      Logger().i("Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Response Message: ${apiResponse.responseMessage}");
      Logger().i("Response Body: ${apiResponse.responseBody}");

      if (apiResponse.responseMessage
              ?.contains("Session expired, log in again") ??
          false) {
        // sessionTimeoutDialog();
      }
    } on DioException catch (e) {
      Logger().i("Dio Response Total Messages: $e");
      Logger().i("Dio Response Full Message: ${e.response?.data}");
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage =
          e.response?.data['data']["message"] ?? 'An error occurred';
      // //apiResponse.responseBody = e.response?.data['responseBody'] ?? 'No Body';

      Logger().i("Dio Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Dio Response Message: ${apiResponse.responseMessage}");
      // Logger().i("Dio Response Body: ${apiResponse.responseBody}");
    } on SocketException catch (_) {
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage = "An Error occurred";

      Logger()
          .i("Socket Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Socket Response Successful: ${apiResponse.responseMessage}");
    }
    return apiResponse;
  }
}
