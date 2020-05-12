### `ColorAnalyzer.noticeablyDifferent`

Based on \[1\] determine if two colors are noticeably different or not. By default use a model
that empirically matches results for 50% of observers noticing a different for color patches with
a visual angle of 0.1 degrees (around 0.5cm size viewed from 30cm distance).

```dart
import 'package:flutter/material.dart';
import 'package:flutter_color_analyzer/big_color.dart';

void main() {
    final lightBlueAccent = BigColor.fromColor(Colors.lightBlueAccent);
    final lightBlue = BigColor.fromColor(Colors.lightBlue);
    final areNoticeablyDifferent = ColorAnalyzer.noticeablyDifferent(lightBlueAccent, lightBlue);

    // areNoticeablyDifferent is false, because based on the model 50% of observers do not
    // notice a different between lightBlueAccent and lightBlue with a visual angle of 0.1
    // degrees
}
```

### References

1. Stone, Maureen C., Danielle Albers Szafir and Vidya Setlur. “An Engineering Model for Color
   Difference as a Function of Size.” (2014).