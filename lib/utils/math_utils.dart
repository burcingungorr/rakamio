import 'dart:math';

class MathUtils {
  static final Random _random = Random();

  static Map<String, int> generateAddition({int maxResult = 9}) {
    int a = _random.nextInt(maxResult); 
    int b = _random.nextInt(maxResult - a + 1); 

    return {
      'a': a,
      'b': b,
      'result': a + b,
    };
  }
}
