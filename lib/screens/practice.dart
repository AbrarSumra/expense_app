import 'package:flutter/material.dart';

class MyScrollingContainer extends StatefulWidget {
  @override
  _MyScrollingContainerState createState() => _MyScrollingContainerState();
}

class _MyScrollingContainerState extends State<MyScrollingContainer> {
  double containerHeight = 200.0; // Initial height of the container

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollUpdateNotification>(
        onNotification: (notification) {
          if (notification.scrollDelta! > 0) {
            // Scrolling down, increase container height
            setState(() {
              containerHeight = (containerHeight + notification.scrollDelta!)
                  .clamp(20.0,
                      400.0); // Ensure height is within the specified range
            });
          } else if (notification.scrollDelta! < 0) {
            // Scrolling up, decrease container height
            setState(() {
              containerHeight = (containerHeight - notification.scrollDelta!)
                  .clamp(20.0,
                      400.0); // Ensure height is within the specified range
            });
          }
          return true;
        },
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 200.0, // Initial height of the app bar
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Scrolling Container'),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    height: containerHeight,
                    color: Colors.blue,
                    child: Center(
                      child: Text('Scroll down to increase height'),
                    ),
                  );
                },
                childCount: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
