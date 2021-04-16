import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_dart/src/client/stream_client.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';
import 'package:stream_feed_dart/src/core/models/realtime_message.dart';
import 'package:stream_feed_dart/stream_feed.dart';
import 'package:test/test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Functions {
  WebSocketChannel? connectFunc(
    String url, {
    Iterable<String>? protocols,
    Duration? connectionTimeout,
  }) =>
      null;

// void handleFunc(Event event) => null;
}

class MockFunctions extends Mock implements Functions {}

class MockWSChannel extends Mock implements WebSocketChannel {}

class MockWSSink extends Mock implements WebSocketSink {}

void main() async {
  test('FayeClient', () async {
    const apiKey = 'ay57s8swfnan';
    const appId = '110925';

    final client = StreamClient.connect(apiKey,
        secret:
            'ajencvb6gfrbzvt2975kk3563j3vg86fhrswjsbk32zzgjcgtfn3293er4tk9bf4',
        appId: appId);
    const userId = '1';
    const slug = 'reward';
    final userFeed = client.flatFeed(slug, userId);

    RealtimeMessage? realTimeMessage;
    final subscription =
        await userFeed.subscribe((message) => realTimeMessage = message);

    var activity = Activity(
      actor: '$slug:$userId',
      verb: 'tweet',
      object: 'tweet:id',
      to: <FeedId>[FeedId.id('notification:jessica')],
      extraData: const {
        'message': "@Jessica check out getstream.io it's so dang awesome.",
      },
    );
    activity = await userFeed.addActivity(activity);

    await Future.delayed(const Duration(seconds: 3));

    expect(realTimeMessage, isNotNull);
    expect(realTimeMessage!.newActivities.first.id, activity.id);

    addTearDown(subscription.cancel);
  });
}
