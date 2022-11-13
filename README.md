<center><h1><b>Dart JSON Generator</b></h1></center>
<center>Versión v1.1.1</center>
<br></br>

Dart JSON Generator es una herramienta que permite generar archivos JSON a partir de **mapas** como modelos de datos en el lenguaje Dart en su version **v2.18.2** o superior.
<br></br>

# **¿Como funciona?**

Primero debes instalar el SDK de Dart en tu equipo Mac, Linux o Windows. Puedes descargarlo desde [aquí](https://dart.dev/get-dart).

    Nota: Si eres desarrollador Flutter, Dart ya viene instalado en tu equipo.

Luego de instalar Dart, en la terminal de tu IDE de preferencia, debes ejecutar el siguiente comando:

    > dart run

## Crear modelos de datos

Para crear un modelo de datos debes hacerlo dentro del archivo principal ```bin/generador_de_json.dart```, puedes llamar al metodo ```generateJson.generateJson()``` y en su parametro **jsonMap** debes pasarle un **mapa** con los datos que deseas convertir a JSON como en el siguiente ejemplo:

```dart
generateJson.generateJson(
    jsonName: 'example',
    jsonMap: <String, dynamic>{
        ¨id¨: 1,
        ¨name¨: ¨John Doe¨,
        ¨age¨: 25,
        ¨isDeveloper¨: true,
    }
);
```
El parametro **jsonName** es el nombre del archivo JSON que se generará, en este caso el archivo se llamará **example.json** y se almacenara en la carpeta ```lib/example.json```.

Para generar un archivo JSON con un **array** de objetos debes hacerlo de la siguiente manera:

```dart
generateJson.generateJsonList(
    jsonName: 'test_data',
    jsonMap: (data) {
      return List.generate(
        100, // Cantidad de objetos que se generaran
        (index) => <String, dynamic>{
          'id': index,
          'name': util.generateRandomFemaleOrMaleName(),
          'lastName': util.generateRandomLastName(),
          'email': util.generateRandomEmail(),
          'avatar': util.generateRandomAvatarUrl(),
          'phone': util.generateRandomPhoneNumber(),
          'isShared': util.generateRandomBool(),
        },
      );
    },
  );
```

En este ejemplo se generará un archivo JSON con 100 objetos con los datos de una persona, también en el ejemplo se esta haciendo uso de la instancia **util** que es una clase que contiene metodos preestablecidos que generan datos aleatorios como nombres, apellidos, correos, etc.

Si quieres generar tus propios metodos preestablecidos puedes hacerlo editando el archivo ```lib/utils/all_utils.dart```.

Algunos de los metodos preestablecidos de los que puedes hacer uso son:

- ```generateRandomBool()```
    - Genera un valor booleano aleatorio.
- ```generateRandomMaleName()```
    - Genera un nombre masculino sin apellido aleatorio, pero si el parametro **isFullName** es **true** genera un nombre completo.
- ```generateRandomFemaleName()```
    - Genera un nombre femenino sin apellido aleatorio, pero si el parametro **isFullName** es **true** genera un nombre completo.
- ```generateRandomFemaleOrMaleName()```
    - Genera un nombre aleatorio masculino o femenino sin apellido, pero si el parametro **isFullName** es **true** genera un nombre completo.
- ```generateRandomEmail()```
    - Genera un correo electronico aleatorio.
- ```generateRandomAvatarUrl()```
    - Genera una url de una imagen aleatoria masculino o femenino.
- ```generateRandomMaleAvatarUrl()```
    - Genera una url de una imagen masculina aleatoria.
- ```generateRandomFemaleAvatarUrl()```
    - Genera una url de una imagen femenina aleatoria.
- ```generateRandomPhoneNumber()``` 
    - Genera un numero de telefono aleatorio.
- ```generateRandomLastName()```
    - Genera un apellido aleatorio.