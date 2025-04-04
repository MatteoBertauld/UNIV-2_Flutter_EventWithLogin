import 'dart:io';

import 'package:event_poll/configs.dart';
import 'package:event_poll/models/poll.dart';
import 'package:event_poll/result.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PollsState with ChangeNotifier {
  String? _token;

  Poll? _currentPoll;
  Poll? get currentPoll => _currentPoll;

  Map<int, Poll> _polls = {};
  Iterable<Poll> get polls => _polls.values;
  String? errorMessage;

  void setAuthToken(String? token) {
    _token = token;
  }

  Future<Result<Iterable<Poll>, String>> fetchAllPolls() async {
    try {
      final response = await http.get(
        Uri.parse('${Configs.baseUrl}/polls'),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $_token'},
      );

      if (response.statusCode == HttpStatus.ok) {
        final data = (json.decode(response.body) as Iterable<dynamic>)
            .map((e) => Poll.fromJson(e));
        _polls = {for (var p in data) p.id: p};

        return Result.success(_polls.values);
      } else {
        return Result.failure('Failed to load polls: ${response.statusCode}');
      }
    } catch (e) {
      return Result.failure('An error occurred: $e');
    }
  }
}
