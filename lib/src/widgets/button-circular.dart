import 'package:flutter/material.dart';
import 'package:work_witness/src/widgets/loading_Indicator.dart';

class ButtonCircular extends StatelessWidget {
  final bool loading;
  final Color color;
  final Color textColor;
  final IconData icon;
  final double buttomSize;
  final double iconSize;
  final double loadingSize;
  final Function tap;

  ButtonCircular({
    @required this.loading,
    @required this.color,
    @required this.textColor,
    @required this.icon,
    @required this.buttomSize,
    @required this.iconSize,
    @required this.loadingSize,
    @required this.tap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: !loading
          ? ClipOval(
              child: Material(
                  color: color, // button color
                  child: InkWell(
                    splashColor: textColor, // inkwell color
                    child: SizedBox(
                        width: buttomSize,
                        height: buttomSize,
                        child: Icon(
                          icon,
                          size: iconSize,
                          color: textColor,
                        )),
                    onTap: tap,
                  )),
            )
          : LoadingIndicator(size: loadingSize),
    );
  }
}
