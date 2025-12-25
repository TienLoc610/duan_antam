import 'package:flutter/material.dart';

class FeatureListWidget extends StatelessWidget {
  final List<String> features;
  final Color checkColor;
  final Color textColor;

  const FeatureListWidget({
    super.key,
    required this.features,
    required this.checkColor,
    this.textColor = const Color(0xFF354152),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '✓',
                style: TextStyle(
                  color: checkColor,
                  fontSize: 16,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
              SizedBox(width: 8.0),
              Flexible(
                child: Text(
                  feature,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontFamily: 'Arimo',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}