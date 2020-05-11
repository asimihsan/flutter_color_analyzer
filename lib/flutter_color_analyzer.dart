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

library flutter_color_analyzer;

import 'package:flutter_color_analyzer/big_color.dart';

enum NoticableDifferenceTargetSize { THIN, MEDIUM, WIDE }

enum NoticableDifferenceConfidence { DEFAULT, CONSERVATIVE, STRICT }

// ColorAnalyzer wraps complex color differentiability and palette methods.
//
// References
//
// [1] Stone, Maureen C., Danielle Albers Szafir and Vidya Setlur. “An Engineering Model for Color
//     Difference as a Function of Size.” (2014).
class ColorAnalyzer {
  // This is A from [1].
  static List<double> A = [10.16, 10.68, 10.70];

  // This is B from [1].
  static List<double> B = [1.50, 3.08, 5.74];

  // This is the "ND" function in [1]. This returns a List of three doubles that specifies a
  // difference threshold for each of the L*, a*, and b* component differences between two
  // colors. If the difference is larger than the ND component for any ND component the colors
  // are "noticeably different".
  //
  // The [percentageObservers] value is in the range [0, 1]. This is defined as the percentage
  // of observers who see two colors separated by these L*a*b* thresholds as different colors,
  // based on the empirical study in [1].
  //
  // The [size] value is empirically measured in [1] in the range [1/3, 6]. It is the degrees of
  // visual angle of the target.
  static List<double> noticeableDifferenceThresholds(double percentageObservers, size) {
    return [
      percentageObservers * (A[0] + B[0] / size),
      percentageObservers * (A[1] + B[1] / size),
      percentageObservers * (A[2] + B[2] / size),
    ];
  }

  // noticeablyDifferent determines whether two colors are just-noticeably-different (JND)
  // or not based on [1].
  //
  // This is a convenience wrapper around the raw parameters from [1] with some sensible default
  // values for p and s. If you don't care or haven't read the paper just leave the default
  // targetSize and confidence parameter values.
  static bool noticeablyDifferent(final BigColor c1, c2,
      {NoticableDifferenceTargetSize targetSize = NoticableDifferenceTargetSize.THIN,
      NoticableDifferenceConfidence confidence = NoticableDifferenceConfidence.DEFAULT}) {
    double percentageObservers;
    switch (confidence) {
      case NoticableDifferenceConfidence.STRICT:
        percentageObservers = 0.95;
        break;
      case NoticableDifferenceConfidence.CONSERVATIVE:
        percentageObservers = 0.8;
        break;
      case NoticableDifferenceConfidence.DEFAULT:
        percentageObservers = 0.5;
        break;
    }

    double size;
    switch (targetSize) {
      case NoticableDifferenceTargetSize.WIDE:
        size = 1.0;
        break;
      case NoticableDifferenceTargetSize.MEDIUM:
        size = 0.5;
        break;
      case NoticableDifferenceTargetSize.THIN:
        size = 0.1;
        break;
    }

    return noticeablyDifferentInternal(c1, c2, percentageObservers, size);
  }

  // noticeablyDifferentInternal determines whether two colors are just-noticeably-different (JND)
  // or not based on [1].
  //
  // This gives you raw access to the p and s values from [1]. See noticeableDifferenceThresholds()
  // doc for more information about parameters, and also read the paper.
  static bool noticeablyDifferentInternal(
      final BigColor c1, c2, double percentageObservers, targetSize) {
    final jnd = noticeableDifferenceThresholds(percentageObservers, targetSize);
    return (((c1.l - c2.l).abs() >= jnd[0]) ||
        ((c1.a - c2.a).abs() >= jnd[1]) ||
        ((c1.b - c2.b).abs() >= jnd[2]));
  }
}
