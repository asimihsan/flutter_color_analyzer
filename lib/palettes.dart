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

import 'package:flutter/material.dart';
import 'package:flutter_color_analyzer/big_color.dart';

class WeightNotFoundException implements Exception {
  String errMsg() => 'Could not find colors for weights specified';
}

// References
//
// [1] http://vis.stanford.edu/color-names/analyzer/
class Palettes {
  // Old Tableau 10 from [1].
  static final List<BigColor> _tableau10 = List.unmodifiable([
    BigColor.fromHexString('#1f77b4'),
    BigColor.fromHexString('#ff7f0e'),
    BigColor.fromHexString('#2ca02c'),
    BigColor.fromHexString('#d62728'),
    BigColor.fromHexString('#9467bd'),
    BigColor.fromHexString('#8c564b'),
    BigColor.fromHexString('#e377c2'),
    BigColor.fromHexString('#7f7f7f'),
    BigColor.fromHexString('#bcbd22'),
    BigColor.fromHexString('#17becf'),
  ]);

  static List<BigColor> get tableau10 => _tableau10;

  // Old Tableau 20 from [1].
  static final List<BigColor> _tableau20 = List.unmodifiable([
    BigColor.fromHexString('#1f77b4'),
    BigColor.fromHexString('#aec7e8'),
    BigColor.fromHexString('#ff7f0e'),
    BigColor.fromHexString('#ffbb78'),
    BigColor.fromHexString('#2ca02c'),
    BigColor.fromHexString('#98df8a'),
    BigColor.fromHexString('#d62728'),
    BigColor.fromHexString('#ff9896'),
    BigColor.fromHexString('#9467bd'),
    BigColor.fromHexString('#c5b0d5'),
    BigColor.fromHexString('#8c564b'),
    BigColor.fromHexString('#c49c94'),
    BigColor.fromHexString('#e377c2'),
    BigColor.fromHexString('#f7b6d2'),
    BigColor.fromHexString('#7f7f7f'),
    BigColor.fromHexString('#c7c7c7'),
    BigColor.fromHexString('#bcbd22'),
    BigColor.fromHexString('#dbdb8d'),
    BigColor.fromHexString('#17becf'),
    BigColor.fromHexString('#9edae5')
  ]);

  static List<BigColor> get tableau20 => _tableau20;

  static final List<MaterialColor> _baseMaterialColors = Colors.primaries.toList()
    ..sort((bc1, bc2) => BigColor.fromColor(bc1).h.compareTo(BigColor.fromColor(bc2).h));

  static List<BigColor> getMaterialColorsInHueOrder(final List<int> weights) {
    final result = [];
    for (final weight in weights) {
      for (final mc in _baseMaterialColors) {
        final color = mc[weight];
        if (color == null) {
          throw WeightNotFoundException();
        }
        result.add(BigColor.fromColor(color));
      }
    }
    for (final weight in weights) {
      final color = Colors.grey[weight];
      if (color == null) {
        throw WeightNotFoundException();
      }
      result.add(BigColor.fromColor(color));
    }
    result.add(BigColor.fromColor(Colors.black));
    return List.unmodifiable(result);
  }
}
