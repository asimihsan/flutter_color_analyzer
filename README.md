# flutter_color_analyzer

[![Build Status](https://api.travis-ci.com/asimihsan/flutter_color_analyzer.svg?branch=master)](https://travis-ci.com/github/asimihsan/flutter_color_analyzer/)
[![codecov](https://codecov.io/gh/asimihsan/flutter_color_analyzer/branch/master/graph/badge.svg)](https://codecov.io/gh/asimihsan/flutter_color_analyzer)
[![pub points](https://badges.bar/flutter_color_analyzer/pub%20points)](https://pub.dev/packages/flutter_color_analyzer/score)

`flutter_color_analyzer` offers utilities for analyzing perceptual differences between colors in order to choose optimal color palettes in an accessible way.


## Examples

### `ColorAnalyzer.noticeablyDifferent`

Based on \[1\] determine if two colors are noticeably different or not. By default use a model
that empirically matches results for 50% of observers noticing a different for color patches with
a visual angle of 0.1 degrees (around 0.05cm size viewed from 30cm distance).

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

## References

1. Stone, Maureen C., Danielle Albers Szafir and Vidya Setlur. [“An Engineering Model for Color
   Difference as a Function of Size.”](http://www.danielleszafir.com/2014CIC_48_Stone_v3.pdf) (2014).