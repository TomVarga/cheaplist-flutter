import 'package:cheaplist/dto/daos.dart';
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
    if (item.thumbnail == null && item.imageURL == null) {
      return new Image.asset('graphics/image-broken-variant.png');
    }
    return getStack();
  }

  Widget getStack() {
    if (thumbnail) {
      return new Image.network(
        item.thumbnail,
        fit: BoxFit.contain,
      );
    } else {
      return new Stack(
        children: <Widget>[
          new Image.network(
            item.thumbnail,
            fit: BoxFit.contain,
          ),
          new Image.network(
            thumbnail ? item.thumbnail : item.imageURL,
            fit: BoxFit.contain,
          )
        ],
      );
    }
  }
}
