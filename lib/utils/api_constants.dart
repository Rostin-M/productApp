class ApiConstants {
  static const String baseUrl = "https://dummyjson.com";

  static const String products = "$baseUrl/products"; // GET lista de productos
  static String productById(int id) => "$baseUrl/products/$id"; // GET un producto

  static const String addProduct = "$baseUrl/products/add"; // POST

  static String updateProduct(int id) => "$baseUrl/products/$id"; // PUT

  static String deleteProduct(int id) => "$baseUrl/products/$id"; // DELETE

  static String searchProducts(String query) =>
      "$baseUrl/products/search?q=$query";

  static const String categories = "$baseUrl/products/categories"; // GET lista detallada
  static const String categoryList = "$baseUrl/products/category-list"; // GET lista simple
  static String productsByCategory(String category) =>
      "$baseUrl/products/category/$category"; // GET productos por categoría
}
