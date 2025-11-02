import 'dart:math';

class MathUtils {
  static final Random _random = Random();

static Map<String, int> generateAddition({int maxResult = 10}) {
  int a = _random.nextInt(maxResult + 1); 
  int b = _random.nextInt(maxResult + 1 - a); 
  
  return {
    'a': a,
    'b': b,
    'result': a + b,
  };
}

}
