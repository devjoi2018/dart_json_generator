import 'package:generador_de_json/core/data_generators/data_generator_factory.dart';
import 'package:generador_de_json/core/interfaces/data_generator_interface.dart';
import 'package:generador_de_json/core/templates/base_template.dart';

/// Template para generar datos de producto
class ProductTemplate extends BaseTemplate {
  /// Generador de datos
  final DataGeneratorInterface _dataGenerator = DataGeneratorFactory.create(GeneratorType.random);

  /// Categorías de productos disponibles
  final List<String> _categories = [
    "Electrónica",
    "Ropa",
    "Hogar",
    "Deportes",
    "Juguetes",
    "Jardín",
    "Alimentos",
    "Bebidas",
  ];

  /// Marcas disponibles
  final List<String> _brands = [
    "TechWorld",
    "FashionStyle",
    "HomePlus",
    "SportMaster",
    "ToyJoy",
    "GardenLife",
    "FoodDelight",
    "DrinkPure",
  ];

  @override
  String get name => "product";

  @override
  String get description => "Template para generar datos de producto";

  @override
  String get version => "1.0.0";

  /// Campos requeridos en el esquema
  final List<String> _requiredFields = ["id", "name", "price", "category"];

  @override
  Map<String, dynamic> getSchemaInternal() {
    return {
      "type": "object",
      "required": _requiredFields,
      "properties": {
        "id": {"type": "string", "pattern": "^PRD-[0-9]{6}\$"},
        "name": {"type": "string", "minLength": 3},
        "price": {"type": "number", "minimum": 0.01},
        "discountPrice": {"type": "number", "minimum": 0},
        "description": {"type": "string"},
        "category": {"type": "string", "enum": _categories},
        "brand": {"type": "string"},
        "inStock": {"type": "boolean"},
        "stockQuantity": {"type": "integer", "minimum": 0},
        "rating": {"type": "number", "minimum": 0, "maximum": 5},
        "reviewCount": {"type": "integer", "minimum": 0},
        "featured": {"type": "boolean"},
        "createdAt": {"type": "string", "format": "date-time"},
        "updatedAt": {"type": "string", "format": "date-time"},
        "images": {
          "type": "array",
          "items": {"type": "string", "format": "uri"}
        },
        "specifications": {
          "type": "object",
          "additionalProperties": true
        },
      }
    };
  }

  @override
  Map<String, dynamic> generateMapInternal() {
    final inStock = _dataGenerator.generateRandomBool(trueProbability: 0.75);
    final category = _categories[_dataGenerator.generateRandomInt(min: 0, max: _categories.length - 1)];
    final brand = _brands[_dataGenerator.generateRandomInt(min: 0, max: _brands.length - 1)];
    
    final basePrice = _dataGenerator.generateRandomDouble(min: 10, max: 1000, decimals: 2);
    final discounted = _dataGenerator.generateRandomBool(trueProbability: 0.3);
    final discountPrice = discounted 
        ? basePrice * (1 - _dataGenerator.generateRandomDouble(min: 0.1, max: 0.5, decimals: 2)) 
        : null;
    
    return {
      "id": _generateProductId(),
      "name": _generateProductName(category, brand),
      "price": basePrice,
      "discountPrice": discountPrice,
      "description": _generateProductDescription(category, brand),
      "category": category,
      "brand": brand,
      "inStock": inStock,
      "stockQuantity": inStock 
          ? _dataGenerator.generateRandomInt(min: 1, max: 1000) 
          : 0,
      "rating": _dataGenerator.generateRandomDouble(min: 1, max: 5, decimals: 1),
      "reviewCount": _dataGenerator.generateRandomInt(min: 0, max: 500),
      "featured": _dataGenerator.generateRandomBool(trueProbability: 0.2),
      "createdAt": _dataGenerator.generateRandomDate(
        from: DateTime(2020, 1, 1),
        to: DateTime.now().subtract(const Duration(days: 30)),
      ),
      "updatedAt": _dataGenerator.generateRandomDate(
        from: DateTime.now().subtract(const Duration(days: 30)),
        to: DateTime.now(),
      ),
      "images": _generateRandomImages(category),
      "specifications": _generateRandomSpecs(category),
    };
  }

  @override
  bool validateDataInternal(Map<String, dynamic> data) {
    // Verifica campos requeridos
    for (final field in _requiredFields) {
      if (!data.containsKey(field) || data[field] == null) {
        return false;
      }
    }
    
    // Validaciones específicas para cada campo
    if (data.containsKey("id") && data["id"] is String) {
      final idRegex = RegExp(r'^PRD-[0-9]{6}$');
      if (!idRegex.hasMatch(data["id"] as String)) {
        return false;
      }
    }
    
    if (data.containsKey("price") && data["price"] is num && data["price"] <= 0) {
      return false;
    }
    
    if (data.containsKey("category") && data["category"] is String && !_categories.contains(data["category"])) {
      return false;
    }
    
    return true;
  }

  @override
  Map<String, dynamic> applyTemplateInternal(Map<String, dynamic> data) {
    final template = generateMapInternal();
    
    // Combina los datos proporcionados con el template
    final result = Map<String, dynamic>.from(template);
    
    // Sobrescribe con los datos proporcionados
    data.forEach((key, value) {
      result[key] = value;
    });
    
    return result;
  }

  /// Genera un ID de producto en formato XX0000
  String _generateProductId() {
    final randomNum = _dataGenerator.generateRandomInt(min: 100000, max: 999999);
    return "PRD-$randomNum";
  }

  /// Genera un nombre de producto basado en la categoría
  String _generateProductName(String category, String brand) {
    final adjectives = {
      "Electrónica": ["Smart", "Ultra", "Pro", "Digital", "Advanced"],
      "Ropa": ["Casual", "Elegant", "Premium", "Modern", "Classic"],
      "Hogar": ["Comfortable", "Luxury", "Essential", "Modern", "Stylish"],
      "Deportes": ["Professional", "Performance", "Extreme", "Training", "Active"],
      "Juguetes": ["Educational", "Fun", "Creative", "Interactive", "Colorful"],
      "Jardín": ["Durable", "Premium", "Eco", "Garden", "Outdoor"],
      "Alimentos": ["Organic", "Gourmet", "Fresh", "Delicious", "Natural"],
      "Bebidas": ["Refreshing", "Premium", "Special", "Pure", "Authentic"],
    };
    
    final nouns = {
      "Electrónica": ["Smartphone", "Laptop", "Headphones", "Camera", "Tablet"],
      "Ropa": ["T-Shirt", "Jeans", "Dress", "Jacket", "Shoes"],
      "Hogar": ["Chair", "Lamp", "Sofa", "Table", "Curtains"],
      "Deportes": ["Shoes", "Ball", "Gloves", "Racket", "Equipment"],
      "Juguetes": ["Robot", "Puzzle", "Blocks", "Doll", "Game"],
      "Jardín": ["Tool", "Plant", "Furniture", "Decoration", "Set"],
      "Alimentos": ["Chocolate", "Coffee", "Snack", "Tea", "Pasta"],
      "Bebidas": ["Water", "Juice", "Soda", "Tea", "Coffee"],
    };
    
    final adjList = adjectives[category] ?? adjectives["Electrónica"]!;
    final nounList = nouns[category] ?? nouns["Electrónica"]!;
    
    final adj = adjList[_dataGenerator.generateRandomInt(min: 0, max: adjList.length - 1)];
    final noun = nounList[_dataGenerator.generateRandomInt(min: 0, max: nounList.length - 1)];
    final modelNumber = _dataGenerator.generateRandomInt(min: 100, max: 9999);
    
    return "$brand $adj $noun $modelNumber";
  }

  /// Genera una descripción de producto basada en nombre, categoría y marca
  String _generateProductDescription(String category, String brand) {
    final templates = [
      "Este premium producto de $category de la marca $brand ofrece calidad y rendimiento excepcionales.",
      "Presentamos la última innovación en $category de $brand. Diseñado para máximo rendimiento y confiabilidad.",
      "Experimenta la diferencia con este producto de $category de $brand. Tecnología de vanguardia y diseño elegante.",
      "Un producto imprescindible de $category de la reconocida marca $brand. Combina funcionalidad, durabilidad y estilo.",
      "Descubre por qué $brand lidera el mercado de $category con este destacado producto. Artesanía superior y características innovadoras."
    ];
    
    return templates[_dataGenerator.generateRandomInt(min: 0, max: templates.length - 1)];
  }

  /// Genera especificaciones aleatorias
  Map<String, dynamic> _generateRandomSpecs(String category) {
    final specs = <String, dynamic>{};
    
    // Especificaciones básicas para cada categoría
    switch (category) {
      case "electronics":
        specs["dimensions"] = "${_dataGenerator.generateRandomInt(min: 5, max: 30)}x${_dataGenerator.generateRandomInt(min: 5, max: 30)}x${_dataGenerator.generateRandomInt(min: 1, max: 10)} cm";
        specs["weight"] = "${_dataGenerator.generateRandomDouble(min: 0.1, max: 5, decimals: 2)} kg";
        specs["warranty"] = "${_dataGenerator.generateRandomInt(min: 1, max: 3)} years";
        specs["powerConsumption"] = "${_dataGenerator.generateRandomInt(min: 5, max: 100)} W";
        break;
        
      case "clothing":
        specs["material"] = ["Cotton", "Polyester", "Wool", "Linen", "Silk"][_dataGenerator.generateRandomInt(min: 0, max: 4)];
        specs["careInstructions"] = ["Machine wash", "Hand wash", "Dry clean only"][_dataGenerator.generateRandomInt(min: 0, max: 2)];
        specs["madeIn"] = ["USA", "China", "Italy", "India", "Vietnam"][_dataGenerator.generateRandomInt(min: 0, max: 4)];
        break;
        
      case "food":
        specs["ingredients"] = "Natural ingredients";
        specs["nutritionalInfo"] = {
          "calories": _dataGenerator.generateRandomInt(min: 50, max: 500),
          "protein": "${_dataGenerator.generateRandomDouble(min: 0, max: 30, decimals: 1)} g",
          "carbs": "${_dataGenerator.generateRandomDouble(min: 0, max: 50, decimals: 1)} g",
          "fat": "${_dataGenerator.generateRandomDouble(min: 0, max: 30, decimals: 1)} g",
        };
        specs["shelfLife"] = "${_dataGenerator.generateRandomInt(min: 1, max: 36)} months";
        break;
        
      default:
        specs["material"] = ["Metal", "Plastic", "Wood", "Glass", "Ceramic"][_dataGenerator.generateRandomInt(min: 0, max: 4)];
        specs["dimensions"] = "${_dataGenerator.generateRandomInt(min: 10, max: 100)}x${_dataGenerator.generateRandomInt(min: 10, max: 100)}x${_dataGenerator.generateRandomInt(min: 5, max: 50)} cm";
        specs["weight"] = "${_dataGenerator.generateRandomDouble(min: 0.1, max: 10, decimals: 1)} kg";
    }
    
    return specs;
  }

  /// Genera imágenes aleatorias
  List<String> _generateRandomImages(String category) {
    final imageCount = _dataGenerator.generateRandomInt(min: 1, max: 5);
    final images = List.generate(
      imageCount,
      (index) => "https://example.com/products/$category/image_$index.jpg",
    );
    return images;
  }
} 