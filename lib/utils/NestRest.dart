import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../ProjectEnv.dart';

class NestRest {
  static Future<Response> get(url) {
    print("Getting data from ${url} using token ${ProjectEnv.token}");
    return http.get(url, headers: {
      "Authorization": "Bearer ${ProjectEnv.token}",
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    }).then((response) {
      if (response.statusCode == 200) {
        print(response.statusCode);
        print("Content Length= $response.contentLength");
        print(response.headers);
        print(response.request);
        print(response.body);

        return response;
      } else {
        print("${response.statusCode} No response from backend  server");
        return (null);
      }
    });
  }
}
