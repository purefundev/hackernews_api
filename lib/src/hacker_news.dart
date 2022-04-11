import 'dart:convert';

import 'package:hackernews_api/helper/constants.dart';
import 'package:hackernews_api/helper/enums.dart';
import 'package:hackernews_api/helper/exception.dart';
import 'package:hackernews_api/model/comment.dart';
import 'package:hackernews_api/model/story.dart';
import 'package:http/http.dart' as http;

class HackerNews {
  HackerNews({
    this.newsType = NewsType.topStories,
  });

  ///Specify news type
  ///
  ///[NewsType.topStories]
  ///[NewsType.askstories]
  ///[NewsType.newStories]
  ///[NewsType.showstories]
  ///[NewsType.jobstories]
  ///
  /// default is
  ///[NewsType.topStories]
  final NewsType newsType;

  ///Function used to access stories which returns `List<Story>`
  Future<List<Story>> getStories() async {
    final List<http.Response> responses = await _getStories();

    final List<Story> stories = responses.map((response) {
      final json = jsonDecode(response.body);

      return Story.fromJson(json);
    }).toList();

    return stories;
  }

  ///Function used to access story kids and return `List<Comments>`
  Future<List<Comment>> getComments(List<dynamic> kidIds) async {
    final List<http.Response> responses = await _getComments(kidIds);

    final List<Comment> stories = responses.map((response) {
      final json = jsonDecode(response.body);

      return Comment.fromJson(json);
    }).toList();

    return stories;
  }

  Future<List<http.Response>> _getStories() async {
    final response = await http.get(storyUrl(newsType));

    if (response.statusCode == 200) {
      Iterable storyIds = jsonDecode(response.body);

      return Future.wait(storyIds.take(30).map((storyId) {
        return _getStory(storyId);
      }));
    } else {
      throw NewsException("Unable to fetch data! ${response.statusCode}");
    }
  }

  Future<http.Response> _getStory(int storyId) {
    return http.get(urlForStory(storyId));
  }

  Future<List<http.Response>> _getComments(List<dynamic> kidIds) async {
    return Future.wait(kidIds.take(30).map((kidId) {
      return http.get(urlForStory(kidId));
    }));
  }
}
