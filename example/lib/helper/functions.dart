import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:example/model/model.dart';
import 'package:flutter/foundation.dart';

String getError({
  required Object error,
  required StackTrace trace,
}) {
  if (error is DioException) {
    // Logging the error and stack trace for debugging purposes
    if (kDebugMode) {
      log('${error.response}');
    }
    if (error.response != null && error.response?.data is Map) {
      var err = CustomError.fromJson(error.response?.data);
      return err.message ?? 'Something went wrong';
    } else {
      if (error.type == DioExceptionType.connectionError) {
        return 'Check your internet connection';
      } else if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return 'Request took too long';
      } else if (error.type == DioExceptionType.cancel) {
        return 'Request was cancelled';
      } else {
        return 'An unexpected error occurred.';
      }
    }
  }
  if (kDebugMode) {
    log('$error');
    log('$trace');
  }
  return 'Something went wrong';
}
