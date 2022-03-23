import 'package:e_voting/src/utilities/constants.dart';

class Utilities {

  static String? valString(String input) {
    if (input.isEmpty) {
      return Cosntants.REQUIRED;
    } else {
      bool band = RegExp(r"^[A-Za-z]+").hasMatch(input);
      return band?null:'Verifique su nombre';
    }
  }

  static String? valNames(String input) {
    if (input.isEmpty) {
      return Cosntants.REQUIRED;
    } else {
      bool band = RegExp(r"^[A-Z][a-z]+\s[A-Z][a-z]|^[A-Z][a-z]+").hasMatch(input);
      return band?null:'Verifique su nombre';
    }
  }

  static String? validateEmail(String input) {
    if (input.isEmpty)
      return 'Campo requerido';
    else {
      bool band = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(input);
      return band?null:'Verifique su correo';
    }
  }

  static String? valDNI(String nui) {
    var total = 0;
    var long = nui.length;
    print(nui.isEmpty);
    print(long);
    var longCheck = long - 1;
    var decimo = int.parse(nui.split('').last);
    if (nui.isNotEmpty && long == 10) {
      for (int i=0; i<longCheck; i++) {
        if (i%2 == 0) {
          int aux = int.parse(nui.split('')[i])*2;
          if (aux > 9) aux -= 9;
          total += aux;
        } else {
          total += int.parse(nui.split('')[i]);
        }
      }
      total = total%10 != 10? 10 - total%10:0;
      if (decimo != total) {
        print('Cédula incorrecta');
        return 'Verifique su número de cédula';
      } else
        print('Cédula correcta');
    } else {
      return 'Verifique su número de cédula';
    }
  }

}