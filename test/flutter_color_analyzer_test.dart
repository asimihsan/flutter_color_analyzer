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
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_color_analyzer/flutter_color_analyzer.dart';

void main() {
  test('black is different from white using defaults', () {
    // === Given ===
    final black = BigColor.fromColor(Colors.black);
    final white = BigColor.fromColor(Colors.white);

    // === When ===
    final areNoticeablyDifferent = ColorAnalyzer.noticeablyDifferent(black, white);

    // === Then ===
    expect(areNoticeablyDifferent, true);
  });

  test('black is different from white using strictest setting', () {
    // === Given ===
    final black = BigColor.fromColor(Colors.black);
    final white = BigColor.fromColor(Colors.white);

    // === When ===
    final areNoticeablyDifferent = ColorAnalyzer.noticeablyDifferent(black, white,
        targetSize: NoticableDifferenceTargetSize.THIN,
        confidence: NoticableDifferenceConfidence.STRICT);

    // === Then ===
    expect(areNoticeablyDifferent, true);
  });

  test('red is different from orange using defaults', () {
    // === Given ===
    final red = BigColor.fromColor(Colors.red);
    final orange = BigColor.fromColor(Colors.orange);

    // === When ===
    final areNoticeablyDifferent = ColorAnalyzer.noticeablyDifferent(red, orange);

    // === Then ===
    expect(areNoticeablyDifferent, true);
  });

  test('lightBlueAccent not different from lightBlue using defaults', () {
    // === Given ===
    final lightBlueAccent = BigColor.fromColor(Colors.lightBlueAccent);
    final lightBlue = BigColor.fromColor(Colors.lightBlue);

    // === When ===
    final areNoticeablyDifferent = ColorAnalyzer.noticeablyDifferent(lightBlueAccent, lightBlue);

    // === Then ===
    expect(areNoticeablyDifferent, false);
  });

  test('lightBlueAccent different from lightBlue using MEDIUM size', () {
    // === Given ===
    final lightBlueAccent = BigColor.fromColor(Colors.lightBlueAccent);
    final lightBlue = BigColor.fromColor(Colors.lightBlue);

    // === When ===
    final areNoticeablyDifferent = ColorAnalyzer.noticeablyDifferent(lightBlueAccent, lightBlue,
        targetSize: NoticableDifferenceTargetSize.MEDIUM);

    // === Then ===
    expect(areNoticeablyDifferent, true);
  });

  test('lightBlueAccent different from lightBlue using WIDE size', () {
    // === Given ===
    final lightBlueAccent = BigColor.fromColor(Colors.lightBlueAccent);
    final lightBlue = BigColor.fromColor(Colors.lightBlue);

    // === When ===
    final areNoticeablyDifferent = ColorAnalyzer.noticeablyDifferent(lightBlueAccent, lightBlue,
        targetSize: NoticableDifferenceTargetSize.WIDE);

    // === Then ===
    expect(areNoticeablyDifferent, true);
  });
}
