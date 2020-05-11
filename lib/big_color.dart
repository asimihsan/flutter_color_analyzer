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
  static double Xn = 0.96422,
      Yn = 1.0,
      Zn = 0.82521,
      t0 = 4.0 / 29.0,
      t1 = 6.0 / 29.0,
      t2 = 3.0 * t1 * t1,
      t3 = t1 * t1 * t1;

  // Convert RGB to linear-light sRGB.
  static double rgb2lrgb(double x) {
    return (x /= 255) <= 0.04045 ? x / 12.92 : pow((x + 0.055) / 1.055, 2.4);
  }

  // Convert and apply chromatic adaption from sRGB to CIEXYZ D50, x component.
  static double lrgb_to_xyzd50_x(final double r, g, b) {
    return (0.4360747 * r + 0.3850649 * g + 0.1430804 * b);
  }

  // Convert and apply chromatic adaption from sRGB to CIEXYZ D50, y component.
  static double lrgb_to_xyzd50_y(final double r, g, b) {
    return (0.2225045 * r + 0.7168786 * g + 0.0606169 * b);
  }

  // Convert and apply chromatic adaption from sRGB to CIEXYZ D50, z component.
  static double lrgb_to_xyzd50_z(final double r, g, b) {
    return (0.0139322 * r + 0.0971045 * g + 0.7141733 * b);
  }

  // f-function before converting to LAB.
  static double xyz2lab(final double t) {
    return t > t3 ? pow(t, 1.0 / 3.0) : t / t2 + t0;
  }
}

// BigColor adds e.g. getters for L*a*b* components to the basic Flutter Color class.
//
// This is not implemented as extension methods because computing L*a*b* components is
// computationally intensive and we need to cache the results.
class BigColor implements Color {
  final int _value;

  double _l;
  double _a;
  double _b;

  BigColor.fromColor(final Color color) : _value = color.value {
    computeLab();
  }

  BigColor.fromRGB0(final int r, g, b, final double opacity)
      : _value = ((((opacity * 0xff ~/ 1) & 0xff) << 24) |
                ((r & 0xff) << 16) |
                ((g & 0xff) << 8) |
                ((b & 0xff) << 0)) &
            0xFFFFFFFF {
    computeLab();
  }

  void computeLab() {
    final srgb_r = ColorFunctions.rgb2lrgb(red.toDouble());
    final srgb_g = ColorFunctions.rgb2lrgb(green.toDouble());
    final srgb_b = ColorFunctions.rgb2lrgb(blue.toDouble());

    final x = ColorFunctions.lrgb_to_xyzd50_x(srgb_r, srgb_g, srgb_b);
    final y = ColorFunctions.lrgb_to_xyzd50_y(srgb_r, srgb_g, srgb_b);
    final z = ColorFunctions.lrgb_to_xyzd50_z(srgb_r, srgb_g, srgb_b);

    final fx = ColorFunctions.xyz2lab(x / ColorFunctions.Xn);
    final fy = ColorFunctions.xyz2lab(y / ColorFunctions.Yn);
    final fz = ColorFunctions.xyz2lab(z / ColorFunctions.Zn);

    _l = 116 * fy - 16;
    _a = 500 * (fx - fy);
    _b = 200 * (fy - fz);
  }

  double get l => _l;

  double get a => _a;

  double get b => _b;

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
  Color withAlpha(int a) {
    // TODO: implement withAlpha
    throw UnimplementedError();
  }

  @override
  Color withBlue(int a) {
    // TODO: implement withBlue
    throw UnimplementedError();
  }

  @override
  Color withGreen(int a) {
    // TODO: implement withGreen
    throw UnimplementedError();
  }

  @override
  Color withOpacity(double apacity) {
    // TODO: implement withOpacity
    throw UnimplementedError();
  }

  @override
  Color withRed(int a) {
    // TODO: implement withRed
    throw UnimplementedError();
  }
}
