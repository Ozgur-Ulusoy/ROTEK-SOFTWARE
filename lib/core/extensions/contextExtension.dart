import 'package:flutter/cupertino.dart';

extension DimonsionExtension on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
}
