// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
// Dart test program for testing bad named parameters.

import "package:expect/expect.dart";

class BadNamedParametersTest {
  int f42(int a, {int b: 20, int c: 30}) {
    return 100 * (100 * a + b) + c;
  }

  int f52(int a, {int b: 20, int c, int d: 40}) {
    return 100 * (100 * (100 * a + b) + (c == null ? 0 : c)) + d;
  }
}

main() {
  BadNamedParametersTest np = new BadNamedParametersTest();

  // Parameter b passed twice.
  np.f42(10, 25, b: 25); //# 01: compile-time error

  // Parameter x does not exist.
  np.f42(10, 25, x: 99); //# 02: compile-time error

  // Parameter b1 does not exist.
  np.f52(10, b: 25, b1: 99, c: 35); //# 03: compile-time error

  // Too many parameters.
  np.f42(10, 20, 30, 40); //# 04: compile-time error

  // Too few parameters.
  np.f42(b: 25); //# 05: compile-time error
}
