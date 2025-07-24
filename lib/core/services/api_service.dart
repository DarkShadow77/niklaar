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

      if (res.statusCode == 200 || res.statusCode == 201) {
        //Call the update Cookie function
        await updateCookie(res.headers);

        if (data.isEmpty == true) {
          apiResponse.responseSuccessful = data['responseSuccessful'] ?? true;
          apiResponse.responseMessage = 'Request completed';
        } else {
          apiResponse.responseSuccessful = data['responseSuccessful'] ?? true;
          if (interchange) {
            apiResponse.responseMessage = 'Request completed';
            apiResponse.responseBody = transform(data['responseMessage']);
          } else {
            apiResponse.responseMessage =
                data['responseMessage'] ?? 'Request completed';

            apiResponse.responseBody = transform(data['responseBody']);
          }
        }
      } else {
        apiResponse.responseSuccessful = false;
        apiResponse.responseMessage =
            (data['responseMessage'] ?? 'Error encountered');
      }
      Logger().i("Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Response Message: ${apiResponse.responseMessage}");

      if (apiResponse.responseMessage
              ?.contains("Session expired, log in again") ??
          false) {
        // sessionTimeoutDialog();
      }
    } on DioException catch (e) {
      Logger().i("Dio Response Full Message: ${e.response?.data}");
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage =
          e.response?.data['responseMessage'] ?? 'An error occurred';
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

      if (res.statusCode == 200 || res.statusCode == 201) {
        //Call the update Cookie function
        await updateCookie(res.headers);

        apiResponse.responseSuccessful = data['responseSuccessful'] ?? true;
        apiResponse.responseMessage =
            data['responseMessage'] ?? 'Request completed';
        apiResponse.responseBody = data['responseBody'] ?? 'No Body';
      } else {
        apiResponse.responseSuccessful = false;
        apiResponse.responseMessage =
            (data['responseMessage'] ?? 'Error encountered');
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
          e.response?.data['responseMessage'] ?? 'An error occurred';
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

  Future<ApiResponse<T>> getRequestHandler<T>(
    String url, {
    T Function(dynamic)? transform,
    Options? options,
    String? accessToken,
    customUrl = false,
  }) async {
    transform ??= (dynamic r) => r as T;
    final ApiResponse<T> apiResponse = ApiResponse<T>();

    Logger().i("Request Path ${customUrl ? "" : dotenv.env["BASE_URL"]}$url");

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

      Logger().i("Authorization: $accessToken");

      final res = await dio.get(
        "${customUrl ? "" : dotenv.env["BASE_URL"]}$url",
        options: requestOptions,
      );
      final dynamic data = res.data;

      Logger().i("Response body $data");
      Logger().i("Response body ${res.statusMessage}");

      if (res.statusCode == 200 || res.statusCode == 201) {
        //Call the update Cookie function
        await updateCookie(res.headers);

        if (data.isEmpty == true) {
          apiResponse.responseSuccessful = data['responseSuccessful'] ?? true;
          apiResponse.responseMessage = 'Request completed';
        } else {
          apiResponse.responseSuccessful = data['responseSuccessful'] ?? true;
          apiResponse.responseMessage =
              data['responseMessage'] ?? 'Request completed';
          apiResponse.responseBody = transform(data['responseBody']);
        }
      } else {
        apiResponse.responseSuccessful = false;
        apiResponse.responseMessage =
            data['responseMessage'] ?? 'Error encountered';
      }

      Logger().i("Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Response Message: ${apiResponse.responseMessage}");

      if (apiResponse.responseMessage
              ?.contains("Session expired, log in again") ??
          false) {
        // sessionTimeoutDialog();
      }
    } on DioException catch (e) {
      Logger().i("Dio Response Full Message: ${e.response?.data}");
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage =
          e.response?.data['responseMessage'] ?? 'An error occurred';
      //apiResponse.responseBody = e.response?.data['responseBody'] ?? 'No Body';

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

  Future<ApiResponse> getRequest(
    String url, {
    Options? options,
    String? accessToken,
  }) async {
    final ApiResponse apiResponse = ApiResponse();

    Logger().i("Request Path ${dotenv.env["BASE_URL"]}$url");

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

      Logger().i("Authorization: $accessToken");

      final res = await dio.get(
        "${dotenv.env["BASE_URL"]}$url",
        options: requestOptions,
      );
      final dynamic data = res.data;

      Logger().i("Response body $data");

      if (res.statusCode == 200 || res.statusCode == 201) {
        //Call the update Cookie function
        await updateCookie(res.headers);

        apiResponse.responseSuccessful = data['responseSuccessful'] ?? true;
        apiResponse.responseMessage = data['responseMessage'] ?? '';
      } else {
        apiResponse.responseSuccessful = false;
        apiResponse.responseMessage =
            (data['responseMessage'] ?? 'Error encountered');
      }
      Logger().i("Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Response Message: ${apiResponse.responseMessage}");

      if (apiResponse.responseMessage
              ?.contains("Session expired, log in again") ??
          false) {
        // sessionTimeoutDialog();
      }
    } on DioException catch (e) {
      Logger().i("Dio Response Full Message: ${e.response?.data}");
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage =
          e.response?.data['responseMessage'] ?? 'An error occurred';
      //apiResponse.responseBody = e.response?.data['responseBody'] ?? 'No Body';

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

  Future<ApiResponse> patchRequest(
    String url,
    dynamic body, {
    Options? options,
    String? accessToken,
  }) async {
    final ApiResponse apiResponse = ApiResponse();

    // print();
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

      Logger().i("Authorization: $accessToken");

      final res = await dio.patch(
        "${dotenv.env["BASE_URL"]}$url",
        data: body,
        options: requestOptions,
      );
      final dynamic data = res.data;

      Logger().i("Response body $data");

      if (res.statusCode == 200 || res.statusCode == 201) {
        //Call the update Token function
        await updateCookie(res.headers);

        apiResponse.responseSuccessful = data['responseSuccessful'] ?? true;
        apiResponse.responseMessage =
            data['responseMessage'] ?? 'Request completed';
      } else {
        apiResponse.responseSuccessful = false;
        apiResponse.responseMessage =
            (data['responseMessage'] ?? 'Error encountered');
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
      Logger().i("Dio Response Full Message: ${e.response?.data}");
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage =
          e.response?.data['responseMessage'] ?? 'An error occurred';
      //apiResponse.responseBody = e.response?.data['responseBody'] ?? 'No Body';

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

  Future<ApiResponse> putRequest(
    String url,
    dynamic body, {
    Options? options,
    String? accessToken,
  }) async {
    final ApiResponse apiResponse = ApiResponse();

    // print();
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

      Logger().i("Authorization: $accessToken");

      final res = await dio.put(
        "${dotenv.env["BASE_URL"]}$url",
        data: body,
        options: requestOptions,
      );
      final dynamic data = res.data;

      Logger().i("Response body $data");

      if (res.statusCode == 200 || res.statusCode == 201) {
        //Call the update Token function
        await updateCookie(res.headers);

        apiResponse.responseSuccessful = data['responseSuccessful'] ?? true;
        apiResponse.responseMessage =
            data['responseMessage'] ?? 'Request completed';
      } else {
        apiResponse.responseSuccessful = false;
        apiResponse.responseMessage =
            (data['responseMessage'] ?? 'Error encountered');
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
      Logger().i("Dio Response Full Message: ${e.response?.data}");
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage =
          e.response?.data['responseMessage'] ?? 'An error occurred';
      //apiResponse.responseBody = e.response?.data['responseBody'] ?? 'No Body';

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

  Future<ApiResponse> deleteRequest(
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

      Logger().i("Authorization: $accessToken");

      final res = await dio.delete(
        "${dotenv.env["BASE_URL"]}$url",
        data: body,
        options: requestOptions,
      );
      final dynamic data = res.data;

      Logger().i("Response body $data");

      if (res.statusCode == 200 || res.statusCode == 201) {
        //Call the update Cookie function
        await updateCookie(res.headers);

        apiResponse.responseSuccessful = data['responseSuccessful'] ?? true;
        apiResponse.responseMessage =
            data['responseMessage'] ?? 'Request completed';
        apiResponse.responseBody = data['responseBody'] ?? "No Body";
      } else {
        apiResponse.responseSuccessful = false;
        apiResponse.responseMessage =
            (data['responseMessage'] ?? 'Error encountered');
        apiResponse.responseBody = data['responseBody'] ?? "No Body";
      }

      Logger().i("Response Successful: ${apiResponse.responseSuccessful}");
      Logger().i("Response Message: ${apiResponse.responseMessage}");
      Logger().i("Response Body: ${apiResponse.responseBody}");

      if (apiResponse.responseMessage!
          .contains("Session expired, log in again")) {
        // sessionTimeoutDialog();
      }
    } on DioException catch (e) {
      Logger().i("Dio Response Full Message: ${e.response?.data}");
      apiResponse.responseSuccessful = false;
      apiResponse.responseMessage =
          e.response?.data['responseMessage'] ?? 'An error occurred';
      //apiResponse.responseBody = e.response?.data['responseBody'] ?? 'No Body';

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
//
// Future<ApiResponse<T>> putRequestHandler<T>(
//   String url,
//   dynamic body, {
//   T Function(dynamic)? transform,
//   required String accessToken,
//   String? profileType,
//   Options? options,
// }) async {
//   transform ??= (dynamic r) => r.body as T;
//   final ApiResponse<T> apiResponse = ApiResponse<T>();
//
//   log(body);
//   log({dotenv.env["BASE_URL"]} + url);
//   try {
//     var headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $accessToken'
//     };
//     final res = await dio.put(
//       {dotenv.env["BASE_URL"]} + url,
//       data: body,
//       options: Options(
//         method: 'PUT',
//         headers: headers,
//       ),
//     );
//     final dynamic data = res.data;
//
//     if (res.statusCode == 200) {
//       apiResponse.responseBody = transform(data);
//       apiResponse.responseSuccessful = data['responseSuccessful'] ?? true;
//
//       apiResponse.responseMessage = data['responseMessage'];
//     } else {
//       apiResponse.responseSuccessful = false;
//       apiResponse.responseMessage =
//           (data['responseMessage'] ?? 'Error encountered');
//     }
//   } on DioException catch (e) {
//     if (kDebugMode) {
//       print(e.response?.data);
//     }
//     apiResponse.responseSuccessful = false;
//     apiResponse.responseMessage = e.response?.data['responseMessage'];
//   } on SocketException catch (_) {
//     apiResponse.responseSuccessful = false;
//     apiResponse.responseMessage = "An Error occurred";
//   }
//   return apiResponse;
// }
//
// Future<ApiResponse<T>> patchRequestHandler<T>(
//   String url,
//   dynamic body, {
//   T Function(dynamic)? transform,
//   String? accessToken,
//   String? profileType,
//   Options? options,
// }) async {
//   transform ??= (dynamic r) => r.body as T;
//   final ApiResponse<T> apiResponse = ApiResponse<T>();
//
//   try {
//     dio.options.headers['accept'] = 'application/json';
//     dio.options.headers['ProfileType'] = profileType;
//     dio.options.headers['Authorization'] = 'Bearer $accessToken';
//     final res = await dio.patch({dotenv.env["BASE_URL"]} + url, data: body, options: options);
//     final dynamic data = res.data;
//
//     if (kDebugMode) {
//       print(data);
//     }
//     if (res.statusCode == 200) {
//       apiResponse.responseBody = transform(data);
//       apiResponse.responseSuccessful = data['responseSuccessful'] ?? true;
//       apiResponse.responseMessage = data['responseMessage'];
//     } else {
//       apiResponse.responseSuccessful = false;
//       apiResponse.responseMessage =
//           (data['responseMessage'] ?? 'Error encountered');
//     }
//   } on DioException catch (e) {
//     if (kDebugMode) {
//       print(e.response?.data);
//     }
//     apiResponse.responseSuccessful = false;
//     apiResponse.responseMessage = e.response?.data['responseMessage'];
//   } on SocketException catch (_) {
//     apiResponse.responseSuccessful = false;
//     apiResponse.responseMessage = "An Error occurred";
//   }
//   return apiResponse;
// }

//
// Future<ApiResponse<T>> deleteRequestHandler<T>(
//   String url,
//   dynamic body, {
//   T Function(dynamic)? transform,
//   required String accessToken,
//   String? profileType,
//   Options? options,
// }) async {
//   transform ??= (dynamic r) => r.body as T;
//   final ApiResponse<T> apiResponse = ApiResponse<T>();
//
//   try {
//     dio.options.headers['accept'] = 'application/json';
//     dio.options.headers['ProfileType'] = profileType;
//     dio.options.headers['Authorization'] = 'Bearer $accessToken';
//     final res = await dio.delete({dotenv.env["BASE_URL"]} + url, data: body, options: options);
//     final dynamic data = res.data;
//
//     if (res.statusCode == 200) {
//       apiResponse.responseBody = transform(data);
//       apiResponse.responseSuccessful = true;
//       apiResponse.responseMessage = data['responseMessage'];
//     } else {
//       apiResponse.responseSuccessful = false;
//       apiResponse.responseMessage =
//           (data['responseMessage'] ?? 'Error encountered');
//     }
//   } on DioException catch (e) {
//     if (kDebugMode) {
//       print(e.response?.data);
//     }
//     apiResponse.responseSuccessful = false;
//     apiResponse.responseMessage = e.response?.data['responseMessage'];
//   } on SocketException catch (_) {
//     apiResponse.responseSuccessful = false;
//     apiResponse.responseMessage = "An Error occurred";
//   }
//   return apiResponse;
// }
}
