import 'dart:math';

import 'package:generador_de_json/fake_data/fake_personal_data.dart';

class AllUtils {
  /// Metodo que retorna un dato boleano de forma aleatoria
  bool generateRandomBool() {
    return Random().nextInt(2) != 0 ? true : false;
  }

  /// Metodo que genera nombres de hombres aleatorios
  String generateRandomMaleName({bool isFullName = false}) {
    final String randomMaleName = FakePersonalData.maleName[Random().nextInt(FakePersonalData.maleName.length)];
    final String randomMaleLastName = '$randomMaleName ${FakePersonalData.lastName[Random().nextInt(FakePersonalData.lastName.length)]}';
    return isFullName ? randomMaleLastName : randomMaleName;
  }

  /// Metodo que genera nombres de mujeres aleatorios
  String generateRandomFemaleName({bool isFullName = false}) {
    final String randomFemaleName = FakePersonalData.femaleName[Random().nextInt(FakePersonalData.femaleName.length)];
    final String randomFemaleLastName = '$randomFemaleName ${FakePersonalData.lastName[Random().nextInt(FakePersonalData.lastName.length)]}';
    return isFullName ? randomFemaleLastName : randomFemaleName;
  }

  /// Metodo que genera nombres de personas aleatorios (hombres y mujeres)
  String generateRandomFemaleOrMaleName({bool isFullName = false}) {
    final random = Random().nextInt(2);
    if (random == 0) {
      return generateRandomMaleName(isFullName: isFullName);
    }
    return generateRandomFemaleName(isFullName: isFullName);
  }

  /// Metodo que retorna un correo aleatorio
  String generateRandomEmail() {
    final String randomEmail = FakePersonalData.email[Random().nextInt(FakePersonalData.email.length)];
    return randomEmail;
  }

  /// Metodo que genera una url de un avatar aleatorio (hombre o mujer)
  String generateRandomAvatarUrl() {
    final int randomInt = Random().nextInt(99);
    final String womenOrMan = randomInt != 0 ? 'men' : 'women';
    return 'https://randomuser.me/api/portraits/$womenOrMan/$randomInt.jpg';
  }

  /// Metodo que genera una url de un avatar mujer.
  String generateRandomFemaleVatarUrl() {
    final int randomInt = Random().nextInt(99);
    return 'https://randomuser.me/api/portraits/women/$randomInt.jpg';
  }

  /// Metodo que genera una url de un avatar hombre.
  String genereateRandomMaleVatarUrl() {
    final int randomInt = Random().nextInt(99);
    return 'https://randomuser.me/api/portraits/men/$randomInt.jpg';
  }

  /// Metodo que genera un numero de telefono aleatorio
  String generateRandomPhoneNumber() {
    final String randomPhoneNumber = FakePersonalData.phoneNumbers[Random().nextInt(FakePersonalData.phoneNumbers.length)];
    return randomPhoneNumber;
  }

  /// Metodo que genera apellidos aleatorios
  String generateRandomLastName() {
    final String randomLastName = FakePersonalData.lastName[Random().nextInt(FakePersonalData.lastName.length)];
    return randomLastName;
  }
}
