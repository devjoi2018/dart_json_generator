# 🔌 Formateador de Monedas

Un plugin para Dart JSON Generator que permite formatear valores monetarios en diferentes divisas.

## 📋 Características

- Formateo de valores numéricos a diferentes monedas
- Soporte para múltiples divisas internacionales
- Opciones de configuración personalizables
- Capacidad para registrar nuevas monedas
- Documentación completa de la API

## 🛠️ Instalación

1. Coloca la carpeta `currency_formatter` en el directorio `plugins/` de tu instalación de Dart JSON Generator.
2. Reinicia la aplicación para que el plugin sea detectado y cargado automáticamente.

## 🚀 Uso Básico

Una vez instalado, puedes utilizar el plugin desde tus generadores de datos:

```dart
// Obtener acceso al plugin
final currencyPlugin = app.plugins.getPlugin<CurrencyFormatterPlugin>('com.ejemplo.currency_formatter');

// Formatear un valor como moneda
final formattedPrice = currencyPlugin.formatCurrency(1234.56);  // $1,234.56

// Utilizar diferentes monedas
final priceInEuros = currencyPlugin.formatCurrency(1234.56, currencyCode: 'EUR');  // €1,234.56
final priceInPesos = currencyPlugin.formatCurrency(1234.56, currencyCode: 'MXN');  // $1,234.56
```

## ⚙️ Configuración

El plugin permite personalizar el comportamiento predeterminado:

```dart
// Configurar opciones predeterminadas
currencyPlugin.configure(
  defaultCurrency: 'EUR',      // Moneda predeterminada
  defaultDecimals: 2,          // Número de decimales
  symbolBeforeValue: false,    // Símbolo después del valor
  includeSpace: true,          // Espacio entre valor y símbolo
);

// Ahora el formato predeterminado será: 1,234.56 €
final price = currencyPlugin.formatCurrency(1234.56);  // 1,234.56 €
```

## 🌐 Divisas Disponibles

El plugin incluye soporte para las siguientes divisas:

- USD: Dólar estadounidense ($)
- EUR: Euro (€)
- GBP: Libra esterlina (£)
- JPY: Yen japonés (¥)
- MXN: Peso mexicano ($)
- BRL: Real brasileño (R$)
- CAD: Dólar canadiense ($)
- AUD: Dólar australiano ($)
- CHF: Franco suizo (Fr.)

Para obtener la lista completa de divisas disponibles:

```dart
final currencies = currencyPlugin.availableCurrencies;
```

## 🧩 Extensibilidad

Puedes añadir soporte para divisas adicionales:

```dart
// Registrar una moneda personalizada
currencyPlugin.registerCurrency('ARS', '$', 'Peso argentino');

// Ahora puedes usar la nueva moneda
final priceInPesos = currencyPlugin.formatCurrency(1234.56, currencyCode: 'ARS');
```

## 📖 Referencia de la API

### Métodos Principales

#### `formatCurrency(double value, {...})`

Formatea un valor numérico como una cantidad monetaria.

**Parámetros:**

- `value`: El valor numérico a formatear
- `currencyCode`: (Opcional) Código ISO de la moneda
- `decimals`: (Opcional) Número de decimales a mostrar
- `symbolBeforeValue`: (Opcional) Si true, coloca el símbolo antes del valor
- `includeSpace`: (Opcional) Si true, incluye un espacio entre el símbolo y el valor

**Ejemplo:**

```dart
final price = currencyPlugin.formatCurrency(1234.56,
  currencyCode: 'EUR',
  decimals: 2,
  symbolBeforeValue: true,
  includeSpace: true
);  // € 1,234.56
```

#### `getCurrencySymbol(String currencyCode)`

Obtiene el símbolo para una moneda específica.

**Parámetros:**

- `currencyCode`: Código ISO de la moneda

**Ejemplo:**

```dart
final symbol = currencyPlugin.getCurrencySymbol('JPY');  // ¥
```

#### `getCurrencyName(String currencyCode)`

Obtiene el nombre completo de una moneda.

**Parámetros:**

- `currencyCode`: Código ISO de la moneda

**Ejemplo:**

```dart
final name = currencyPlugin.getCurrencyName('GBP');  // Libra esterlina
```

#### `configure({...})`

Configura las opciones predeterminadas del formateador.

**Parámetros:**

- `defaultCurrency`: (Opcional) Moneda predeterminada
- `defaultDecimals`: (Opcional) Número de decimales predeterminado
- `symbolBeforeValue`: (Opcional) Si el símbolo debe ir antes del valor
- `includeSpace`: (Opcional) Si se debe incluir un espacio entre el símbolo y el valor

**Ejemplo:**

```dart
currencyPlugin.configure(
  defaultCurrency: 'EUR',
  defaultDecimals: 2,
  symbolBeforeValue: true,
  includeSpace: false
);
```

#### `registerCurrency(String code, String symbol, String name)`

Registra una moneda personalizada.

**Parámetros:**

- `code`: Código ISO de la moneda
- `symbol`: Símbolo de la moneda
- `name`: Nombre completo de la moneda

**Ejemplo:**

```dart
currencyPlugin.registerCurrency('COP', '$', 'Peso colombiano');
```

## 🧪 Ejemplos Prácticos

### Generación de productos con precios formateados

```dart
jsonGenerator.generateJsonList(
  jsonName: 'productos',
  jsonMap: (List<Map<String, dynamic>> data) {
    // Obtener el plugin
    final currencyPlugin = app.plugins.getPlugin<CurrencyFormatterPlugin>('com.ejemplo.currency_formatter');

    // Configurar para usar euros
    currencyPlugin.configure(defaultCurrency: 'EUR', symbolBeforeValue: true, includeSpace: true);

    return List.generate(
      app.config.defaultRecordCount,
      (index) {
        // Generar un precio aleatorio entre 10 y 1000
        final price = dataGenerator.generateRandomDouble(min: 10, max: 1000, decimals: 2);

        // Formatear el precio como moneda
        final formattedPrice = currencyPlugin.formatCurrency(price);

        return <String, dynamic>{
          'id': index + 1,
          'nombre': dataGenerator.generateRandomLoremIpsum(minWords: 2, maxWords: 5),
          'precio': price,
          'precioFormateado': formattedPrice,
          'categoria': ['Electrónica', 'Ropa', 'Hogar', 'Deportes'][index % 4],
        };
      },
    );
  },
);
```

## 🐛 Solución de Problemas

### El plugin no aparece en la lista de plugins

Asegúrate de que:

1. Los archivos están ubicados en `plugins/currency_formatter/`
2. El archivo `manifest.json` contiene el ID correcto del plugin
3. La función `createPlugin()` está expuesta correctamente

### El formateo no muestra el símbolo correcto

Verifica que:

1. El código de moneda esté en mayúsculas (USD, EUR, etc.)
2. La moneda que estás intentando usar está soportada
3. Si estás usando una moneda personalizada, que fue registrada correctamente

## 📝 Licencia

Este plugin se distribuye bajo la misma licencia que Dart JSON Generator.
