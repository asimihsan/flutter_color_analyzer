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

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_color_analyzer/big_color.dart';

void main() {
  test('rgb2lrgb works', () {
    // === Given ===
    final r = 170;
    final g = 187;
    final b = 204;

    // === When ===
    final l_r = ColorFunctions.rgb2lrgb(r.toDouble());
    final l_g = ColorFunctions.rgb2lrgb(g.toDouble());
    final l_b = ColorFunctions.rgb2lrgb(b.toDouble());

    // === Then ===
    expect(l_r, moreOrLessEquals(0.4019777798321958));
    expect(l_g, moreOrLessEquals(0.4969329950608704));
    expect(l_b, moreOrLessEquals(0.6038273388553378));
  });

  test('lrgb_to_xyzd50_x works', () {
    // === Given ===
    final lrgb_r = 0.4019777798321958;
    final lrgb_g = 0.4969329950608704;
    final lrgb_b = 0.6038273388553378;

    // === When ===
    final xyz_x = ColorFunctions.lrgb_to_xyzd50_x(lrgb_r, lrgb_g, lrgb_b);

    // === Then ===
    expect(xyz_x, moreOrLessEquals(0.4530396509711626));
  });

  test('lrgb_to_xyzd50_y works', () {
    // === Given ===
    final lrgb_r = 0.4019777798321958;
    final lrgb_g = 0.4969329950608704;
    final lrgb_b = 0.6038273388553378;

    // === When ===
    final xyz_y = ColorFunctions.lrgb_to_xyzd50_y(lrgb_r, lrgb_g, lrgb_b);

    // === Then ===
    expect(xyz_y, moreOrLessEquals(0.48228463612237665));
  });

  test('lrgb_to_xyzd50_z works', () {
    // === Given ===
    final lrgb_r = 0.4019777798321958;
    final lrgb_g = 0.4969329950608704;
    final lrgb_b = 0.6038273388553378;

    // === When ===
    final xyz_z = ColorFunctions.lrgb_to_xyzd50_z(lrgb_r, lrgb_g, lrgb_b);

    // === Then ===
    expect(xyz_z, moreOrLessEquals(0.4850922280636012));
  });

  test('BigColor exposes regular Color values and l, a and b channel values.', () {
    // === Given/When ===
    // This is #AABBCC
    final bigColor = BigColor.fromRGB0(170, 187, 204, 0.4);

    // === Then ===
    expect(bigColor.red, equals(170));
    expect(bigColor.green, equals(187));
    expect(bigColor.blue, equals(204));
    expect(bigColor.opacity, moreOrLessEquals(0.4));
    expect(bigColor.alpha, equals(102));
    expect(bigColor.computeLuminance(), equals(bigColor.l));

    expect(bigColor.l, moreOrLessEquals(74.96879980931759));
    expect(bigColor.a, moreOrLessEquals(-3.398998724348956));
    expect(bigColor.b, moreOrLessEquals(-10.696507207853333));
  });
}
