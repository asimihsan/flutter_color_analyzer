#!/usr/bin/env bash

set -eux

cd $1
flutter packages get
flutter format --line-length 100 --set-exit-if-changed lib test
flutter analyze
flutter test --no-pub --coverage
# resets to the original state
cd -