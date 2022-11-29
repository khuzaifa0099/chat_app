import 'package:get/get.dart';



class ProfileScreenController extends GetxController {
  var isLoading = false.obs;
  bool isVisiblePassword = true;
  bool isVisibleConfirmPassword = true;



  String? validate_name(val) {
    if (val == "") {
      return "Form Cannot be Empty";
    } else {
      return null;
    }
  }
}
