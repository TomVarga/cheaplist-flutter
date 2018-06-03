import 'package:cached_network_image/cached_network_image.dart';
import 'package:cheaplist/dto/daos.dart';
import 'package:cheaplist/user_settings_manager.dart';
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
            child: buildImage(),
          ),
        ),
      ),
    );
  }

  Widget buildImage() {
    if (imageDownloadingDisabled) {
      return new Icon(Icons.image);
    }
    if (item.thumbnail == null && item.imageURL == null) {
      return new Icon(Icons.broken_image);
    }
    return getStack();
  }

  Widget getStack() {
    if (thumbnail) {
      return new CachedNetworkImage(
        imageUrl: item.thumbnail,
        fit: BoxFit.contain,
      );
    } else {
      return new Stack(
        children: <Widget>[
          new CachedNetworkImage(
            imageUrl: item.thumbnail,
            fit: BoxFit.contain,
          ),
          new CachedNetworkImage(
            imageUrl: thumbnail ? item.thumbnail : item.imageURL,
            fit: BoxFit.contain,
          )
        ],
      );
    }
  }
}
