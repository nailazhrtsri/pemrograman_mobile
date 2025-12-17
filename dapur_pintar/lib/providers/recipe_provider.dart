// File: lib/providers/recipe_provider.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/recipe_model.dart';

class RecipeProvider extends ChangeNotifier {
  static const String _boxName = 'recipeBox';
  List<Recipe> _recipes = [];

  List<Recipe> get recipes => _recipes;

  // Load data & Seed data otomatis
  void loadRecipes() async {
    final box = Hive.box(_boxName);
    
    // LOGIC SEEDING: Kalau database kosong, isi 20 resep
    if (box.isEmpty) {
      await _seedInitialData(box);
    }

    _recipes = box.values.map((e) {
      return Recipe.fromMap(Map<String, dynamic>.from(e));
    }).toList();
    notifyListeners();
  }

  Future<void> addRecipe(String title, String desc, String ing, String steps) async {
    final newRecipe = Recipe.create(
      title: title,
      description: desc,
      ingredients: ing,
      steps: steps,
    );
    final box = Hive.box(_boxName);
    await box.put(newRecipe.id, newRecipe.toMap());
    loadRecipes();
  }

  Future<void> deleteRecipe(String id) async {
    final box = Hive.box(_boxName);
    await box.delete(id);
    loadRecipes();
  }

  // --- DATA DUMMY 20 RESEP ---
  Future<void> _seedInitialData(Box box) async {
    final List<Map<String, String>> starterRecipes = [
      {
        "t": "Nasi Goreng Spesial",
        "d": "Sarapan sejuta umat",
        "i": "Nasi Putih\nTelur\nBawang Merah\nBawang Putih\nKecap Manis\nGaram\nCabai",
        "s": "1. Haluskan bawang dan cabai.\n2. Tumis bumbu hingga harum.\n3. Masukkan telur, orak-arik.\n4. Masukkan nasi dan kecap.\n5. Aduk rata hingga matang."
      },
      {
        "t": "Telur Dadar Padang",
        "d": "Tebal, gurih, dan pedas",
        "i": "Telur\nDaun Bawang\nCabai Merah\nBawang Merah\nTepung Beras\nGaram\nLada",
        "s": "1. Kocok telur dengan semua bahan irisan.\n2. Tambahkan sedikit tepung beras agar tebal.\n3. Goreng dengan minyak banyak dan panas.\n4. Balik saat satu sisi kering."
      },
      {
        "t": "Sayur Sop Bakso",
        "d": "Kuah segar untuk makan siang",
        "i": "Bakso\nWortel\nKentang\nKubis\nDaun Bawang\nSeledri\nBawang Putih\nLada",
        "s": "1. Rebus air hingga mendidih.\n2. Masukkan wortel dan kentang.\n3. Tumis bawang putih, masukkan ke kuah.\n4. Masukkan bakso dan sayuran lain.\n5. Beri garam lada, koreksi rasa."
      },
      {
        "t": "Ayam Goreng Lengkuas",
        "d": "Ayam goreng dengan serundeng lengkuas",
        "i": "Ayam\nLengkuas\nBawang Putih\nKunyit\nKetumbar\nDaun Salam\nSereh",
        "s": "1. Parut lengkuas.\n2. Ungkep ayam dengan bumbu halus dan parutan lengkuas.\n3. Goreng ayam hingga kecokelatan.\n4. Goreng sisa bumbu lengkuas sebagai taburan."
      },
      {
        "t": "Tumis Kangkung Terasi",
        "d": "Sayur hijau cepat saji",
        "i": "Kangkung\nBawang Merah\nBawang Putih\nCabai Rawit\nTerasi\nSaus Tiram",
        "s": "1. Potong dan cuci kangkung.\n2. Tumis bawang, cabai, dan terasi.\n3. Masukkan kangkung dan saus tiram.\n4. Masak sebentar dengan api besar agar tetap hijau."
      },
      {
        "t": "Sambal Goreng Kentang",
        "d": "Pelengkap nasi rames",
        "i": "Kentang\nHati Sapi (Opsional)\nSantan\nCabai Merah\nBawang Merah\nDaun Salam\nLengkuas",
        "s": "1. Potong dadu kentang, goreng matang.\n2. Tumis bumbu halus cabai.\n3. Masukkan santan dan daun salam.\n4. Masukkan kentang, masak hingga kuah menyusut."
      },
      {
        "t": "Perkedel Kentang",
        "d": "Lauk pendamping soto",
        "i": "Kentang\nBawang Goreng\nSeledri\nTelur\nGaram\nLada",
        "s": "1. Goreng kentang, lalu haluskan.\n2. Campur dengan bawang goreng dan seledri.\n3. Bentuk bulat pipih.\n4. Balur kocokan telur, goreng hingga kecokelatan."
      },
      {
        "t": "Soto Ayam Kuning",
        "d": "Kuah kuning segar berempah",
        "i": "Ayam\nSoun\nTaoge\nKunyit\nJahe\nSereh\nDaun Jeruk",
        "s": "1. Rebus ayam dengan bumbu halus kuning.\n2. Angkat ayam, goreng, lalu suwir.\n3. Sajikan kuah dengan soun, taoge, dan suwiran ayam."
      },
      {
        "t": "Orak Arik Telur Buncis",
        "d": "Sayur sehat praktis",
        "i": "Telur\nBuncis\nBawang Putih\nGaram\nLada",
        "s": "1. Iris serong buncis.\n2. Tumis bawang putih.\n3. Masukkan telur, buat orak arik.\n4. Masukkan buncis, beri sedikit air dan bumbu. Masak hingga matang."
      },
      {
        "t": "Mie Goreng Jawa",
        "d": "Mie tek-tek ala abang-abang",
        "i": "Mie Telur\nKol\nSawi\nKecap Manis\nKemiri\nBawang Putih\nLada",
        "s": "1. Rebus mie setengah matang.\n2. Tumis bumbu halus kemiri dan bawang.\n3. Masukkan sayuran dan sedikit air.\n4. Masukkan mie dan kecap, aduk rata."
      },
       {
        "t": "Tempe Mendoan",
        "d": "Gorengan favorit sejuta umat",
        "i": "Tempe\nTepung Terigu\nDaun Bawang\nKetumbar\nBawang Putih\nKunyit",
        "s": "1. Iris tipis tempe.\n2. Buat adonan tepung bumbu encer.\n3. Celupkan tempe.\n4. Goreng sebentar dalam minyak panas (jangan sampai kering)."
      },
      {
        "t": "Sayur Asem",
        "d": "Segar dan asam pedas",
        "i": "Jagung Manis\nLabu Siam\nKacang Panjang\nMelinjo\nAsem Jawa\nCabai Merah\nTerasi",
        "s": "1. Rebus air, masukkan bumbu halus dan asem.\n2. Masukkan jagung dan melinjo (bahan keras).\n3. Masukkan sayuran lunak terakhir.\n4. Koreksi rasa asam manisnya."
      },
      {
        "t": "Balado Terong",
        "d": "Pedas nendang",
        "i": "Terong Ungu\nCabai Merah\nBawang Merah\nTomat\nGaram\nGula",
        "s": "1. Belah terong, goreng sebentar.\n2. Tumis bumbu balado (cabai, bawang, tomat) hingga matang berminyak.\n3. Campurkan terong ke sambal."
      },
      {
        "t": "Rica-Rica Ayam",
        "d": "Pedas wangi kemangi",
        "i": "Ayam\nCabai Rawit\nDaun Kemangi\nJahe\nSereh\nDaun Jeruk",
        "s": "1. Tumis bumbu pedas hingga matang.\n2. Masukkan ayam, aduk rata.\n3. Beri sedikit air, masak hingga empuk.\n4. Masukkan kemangi sesaat sebelum diangkat."
      },
      {
        "t": "Bakwan Jagung",
        "d": "Renyah dan manis",
        "i": "Jagung Manis\nTepung Terigu\nTelur\nDaun Bawang\nBawang Putih",
        "s": "1. Sisir jagung, ulek kasar sebagian.\n2. Campur dengan tepung, telur, dan bumbu.\n3. Goreng sesendok demi sesendok hingga emas."
      },
      {
        "t": "Capcay Goreng",
        "d": "Sayuran lengkap ala resto",
        "i": "Wortel\nSawi Putih\nBrokoli\nBakso\nBawang Putih\nSaus Tiram\nMaizena",
        "s": "1. Tumis bawang putih.\n2. Masukkan sayuran keras (wortel) dulu.\n3. Masukkan sisa sayur dan bumbu.\n4. Kentalkan kuah dengan larutan maizena."
      },
      {
        "t": "Gado-Gado",
        "d": "Saladnya Indonesia",
        "i": "Kacang Panjang\nTaoge\nTahu\nTempe\nBumbu Kacang\nKerupuk",
        "s": "1. Rebus semua sayuran.\n2. Goreng tahu dan tempe.\n3. Siram dengan bumbu kacang yang sudah dilarutkan.\n4. Sajikan dengan kerupuk."
      },
      {
        "t": "Semur Telur",
        "d": "Manis gurih kesukaan anak",
        "i": "Telur Rebus\nKecap Manis\nPala\nCengkeh\nKayu Manis\nBawang Merah",
        "s": "1. Tumis bumbu halus.\n2. Masukkan air, kecap, dan rempah.\n3. Masukkan telur rebus.\n4. Masak hingga kuah mengental dan meresap."
      },
      {
        "t": "Tahu Gejrot",
        "d": "Camilan khas Cirebon",
        "i": "Tahu Pong\nBawang Merah\nCabai Rawit\nGula Merah\nAsem Jawa\nAir",
        "s": "1. Potong tahu pong.\n2. Ulek kasar bawang, cabai, dan gula merah.\n3. Siram dengan air asem jawa."
      },
      {
        "t": "Pisang Goreng Pasir",
        "d": "Camilan sore krispi",
        "i": "Pisang Kepok\nTepung Terigu\nTepung Panir\nGula\nGaram",
        "s": "1. Buat adonan pencelup dari terigu dan air.\n2. Celup pisang, gulingkan di tepung panir.\n3. Goreng hingga kuning keemasan."
      },
    ];

    for (var r in starterRecipes) {
      final recipe = Recipe.create(
        title: r['t']!,
        description: r['d']!,
        ingredients: r['i']!,
        steps: r['s']!,
      );
      await box.put(recipe.id, recipe.toMap());
    }
  }
}