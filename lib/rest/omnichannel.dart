part of rest;

abstract class _ClientOmnichannelMixin implements _ClientWrapper {
  Future<RoomMessageHistory> liveChatMessagesHistory(
    String roomId,
    String token, {
    DateTime ts,
    DateTime end,
    int limit,
  }) {
    Completer<RoomMessageHistory> completer = Completer();

    StringBuffer query = StringBuffer('token=$token');

    if (ts != null) {
      query.write('&ts=${ts.toUtc().toIso8601String()}');
    }

    if (end != null) {
      query.write('&end=${end.toUtc().toIso8601String()}');
    }

    if (limit != null) {
      query.write('&limit=$limit');
    }

    http
        .get('${_getUrl()}/livechat/messages.history/$roomId?${query.toString()}')
        .then((response) {
      _hackResponseHeader(response);

      final raws = json.decode(response.body)['messages'];

      RoomMessageHistory results = RoomMessageHistory.fromJson(raws);

      completer.complete(results);
    }).catchError((error) => completer.completeError(error));

    return completer.future;
  }
}
