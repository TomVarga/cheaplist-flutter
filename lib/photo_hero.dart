import 'package:cached_network_image/cached_network_image.dart';
import 'package:cheaplist/constants.dart';
import 'package:cheaplist/dto/daos.dart';
import 'package:cheaplist/user_settings_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PhotoHero extends StatelessWidget {
  const PhotoHero({Key key, this.item, this.thumbnail, this.width})
      : super(key: key);

  final MerchantItem item;
  final double width;
  final bool thumbnail;

  Widget build(BuildContext context) {
    return new SizedBox(
      width: width,
      child: new Hero(
        tag: item.merchantId + '/' + item.id,
        child: new Material(
          color: Colors.transparent,
          child: new InkWell(
            child: buildImage(context),
          ),
        ),
      ),
    );
  }

  Widget buildImage(BuildContext context) {
    if (imageDownloadingDisabled) {
      return new Icon(
        Icons.image,
        color: theme(context).accentColor,
      );
    }
    if (item.thumbnail == null && item.imageURL == null) {
      return new Icon(Icons.broken_image, color: theme(context).accentColor);
    }
    return getStack();
  }

  Widget getStack() {
    if (thumbnail) {
      if (kIsWeb) {
        return new Image(
            image: new NetworkImage(item.thumbnail), fit: BoxFit.contain);
      } else {
        return new CachedNetworkImage(
          imageUrl: item.thumbnail,
          fit: BoxFit.contain,
        );
      }
    } else {
      return new Stack(
        children: getStackImages(),
      );
    }
  }

  List<Widget> getStackImages() {
    if (kIsWeb) {
      return <Widget>[
        Image(
          image: new NetworkImage(item.thumbnail),
          fit: BoxFit.contain,
        ),
        Image(
          image: new NetworkImage(thumbnail ? item.thumbnail : item.imageURL),
          fit: BoxFit.contain,
        ),
      ];
    } else {
      return <Widget>[
        new CachedNetworkImage(
          imageUrl: item.thumbnail,
          fit: BoxFit.contain,
        ),
        new CachedNetworkImage(
          imageUrl: thumbnail ? item.thumbnail : item.imageURL,
          fit: BoxFit.contain,
        )
      ];
    }
  }
}
