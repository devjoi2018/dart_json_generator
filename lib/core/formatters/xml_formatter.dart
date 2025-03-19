import 'package:generador_de_json/core/interfaces/output_format_interface.dart';
import 'package:xml/xml.dart';

/// Implementación del formato XML
class XmlFormatter implements OutputFormatInterface {
  @override
  String get formatName => 'XML';

  @override
  String get fileExtension => 'xml';

  @override
  String encode(dynamic data, {int indent = 2}) {
    if (data is Map) {
      return _mapToXml(data, 'root', indent: indent);
    } else if (data is List) {
      return _listToXml(data, 'root', indent: indent);
    } else {
      return _valueToXml(data, 'root', indent: indent);
    }
  }

  @override
  dynamic decode(String data) {
    final document = XmlDocument.parse(data);
    return _xmlToMap(document.rootElement);
  }

  @override
  String get mimeType => 'application/xml';

  /// Convierte un mapa a XML
  String _mapToXml(Map<dynamic, dynamic> map, String rootName, {int indent = 2}) {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');

    builder.element(
      rootName,
      nest: () {
        map.forEach((key, value) {
          _addElement(builder, key.toString(), value);
        });
      },
    );

    final document = builder.buildDocument();
    return document.toXmlString(pretty: true, indent: ' ' * indent);
  }

  /// Convierte una lista a XML
  String _listToXml(List<dynamic> list, String rootName, {int indent = 2}) {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');

    builder.element(
      rootName,
      nest: () {
        for (var i = 0; i < list.length; i++) {
          _addElement(builder, 'item', list[i], attributes: {'index': i.toString()});
        }
      },
    );

    final document = builder.buildDocument();
    return document.toXmlString(pretty: true, indent: ' ' * indent);
  }

  /// Convierte un valor simple a XML
  String _valueToXml(dynamic value, String rootName, {int indent = 2}) {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');

    _addElement(builder, rootName, value);

    final document = builder.buildDocument();
    return document.toXmlString(pretty: true, indent: ' ' * indent);
  }

  /// Agrega un elemento al constructor XML
  void _addElement(XmlBuilder builder, String name, dynamic value, {Map<String, String> attributes = const {}}) {
    // Asegurar que el nombre del elemento sea válido para XML
    final safeName = _safeElementName(name);

    if (value is Map) {
      builder.element(
        safeName,
        attributes: attributes,
        nest: () {
          value.forEach((key, val) {
            _addElement(builder, key.toString(), val);
          });
        },
      );
    } else if (value is List) {
      builder.element(
        safeName,
        attributes: attributes,
        nest: () {
          for (var i = 0; i < value.length; i++) {
            _addElement(builder, 'item', value[i], attributes: {'index': i.toString()});
          }
        },
      );
    } else {
      // Para valores simples (string, número, booleano, etc.)
      builder.element(safeName, attributes: attributes, nest: value?.toString() ?? 'null');
    }
  }

  /// Convierte un elemento XML a un mapa
  dynamic _xmlToMap(XmlElement element) {
    // Si es un elemento "item" con índice, probablemente sea parte de una lista
    if (element.name.local == 'item' && element.attributes.any((attr) => attr.name.local == 'index')) {
      if (element.children.isEmpty) {
        return null;
      } else if (element.children.length == 1 && element.children.first is XmlText) {
        return _parseValue(element.innerText);
      } else {
        // Elemento con hijos
        if (_allChildrenAreItems(element)) {
          return _xmlToList(element);
        } else {
          return _xmlElementToMap(element);
        }
      }
    } else {
      // Si no tiene hijos, o solo tiene texto
      if (element.children.isEmpty) {
        return null;
      } else if (element.children.length == 1 && element.children.first is XmlText) {
        return _parseValue(element.innerText);
      } else {
        // Elemento con hijos
        if (_allChildrenAreItems(element)) {
          return _xmlToList(element);
        } else {
          return _xmlElementToMap(element);
        }
      }
    }
  }

  /// Convierte un elemento XML a un mapa
  Map<String, dynamic> _xmlElementToMap(XmlElement element) {
    final map = <String, dynamic>{};

    for (var child in element.childElements) {
      map[child.name.local] = _xmlToMap(child);
    }

    return map;
  }

  /// Convierte un elemento XML a una lista
  List<dynamic> _xmlToList(XmlElement element) {
    final items = element.findElements('item').toList();
    final list = List<dynamic>.filled(items.length, null);

    for (var item in items) {
      final indexAttr = item.getAttribute('index');
      if (indexAttr != null) {
        final index = int.tryParse(indexAttr);
        if (index != null && index < list.length) {
          list[index] = _xmlToMap(item);
        }
      }
    }

    return list;
  }

  /// Comprueba si todos los hijos de un elemento son "item"
  bool _allChildrenAreItems(XmlElement element) {
    final children = element.childElements;
    return children.isNotEmpty && children.every((child) => child.name.local == 'item');
  }

  /// Parsea un valor de texto a su tipo correspondiente
  dynamic _parseValue(String value) {
    // Intentar convertir a numero
    final intValue = int.tryParse(value);
    if (intValue != null) {
      return intValue;
    }

    final doubleValue = double.tryParse(value);
    if (doubleValue != null) {
      return doubleValue;
    }

    // Intentar convertir a booleano
    if (value.toLowerCase() == 'true') {
      return true;
    } else if (value.toLowerCase() == 'false') {
      return false;
    } else if (value.toLowerCase() == 'null') {
      return null;
    }

    // Si no se puede convertir, devolver como string
    return value;
  }

  /// Asegura que el nombre del elemento sea válido para XML
  String _safeElementName(String name) {
    // Reemplazar espacios y caracteres especiales
    var safeName = name.replaceAll(RegExp(r'[^\w\-.]'), '_');

    // Asegurarse de que el nombre no comience con un número o un carácter especial
    if (RegExp(r'^[0-9\-.]').hasMatch(safeName)) {
      safeName = 'e_$safeName';
    }

    // Si el nombre está vacío, usar un nombre genérico
    if (safeName.isEmpty) {
      safeName = 'element';
    }

    return safeName;
  }
}
