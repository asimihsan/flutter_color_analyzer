// ============================================================================
//  Copyright 2020 Asim Ihsan. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License in the LICENSE file and at
//
//      https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
// ============================================================================

// References
//
// [1] https://github.com/d3/d3-color/blob/master/src/lab.js
// [2] https://observablehq.com/@mbostock/lab-and-rgb

import 'dart:math';

import 'package:flutter/material.dart';

// ColorFunctions adds a namespace around some constants and methods use to e.g. calculate
// L*a*b* components.
class ColorFunctions {
  static double xN = 0.96422,
      yN = 1.0,
      zN = 0.82521,
      t0 = 4.0 / 29.0,
      t1 = 6.0 / 29.0,
      t2 = 3.0 * t1 * t1,
      t3 = t1 * t1 * t1,
      rad2deg = 180 / pi;

  // Convert RGB to linear-light sRGB.
  static double rgb2lrgb(double x) {
    return (x /= 255) <= 0.04045 ? x / 12.92 : pow((x + 0.055) / 1.055, 2.4).toDouble();
  }

  // Convert and apply chromatic adaption from sRGB to CIEXYZ D50, x component.
  static double lrgbToXyzd50X(final double r, g, b) {
    return (0.4360747 * r + 0.3850649 * g + 0.1430804 * b);
  }

  // Convert and apply chromatic adaption from sRGB to CIEXYZ D50, y component.
  static double lrgbToXyzd50Y(final double r, g, b) {
    return (0.2225045 * r + 0.7168786 * g + 0.0606169 * b);
  }

  // Convert and apply chromatic adaption from sRGB to CIEXYZ D50, z component.
  static double lrgbToXyzd50Z(final double r, g, b) {
    return (0.0139322 * r + 0.0971045 * g + 0.7141733 * b);
  }

  // f-function before converting to LAB.
  static double xyz2lab(final double t) {
    return t > t3 ? pow(t, 1.0 / 3.0).toDouble() : t / t2 + t0;
  }
}

class _LabchValues {
  final double l;
  final double a;
  final double b;
  final double c;
  final double h;

  _LabchValues(this.l, this.a, this.b, this.c, this.h);
}

_LabchValues _getLabchValues(int value) {
  final red = (0x00ff0000 & value) >> 16;
  final green = (0x0000ff00 & value) >> 8;
  final blue = (0x000000ff & value) >> 0;

  final srgbR = ColorFunctions.rgb2lrgb(red.toDouble());
  final srgbG = ColorFunctions.rgb2lrgb(green.toDouble());
  final srgbB = ColorFunctions.rgb2lrgb(blue.toDouble());

  final x = ColorFunctions.lrgbToXyzd50X(srgbR, srgbG, srgbB);
  final y = ColorFunctions.lrgbToXyzd50Y(srgbR, srgbG, srgbB);
  final z = ColorFunctions.lrgbToXyzd50Z(srgbR, srgbG, srgbB);

  final fx = ColorFunctions.xyz2lab(x / ColorFunctions.xN);
  final fy = ColorFunctions.xyz2lab(y / ColorFunctions.yN);
  final fz = ColorFunctions.xyz2lab(z / ColorFunctions.zN);

  final l = 116 * fy - 16;
  final a = 500 * (fx - fy);
  final b = 200 * (fy - fz);
  final c = sqrt(a * a + b * b);

  var h = atan2(b, a) * ColorFunctions.rad2deg;
  h = h < 0 ? h + 360 : h;

  return _LabchValues(l, a, b, c, h);
}

int _getValueFromHexString(final String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 7) {
    buffer.write('ff');
  }
  buffer.write(hexString.replaceFirst('#', ''));
  return int.parse(buffer.toString(), radix: 16);
}

// BigColor adds e.g. getters for L*a*b* components to the basic Flutter Color class.
//
// This is not implemented as extension methods because computing L*a*b* components is
// computationally intensive and we need to cache the results.
class BigColor implements Color {
  final int _value;

  final double _l;
  final double _a;
  final double _b;
  final double _c;
  final double _h;

  // String is in the format "aabbcc" or "ffaabbcc" with a mandatory leading "#".
  factory BigColor.fromHexString(final String hexString) {
    final value = _getValueFromHexString(hexString);
    return BigColor._fromValue(value);
  }

  factory BigColor.fromColor(final Color color) {
    final value = color.value;
    return BigColor._fromValue(value);
  }

  factory BigColor.fromRGB0(final int r, g, b, final double opacity) {
    final value = ((((opacity * 0xff ~/ 1) & 0xff) << 24) |
            ((r & 0xff) << 16) |
            ((g & 0xff) << 8) |
            ((b & 0xff) << 0)) &
        0xFFFFFFFF;
    return BigColor._fromValue(value);
  }

  factory BigColor.fromARGB(int a, int r, int g, int b) {
    final value =
        (((a & 0xff) << 24) | ((r & 0xff) << 16) | ((g & 0xff) << 8) | ((b & 0xff) << 0)) &
            0xFFFFFFFF;
    return BigColor._fromValue(value);
  }

  factory BigColor._fromValue(final int value) {
    final labchValues = _getLabchValues(value);
    return BigColor._internal(
        value, labchValues.l, labchValues.a, labchValues.b, labchValues.c, labchValues.h);
  }

  BigColor._internal(this._value, this._l, this._a, this._b, this._c, this._h);

  // The 'l' (luminance) component of CIELAB. In the range [0, +100].
  double get l => _l;

  // The 'a' component of CIELAB. In the range [-160, +160].
  double get a => _a;

  // The 'b' component of CIELAB. In the range [-160, +160].
  double get b => _b;

  // The 'c' component of CIELCH. In the range [0, +230].
  double get c => _c;

  // The 'h' (hue) component of Lch. Expressed in degrees in range [0, +360].
  double get h => _h;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BigColor && runtimeType == other.runtimeType && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  // Below are overridden methods of the Flutter Color class.

  @override
  int get red => (0x00ff0000 & value) >> 16;

  @override
  int get green => (0x0000ff00 & value) >> 8;

  @override
  int get blue => (0x000000ff & value) >> 0;

  @override
  int get alpha => (0xff000000 & value) >> 24;

  @override
  double computeLuminance() => _l;

  @override
  double get opacity => alpha / 0xFF;

  @override
  int get value => _value;

  @override
  Color withRed(int r) => BigColor.fromARGB(alpha, r, green, blue);

  @override
  Color withGreen(int g) => BigColor.fromARGB(alpha, red, g, blue);

  @override
  Color withBlue(int b) => BigColor.fromARGB(alpha, red, green, b);

  @override
  Color withAlpha(int a) => BigColor.fromARGB(a, red, green, blue);

  @override
  Color withOpacity(double apacity) {
    return withAlpha((255.0 * opacity).round());
  }
}
