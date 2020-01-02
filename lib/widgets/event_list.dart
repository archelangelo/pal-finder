import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart' as http;
import 'package:pal_finder/widgets/event_card.dart';
import 'package:pal_finder/data/event.dart';
import 'package:pal_finder/core/networking.dart';

class EventList extends StatefulWidget {
  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  final _eventList = <EventData>[];
  final _eventFetcher = EventFetcher(-33.870481, 151.195697, 0.5);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Color.fromRGBO(128, 128, 128, 1)),
      child: ListView.builder(
        itemCount: _eventList.length + 1,
        itemBuilder: (context, index) {
          print('called list builder inside $context with index $index');
          if (index >= _eventList.length) {
            _eventFetcher.fetchNextPage(context).then((List<EventData> newList) {
              setState(() {
                print('setState()');
                _eventList.addAll(newList);
              });
            });
            return Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: Text('Loading...'),
            );
          }
          final event = _eventList[index];
          return EventCard(
            event: event,
          );
        },
      ),
    );
  }
}

class EventFetcher {
  EventFetcher(this._lat, this._lng, this._dist) {
    _nextUrl ='${_networking.host}/apis/events/nearby/?lng=${_lng.toStringAsFixed(6)}&lat=${_lat.toStringAsFixed(6)}&dist=${_dist.toStringAsFixed(3)}';
  }

  final double _lat;
  final double _lng;
  final double _dist;
  final Networking _networking = Networking();
  String _nextUrl;

  Future<List<EventData>> fetchNextPage(BuildContext context) async {
    final eventList = <EventData>[];
    if (_nextUrl != null) {
      print('using Networking to get');
      final response = await _networking.get(_nextUrl);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final list = data['results'] as List;
        list.forEach((eventMap) {
          eventList.add(EventData.fromMap(eventMap));
        });
        _nextUrl = data['next'];
      } else {
        _networking.handleResponseCode(context, response.statusCode);
      }
    }
    return eventList;
  }
}
