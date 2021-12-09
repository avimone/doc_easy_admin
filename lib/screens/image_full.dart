import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageFull extends StatefulWidget {
  static const routeName = '/imageFull';

  var url;
  ImageFull(this.url);

  @override
  _ImageFullState createState() => _ImageFullState();
}

class _ImageFullState extends State<ImageFull> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        margin: const EdgeInsets.only(top: 25, bottom: 15),
        child: CachedNetworkImage(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.contain,
          imageUrl: widget.url,
          placeholder: (context, url) =>
              Center(child: new CircularProgressIndicator()),
          errorWidget: (context, url, error) => new Icon(Icons.error),
        ),
      ),
    );
  }
}
