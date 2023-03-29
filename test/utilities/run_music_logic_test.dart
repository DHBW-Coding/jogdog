import 'package:flutter_test/flutter_test.dart';
import 'package:jog_dog/utilities/run_music_logic.dart';

void main() {
  group("Tests for the Median Calculation", () {
    test("If the Median with Odd Numbers is correct", () {
      double test = median([1.5, 2.5, 3.5, 4.5, 5.5]);
      expect(test, 3.5);
    });

    test("If the Median with Even Numbers is correct", () {
      double test = median([1.5, 2.5, 3.5, 4.5, 5.5, 6.5]);
      expect(test, 4.0);
    });
  });

  group("Tests if the isDataReliable method works correct", () {
    test("The method returns true if the data is reliable", () {
      bool test = isDataReliable([1.0, 1.0, 1.0, 1.0, 1.0, 1.0]);
      expect(test, true);
    });

    test("The method returns true if the data is reliable with only two values", () {
      bool test = isDataReliable([1.0, 1.0]);
      expect(test, true);
    });

    test("The method returns false if the data is not reliable", () {
      bool test = isDataReliable([1.0, 1.0, 0.0, 0.0, 0.0, 1.0]);
      expect(test, false);
    });
  });
}
