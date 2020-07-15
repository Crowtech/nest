import 'dart:convert';
import 'dart:io';

import 'package:aible/login/Token.dart';
import 'package:aible/models/AUser.dart';
import 'package:aible/models/Email.dart';
//import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:async';

import '../Device.dart';
import '../ProjectEnv.dart';

class Registration {
  Registration() {
    //initPlatformState().whenComplete(() => null);
    //_performRegistration();
  }

  static Future<AUser> register(String firstname, String lastname, Email email,
      String password, String username, String roles, String grouproles) async {
    AUser user = new AUser();
    user.email = email;
    user.firstname = firstname;
    user.lastname = lastname;
    user.username = username;

    // user = await Token.performLogin(username, password);

    user = await performRegistration(user, password, roles, grouproles);
    return user;
  }

  static Future<AUser> performRegistration(
      AUser user, String password, String roles, String grouproles) async {
    print(
        "POSTING REGISTRATION DATA TO ${ProjectEnv.registrationUrl} *************************************");
    var json = jsonEncode(user);
    // make POST request
    print("Posting User Data $json");

    String keycloakRegistrationUrl = ProjectEnv.registrationUrl +
        "?password=" +
        password +
        "&roles=" +
        roles +
        "&grouproles=" +
        grouproles;
    print("reg url = $keycloakRegistrationUrl");
    Response response =
        await Registration.postHTTP(keycloakRegistrationUrl, json);
    if (response.statusCode == 200) {
      print(response.statusCode);
      print("Content Length= $response.contentLength");
      print(response.headers);
      print(response.request);

      user = AUser.convertFromJson(response.body);
    } else {
      print("Error: cannot register " + response.reasonPhrase);
    }
    return user;
  }

  static Future<Response> postHTTP(url, data) async {
    //   //  var token = ProjectEnv.token;

    return http
        .post(url,
            headers: {
              'Content-Type': 'application/json',
            },
            body: data)
        .then((response) {
      return (response);
    });
  }
}
