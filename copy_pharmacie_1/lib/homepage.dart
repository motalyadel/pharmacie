
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'pharmacy_list_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedCity;
  String? selectedRegion;
  List<String> cities = [];
  List<String> regions = [];

  @override
  void initState() {
    super.initState();
    fetchCities();
  }

  // Récupérer les villes depuis Firestore
  Future<void> fetchCities() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('users').get();
      final allCities = querySnapshot.docs
          .where((doc) => doc.data().containsKey('city'))
          .map((doc) => doc['city'] as String)
          .toSet()
          .toList();
      setState(() {
        cities = allCities;
      });
    } catch (e) {
      print('Erreur lors du chargement des villes : $e');
    }
  }

  // Récupérer les régions en fonction de la ville
  Future<void> fetchRegions(String city) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('city', isEqualTo: city)
          .get();
      final allRegions = querySnapshot.docs
          .where((doc) => doc.data().containsKey('region'))
          .map((doc) => doc['region'] as String)
          .toSet()
          .toList();
      setState(() {
        regions = allRegions;
        selectedRegion = null;
      });
    } catch (e) {
      print('Erreur lors du chargement des régions : $e');
    }
  }

  // Ouvrir les pharmacies sur Google Maps
  void openPharmacyEnMap() async {
    final url = "https://www.google.com/maps/search/?api=1&query=pharmacies";
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Impossible d'ouvrir Google Maps.")),
      );
    }
  }

  // Navigation vers la liste des pharmacies
  void navigateToPharmacies() {
    if (selectedCity != null && selectedRegion != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PharmaciesListPage(
            city: selectedCity!,
            region: selectedRegion!,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("La ville et la région doivent être sélectionnées")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recherche Pharmacies", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Sélection de la ville
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Sélectionnez une ville",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      value: selectedCity,
                      items: cities.map((city) {
                        return DropdownMenuItem(
                          value: city,
                          child: Text(city),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedCity = value;
                            fetchRegions(value);
                          });
                        }
                      },
                    ),
                    SizedBox(height: 10),

                    // Sélection de la région
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Sélectionnez une région",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      value: selectedRegion,
                      items: regions.map((region) {
                        return DropdownMenuItem(
                          value: region,
                          child: Text(region),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedRegion = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Bouton pour voir les pharmacies
            ElevatedButton(
              onPressed: navigateToPharmacies,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.white60,
              ),
              child: Text(
                "Voir les pharmacies de gard",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),

            // Bouton pour voir les pharmacies sur Google Maps
            ElevatedButton(
              onPressed: openPharmacyEnMap,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.white60,
              ),
              child: Text(
                "Voir les pharmacies dans Maps",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// *****************************************


// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'pharmacy_list_page.dart';
//
// class Homepage extends StatefulWidget {
//   @override
//   _HomepageState createState() => _HomepageState();
// }
//
// class _HomepageState extends State<Homepage> {
//   String? selectedCity;
//   String? selectedRegion;
//
//   List<String> cities = [];
//   List<String> regions = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchCities();
//   }
//
//   // جلب المدن من Firestore
//   Future<void> fetchCities() async {
//     try {
//       final querySnapshot = await FirebaseFirestore.instance.collection('users').get();
//
//       // التحقق من الحقول داخل كل مستند
//       querySnapshot.docs.forEach((doc) {
//         print('Document data: ${doc.data()}'); // طباعة البيانات داخل المستند
//       });
//
//       // جلب المدن
//       final allCities = querySnapshot.docs
//           .map((doc) {
//         // التحقق من وجود الحقل 'city' أولاً
//         if (doc.data().containsKey('city')) {
//           return doc['city'] as String?;
//         }
//         return null; // إرجاع null إذا لم يكن الحقل موجوداً
//       })
//           .where((city) => city != null) // التأكد من عدم وجود null
//           .cast<String>() // تحويل إلى List<String>
//           .toSet() // إزالة التكرار
//           .toList();
//
//       setState(() {
//         cities = allCities;
//       });
//     } catch (e) {
//       print('Error fetching cities: $e');
//     }
//   }
//
//   // جلب المناطق بناءً على المدينة
//   Future<void> fetchRegions(String city) async {
//     try {
//       final querySnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .where('city', isEqualTo: city)
//           .get();
//
//       // جلب المناطق
//       final allRegions = querySnapshot.docs
//           .map((doc) {
//         if (doc.data().containsKey('region')) {
//           return doc['region'] as String?;
//         }
//         return null;
//       })
//           .where((region) => region != null) // التأكد من عدم وجود null
//           .cast<String>()
//           .toSet()
//           .toList();
//
//       setState(() {
//         regions = allRegions;
//         selectedRegion = null; // إعادة ضبط الاختيار
//       });
//     } catch (e) {
//       print('Error fetching regions: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.center, // لتوسيط النص والرمز
//           children: [
//             // صورة داخل دائرة مع تأثير الظل
//             Container(
//               width: 50,
//               height: 50,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 image: DecorationImage(
//                   image: AssetImage('assets/images/logoPH.jpg'), // ضع رابط الصورة هنا
//                   fit: BoxFit.cover,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.5),
//                     spreadRadius: 2,
//                     blurRadius: 4,
//                     offset: Offset(0, 2), // ظل على المحور العمودي
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(width: 10), // مسافة بين الأيقونة والنص
//             Text(
//               "Pharmacy de Gard",
//               style: TextStyle(
//                 fontWeight: FontWeight.bold, // خط عريض
//                 fontSize: 22, // حجم النص أكبر قليلاً
//                 color: Colors.white, // لون النص أبيض ليتناسب مع الخلفية
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: const Color.fromARGB(255, 3, 20, 255), // لون خلفية الشريط
//         elevation: 10, // زيادة الظل لإضافة تأثير 3D
//         shadowColor: Colors.blueAccent, // لون الظل
//         centerTitle: true, // لتوسيط النص بالكامل
//         toolbarHeight: 80, // زيادة ارتفاع الشريط
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.blueAccent, Colors.purple], // تأثير تدرج لوني جذاب
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center, // لتوسيط الحقول
//           children: [
//             SizedBox(height: 20), // مسافة بين AppBar والعناصر
//
//             // اختيار المدينة مع أيقونة
//             DropdownButton<String>(
//               value: selectedCity,
//               isExpanded: true,
//               hint: Row(
//                 children: [
//                   Icon(Icons.location_city, color: Colors.blue), // أيقونة المدينة
//                   SizedBox(width: 10),
//                   Text("Choose a city"),
//                 ],
//               ),
//               items: cities.map((city) {
//                 return DropdownMenuItem<String>(
//                   value: city,
//                   child: Text(city),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedCity = value;
//                   fetchRegions(value!); // جلب المناطق عند اختيار مدينة
//                 });
//               },
//             ),
//             SizedBox(height: 20),
//
//             // اختيار المنطقة مع أيقونة
//             DropdownButton<String>(
//               value: selectedRegion,
//               isExpanded: true,
//               hint: Row(
//                 children: [
//                   Icon(Icons.location_on, color: Colors.blue), // أيقونة المنطقة
//                   SizedBox(width: 10),
//                   Text("Choose a region"),
//                 ],
//               ),
//               items: regions.map((region) {
//                 return DropdownMenuItem<String>(
//                   value: region,
//                   child: Text(region),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedRegion = value;
//                 });
//               },
//             ),
//             SizedBox(height: 30),
//
//             // زر الانتقال إلى صفحة الصيدليات مع أيقونة
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   if (selectedCity != null && selectedRegion != null) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => PharmacyListPage(
//                           city: selectedCity!,
//                           region: selectedRegion!,
//                         ),
//                       ),
//                     );
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Please select both city and region')),
//                     );
//                   }
//                 },
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.search, color: Colors.black), // أيقونة البحث
//                     SizedBox(width: 10),
//                     Text("View Pharmacies"),
//                   ],
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.amber, // اللون الأصفر للزر
//                   padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15), // مساحة الزر
//                   textStyle: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black, // اللون الأسود للنص
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }