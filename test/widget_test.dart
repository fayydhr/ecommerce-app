import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce/app/config/app_constants.dart';

void main() {
  test('App constants sanity test', () {
    expect(AppConstants.appName, 'ShopFlow');
    expect(AppConstants.keyIsFirstTime, 'is_first_time');
  });
}
