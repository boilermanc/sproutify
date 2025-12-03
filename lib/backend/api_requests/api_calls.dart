import 'dart:convert';
import 'dart:typed_data';
import '../schema/structs/index.dart';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import '/config/env.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start neightn main chat Group Code

class NeightnMainChatGroup {
  static String getBaseUrl() =>
      'https://n8n.sproutify.app/webhook/a9aae518-ec85-4b0d-b2cb-5e6f64c5783d';
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
  static SendFullPromptCall sendFullPromptCall = SendFullPromptCall();
}

class SendFullPromptCall {
  Future<ApiCallResponse> call({
    dynamic promptJson,
    String? userMessage = '',
    String? userID = '',
  }) async {
    final baseUrl = NeightnMainChatGroup.getBaseUrl();

    final prompt = _serializeJson(promptJson);
    final ffApiRequestBody = '''
{
  "chatInput": "\${$userMessage}",
  "userID": "$userID",
  "sessionId": "$userID"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Send Full Prompt',
      apiUrl: '$baseUrl/chat',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  int? createdTimestamp(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.created''',
      ));
  String? role(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.choices[:].message.role''',
      ));
  String? content(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.choices[:].message.content''',
      ));
}

/// End neightn main chat Group Code

class UpsertRatingsCall {
  static Future<ApiCallResponse> call({
    int? plantID,
    String? userID = '',
    double? rating,
    int? userPlantID,
  }) async {
    final ffApiRequestBody = '''
{
  "input_plant_id": "$plantID",
  "input_user_id": "$userID",
  "input_rating": "$rating",
  "input_user_plant_id": "$userPlantID"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'upsertRatings',
      apiUrl:
          'https://xzckfyipgrgpwnydddev.supabase.co/rest/v1/rpc/upsert_or_ignore_plant_rating',
      callType: ApiCallType.POST,
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6Y2tmeWlwZ3JncHdueWRkZGV2Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY5ODA4NzY1MywiZXhwIjoyMDEzNjYzNjUzfQ.2US-amcxP5WJ1li8GStRMqgYHHPqP6lUVhEtzRsZs7Q',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6Y2tmeWlwZ3JncHdueWRkZGV2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTgwODc2NTMsImV4cCI6MjAxMzY2MzY1M30._EnLLfn0DqX5uC94ZegKtfvz4uZW2bzWQidjqaYUsOo',
        'Prefer': 'resolution=merge-duplicates',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class FetchNewNotficationsCall {
  static Future<ApiCallResponse> call({
    String? userID = '',
  }) async {
    final ffApiRequestBody = '''
{
  "_user_id": "$userID"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'fetchNewNotfications',
      apiUrl:
          'https://xzckfyipgrgpwnydddev.supabase.co/rest/v1/rpc/check_if_new_notifications_exist',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6Y2tmeWlwZ3JncHdueWRkZGV2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTgwODc2NTMsImV4cCI6MjAxMzY2MzY1M30._EnLLfn0DqX5uC94ZegKtfvz4uZW2bzWQidjqaYUsOo',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic notificationStatus(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
}

class TotalPlantCostPerUserCall {
  static Future<ApiCallResponse> call({
    String? userID = '',
  }) async {
    final ffApiRequestBody = '''
{
  "_user_id": "$userID"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Total Plant Cost Per User',
      apiUrl:
          'https://xzckfyipgrgpwnydddev.supabase.co/rest/v1/rpc/get_plant_costs',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6Y2tmeWlwZ3JncHdueWRkZGV2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTgwODc2NTMsImV4cCI6MjAxMzY2MzY1M30._EnLLfn0DqX5uC94ZegKtfvz4uZW2bzWQidjqaYUsOo',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6Y2tmeWlwZ3JncHdueWRkZGV2Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY5ODA4NzY1MywiZXhwIjoyMDEzNjYzNjUzfQ.2US-amcxP5WJ1li8GStRMqgYHHPqP6lUVhEtzRsZs7Q',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class TotalSupplyCostPerUserCall {
  static Future<ApiCallResponse> call({
    String? userID = '',
  }) async {
    final ffApiRequestBody = '''
{
  "_user_id": "$userID"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Total Supply Cost Per User',
      apiUrl:
          'https://xzckfyipgrgpwnydddev.supabase.co/rest/v1/rpc/get_supply_costs',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6Y2tmeWlwZ3JncHdueWRkZGV2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTgwODc2NTMsImV4cCI6MjAxMzY2MzY1M30._EnLLfn0DqX5uC94ZegKtfvz4uZW2bzWQidjqaYUsOo',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6Y2tmeWlwZ3JncHdueWRkZGV2Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY5ODA4NzY1MywiZXhwIjoyMDEzNjYzNjUzfQ.2US-amcxP5WJ1li8GStRMqgYHHPqP6lUVhEtzRsZs7Q',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class PerUserPlantCostPerCatagoryCall {
  static Future<ApiCallResponse> call({
    String? userID = '',
    String? categoryIDs = '',
  }) async {
    final ffApiRequestBody = '''
{
  "_user_id": "$userID",
  "_category_ids": "$categoryIDs" [
    1,
    2,
    3,
    4
  ]
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Per User Plant Cost Per Catagory',
      apiUrl:
          'https://xzckfyipgrgpwnydddev.supabase.co/rest/v1/rpc/calculate_yearly_category_cost',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6Y2tmeWlwZ3JncHdueWRkZGV2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTgwODc2NTMsImV4cCI6MjAxMzY2MzY1M30._EnLLfn0DqX5uC94ZegKtfvz4uZW2bzWQidjqaYUsOo',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6Y2tmeWlwZ3JncHdueWRkZGV2Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY5ODA4NzY1MywiZXhwIjoyMDEzNjYzNjUzfQ.2US-amcxP5WJ1li8GStRMqgYHHPqP6lUVhEtzRsZs7Q',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class PlantCatalogSearchCall {
  static Future<ApiCallResponse> call({
    String? searchString = '',
  }) async {
    // Build the API URL - if searchString is empty, get all plants
    // Otherwise, filter by plant_name
    final searchStringParam = (searchString?.isEmpty ?? true) 
        ? '' 
        : 'plant_name=ilike.*${Uri.encodeComponent(searchString!)}*&';
    final apiUrl = 'https://xzckfyipgrgpwnydddev.supabase.co/rest/v1/plants?${searchStringParam}select=*&order=plant_name.asc';
    
    return ApiManager.instance.makeApiCall(
      callName: 'plantCatalogSearch',
      apiUrl: apiUrl,
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6Y2tmeWlwZ3JncHdueWRkZGV2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTgwODc2NTMsImV4cCI6MjAxMzY2MzY1M30._EnLLfn0DqX5uC94ZegKtfvz4uZW2bzWQidjqaYUsOo',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6Y2tmeWlwZ3JncHdueWRkZGV2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTgwODc2NTMsImV4cCI6MjAxMzY2MzY1M30._EnLLfn0DqX5uC94ZegKtfvz4uZW2bzWQidjqaYUsOo',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? plantName(dynamic response) => (getJsonField(
        response,
        r'''$[:].plant_name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<int>? plantID(dynamic response) => (getJsonField(
        response,
        r'''$[:].plant_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
}

class CategoryCostPerUserCall {
  static Future<ApiCallResponse> call({
    String? useriD = '',
  }) async {
    final ffApiRequestBody = '''
{
  "_userid": "$useriD"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'CategoryCost Per User',
      apiUrl:
          'https://xzckfyipgrgpwnydddev.supabase.co/rest/v1/rpc/calculate_all_yearly_costs_by_category',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6Y2tmeWlwZ3JncHdueWRkZGV2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTgwODc2NTMsImV4cCI6MjAxMzY2MzY1M30._EnLLfn0DqX5uC94ZegKtfvz4uZW2bzWQidjqaYUsOo',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6Y2tmeWlwZ3JncHdueWRkZGV2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTgwODc2NTMsImV4cCI6MjAxMzY2MzY1M30._EnLLfn0DqX5uC94ZegKtfvz4uZW2bzWQidjqaYUsOo',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? categoryName(dynamic response) => (getJsonField(
        response,
        r'''$[:].category_name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<int>? categoryID(dynamic response) => (getJsonField(
        response,
        r'''$[:].category_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  static List<int>? yearlyCatCost(dynamic response) => (getJsonField(
        response,
        r'''$[:].yearly_category_cost''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
}

class FAQSearchCall {
  static Future<ApiCallResponse> call({
    String? searchString = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'FAQ Search',
      apiUrl:
          'https://xzckfyipgrgpwnydddev.supabase.co/rest/v1/tower_faq?or=(question.ilike.*$searchString*,answer.ilike.*$searchString*,links.ilike.*$searchString*)&select=*',
      callType: ApiCallType.GET,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6Y2tmeWlwZ3JncHdueWRkZGV2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTgwODc2NTMsImV4cCI6MjAxMzY2MzY1M30._EnLLfn0DqX5uC94ZegKtfvz4uZW2bzWQidjqaYUsOo',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6Y2tmeWlwZ3JncHdueWRkZGV2Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY5ODA4NzY1MywiZXhwIjoyMDEzNjYzNjUzfQ.2US-amcxP5WJ1li8GStRMqgYHHPqP6lUVhEtzRsZs7Q',
        'Content-Type': 'application/json',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class FAQIndexSearchCall {
  static Future<ApiCallResponse> call({
    String? searchterm = '',
  }) async {
    final ffApiRequestBody = '''
{
  "searchterm": "$searchterm"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'FAQ Index Search',
      apiUrl:
          'https://xzckfyipgrgpwnydddev.supabase.co/rest/v1/rpc/search_tower_faq',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6Y2tmeWlwZ3JncHdueWRkZGV2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTgwODc2NTMsImV4cCI6MjAxMzY2MzY1M30._EnLLfn0DqX5uC94ZegKtfvz4uZW2bzWQidjqaYUsOo',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6Y2tmeWlwZ3JncHdueWRkZGV2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTgwODc2NTMsImV4cCI6MjAxMzY2MzY1M30._EnLLfn0DqX5uC94ZegKtfvz4uZW2bzWQidjqaYUsOo',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CoralChatCall {
  static Future<ApiCallResponse> call({
    String? inputContent = '',
  }) async {
    final ffApiRequestBody = '''
{
  "chat_history": [],
  "message": "$inputContent"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Coral Chat',
      apiUrl: 'https://api.cohere.ai/v1/chat',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer rvaaPLWrGZbbx1Ogf3gX3DvVgCNJl1Xwjp8NodEZ',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? coralRespone(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.text''',
      ));
}

class AddNewSubscriberInMailerLiteCall {
  static Future<ApiCallResponse> call({
    String? firstName = '',
    String? lastName = '',
    String? email = '',
    String? experience = '',
    String? postalCode = '',
    String? groupID = '',
  }) async {
    final ffApiRequestBody = '''
{
  "email": "$email",
  "fields": {
    "name": "$firstName",
    "last_name": "$lastName",
    "experience": "$experience",
    "z_i_p": "$postalCode"
  },
  "groups": [
    "113457793189545748",
    "$groupID"
  ]
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Add New Subscriber In MailerLite',
      apiUrl: 'https://connect.mailerlite.com/api/subscribers',
      callType: ApiCallType.POST,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization':
            'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI0IiwianRpIjoiNGQzNjA2YWRhMzNlYWNhZjcwNjc5YmVlOTM1NDlmNDFhOTM1MGE5YmI2M2Q3MmU5ODBjZWYxMWQwMDdlY2Q4MmY4ODU4MjM2NzdjMDE3ODUiLCJpYXQiOjE3MDgwMTU1NDcuNTAwNDQ4LCJuYmYiOjE3MDgwMTU1NDcuNTAwNDUsImV4cCI6NDg2MzY4OTE0Ny40OTc1NDcsInN1YiI6Ijg0MDQzNCIsInNjb3BlcyI6W119.lQO8iLiR22DngoCWL_JTE-B-k9YdrL9oYhNx4xbc5HMx4XSg44OpgjkNoAEN2TbjHFx73Xm7B1m9nIBWOgnG5ML-t2NZtBZXHvgvqDOf-XrwEFcaxEzZOGRWm6-YdGhPY_700NVcdc5AkEweHmzrIrqKxcotSv_2-BWJvsxqPjJtypTzxMAQZa_395jxDSZ_6Vk3m1UcEidEWgdjgH51xrSNIcm48w8LwvDeWSObEUYpPm9H0AqgyZ3KHCiKwZrH6ZL4tTT2y_8Jx5j_4p_xj4Hf7iIGrdhTXpep6YIFXrLrGOIBUnUI1NLjkDjn0ookOOIWtda43GqyeUlCxrTE4BsZ9GfxRHy2O6aqa4F4Ip_IQ_fYsHRn5Zf3D_KmcQ-RhiYGiEsyvpBWtTfhV-Fe6sNNUXmHdrIS-qyS4YY-836_wG08qT7gVKeLwmJ8a2bh-Cv_CWG4j3ywmzNFAjUabqXaXW-ONROqbS1cPYAkZGkQQE6BYwp7Fy7yNwyubU615Xa0ebYxNI3Jq8kWoTWl71spQYDcjYqw4HjzaPQB9oozC3dSB7GcDhGTQUtXQH7fxMqmF5oGf44YQX9OWQ4OnfK58GdvfK-XNBCRHGTXPf7oqIKKi2QxvPPiS0bpZz2RvAG-G3LonY_i2gt4E6iN30BE0zie1eojnuzX3jtxjCo',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? email(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.email''',
      ));
  static String? lastname(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.fields.last_name''',
      ));
  static String? name(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.fields.name''',
      ));
  static String? experience(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.data.fields.experience''',
      ));
}

class TomorrowIOWeatherCall {
  static Future<ApiCallResponse> call({
    String? zipcode = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'Tomorrow IO Weather',
      apiUrl:
          'https://api.tomorrow.io/v4/weather/realtime?location=*$zipcode*&units=imperial',
      callType: ApiCallType.GET,
      headers: {
        'Accept': 'application/json',
        'apikey': 'btIwdDjQM1nD2nRzm5vNzj2WO1zwQnS8',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetNotificationsCall {
  static Future<ApiCallResponse> call({
    String? userID = '',
  }) async {
    final ffApiRequestBody = '''
{
  "user_uuid": "$userID"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'GetNotifications',
      apiUrl:
          'https://xzckfyipgrgpwnydddev.supabase.co/rest/v1/rpc/get_active_user_notifications',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6Y2tmeWlwZ3JncHdueWRkZGV2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTgwODc2NTMsImV4cCI6MjAxMzY2MzY1M30._EnLLfn0DqX5uC94ZegKtfvz4uZW2bzWQidjqaYUsOo',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ArchiveNotificationsCall {
  static Future<ApiCallResponse> call({
    String? userID = '',
    String? notificationID = '',
  }) async {
    final ffApiRequestBody = '''
{
  "user_uuid": "$userID",
  "notification_id_arg": "$notificationID"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'ArchiveNotifications',
      apiUrl:
          'https://xzckfyipgrgpwnydddev.supabase.co/rest/v1/rpc/archive_user_notification',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6Y2tmeWlwZ3JncHdueWRkZGV2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTgwODc2NTMsImV4cCI6MjAxMzY2MzY1M30._EnLLfn0DqX5uC94ZegKtfvz4uZW2bzWQidjqaYUsOo',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetArchiveNotificationsCall {
  static Future<ApiCallResponse> call({
    String? userID = '',
  }) async {
    final ffApiRequestBody = '''
{
  "_user_id": "$userID"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'GetArchiveNotifications',
      apiUrl:
          'https://xzckfyipgrgpwnydddev.supabase.co/rest/v1/rpc/get_archived_user_notifications',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6Y2tmeWlwZ3JncHdueWRkZGV2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTgwODc2NTMsImV4cCI6MjAxMzY2MzY1M30._EnLLfn0DqX5uC94ZegKtfvz4uZW2bzWQidjqaYUsOo',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DeleteNotficationsCall {
  static Future<ApiCallResponse> call({
    String? userID = '',
    String? notificationID = '',
  }) async {
    final ffApiRequestBody = '''
{
  "notification_id_arg": "$notificationID",
  "user_uuid": "$userID"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'DeleteNotfications',
      apiUrl:
          'https://xzckfyipgrgpwnydddev.supabase.co/rest/v1/rpc/delete_user_notification',
      callType: ApiCallType.POST,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6Y2tmeWlwZ3JncHdueWRkZGV2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTgwODc2NTMsImV4cCI6MjAxMzY2MzY1M30._EnLLfn0DqX5uC94ZegKtfvz4uZW2bzWQidjqaYUsOo',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CohereTestAPICall {
  static Future<ApiCallResponse> call({
    String? message = '',
  }) async {
    final ffApiRequestBody = '''
{
  "model": "75cd83ef-8816-4019-81dc-45c5b4779782-ft",
  "message": "$message"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'CohereTestAPI',
      apiUrl: 'https://api.cohere.ai/v1/chat',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer rvaaPLWrGZbbx1Ogf3gX3DvVgCNJl1Xwjp8NodEZ',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class SendEmailWithResendCall {
  static Future<ApiCallResponse> call({
    String? emailAddress = '',
    String? emailSubject = '',
    String? htmlContent = '',
    String? fromEmail = '',
  }) async {
    final ffApiRequestBody = '''
{
  "from": "${escapeStringForJson(fromEmail)}",
  "to": "${escapeStringForJson(emailAddress)}",
  "subject": "${escapeStringForJson(emailSubject)}",
  "html": "${escapeStringForJson(htmlContent)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Send Email with Resend',
      apiUrl: 'https://api.resend.com/emails',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${Env.resendApiKey}',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\t', '\\t');
}
