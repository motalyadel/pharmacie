import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class PharmaciesListPage extends StatefulWidget {
  final String city;
  final String region;

  PharmaciesListPage({required this.city, required this.region});

  @override
  _PharmaciesListPageState createState() => _PharmaciesListPageState();
}

class _PharmaciesListPageState extends State<PharmaciesListPage> {
  String searchQuery = "";

  void _openMap(double latitude, double longitude) async {
    final url =
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Impossible d'ouvrir Google Maps.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pharmacies Ouvertes")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Barre de recherche
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Rechercher une pharmacie...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
            SizedBox(height: 10),

            // Liste des pharmacies
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('status', isEqualTo: 'open')
                    .where('city', isEqualTo: widget.city)
                    .where('region', isEqualTo: widget.region)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var users = snapshot.data!.docs;

                  // Filtrer les résultats selon la recherche
                  var filteredUsers = users.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final name = (data['name'] ?? '').toLowerCase();
                    return name.contains(searchQuery);
                  }).toList();

                  if (filteredUsers.isEmpty) {
                    return Center(child: Text("Aucune pharmacie trouvée."));
                  }

                  return ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final data = filteredUsers[index].data() as Map<String, dynamic>;
                      final coordinates = data['coordinates'] as Map<String, dynamic>?;

                      final latitude = coordinates?['latitude'];
                      final longitude = coordinates?['longitude'];

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(10),
                          leading: CircleAvatar(
                            backgroundColor: Colors.green[700],
                            child: Icon(Icons.local_pharmacy, color: Colors.white),
                          ),
                          title: Text(
                            data['name'] ?? 'Nom inconnu',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("${data['city']}, ${data['region']}"),
                          trailing: latitude != null && longitude != null
                              ? IconButton(
                            icon: Icon(Icons.map, color: Colors.blue),
                            onPressed: () => _openMap(latitude, longitude),
                          )
                              : Icon(Icons.error, color: Colors.red),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// **************************

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:intl/intl.dart';
//
// class PharmacyListPage extends StatefulWidget {
//   final String city;
//   final String region;
//
//   PharmacyListPage({required this.city, required this.region});
//
//   @override
//   _PharmacyListPageState createState() => _PharmacyListPageState();
// }
//
// class _PharmacyListPageState extends State<PharmacyListPage> {
//   Position? _userPosition;
//   double _maxDistanceInMeters = 50000;
//   int _weekNumber = 0;
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _getUserLocation();
//     _calculateWeekNumber();
//   }
//
//   void _calculateWeekNumber() {
//     DateTime now = DateTime.now();
//     try {
//       setState(() {
//         _weekNumber = (int.parse(DateFormat("w").format(now))) % 3;
//       });
//     } catch (e) {
//       _weekNumber = 0;
//     }
//   }
//
//   Future<void> _getUserLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please enable location services.")),
//       );
//       return;
//     }
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Location permission is required.")),
//         );
//         return;
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Location permissions are permanently denied.")),
//       );
//       return;
//     }
//
//     final position = await Geolocator.getLastKnownPosition() ?? await Geolocator.getCurrentPosition();
//     setState(() {
//       _userPosition = position;
//       _isLoading = false;
//     });
//   }
//
//   double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//     return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance
//         .collection('users')
//         .where('city', isEqualTo: widget.city)
//         .where('region', isEqualTo: widget.region)
//         .snapshots();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 50,
//               height: 50,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 image: DecorationImage(
//                   image: AssetImage('assets/images/logoPH.jpg'),
//                   fit: BoxFit.cover,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.5),
//                     spreadRadius: 2,
//                     blurRadius: 4,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(width: 10),
//             Expanded(  // استخدام Expanded هنا
//               child: Text(
//                 "Pharmacies de Garde",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 22,
//                   color: Colors.white,
//                 ),
//                 overflow: TextOverflow.ellipsis, // التعامل مع النص الطويل
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: const Color.fromARGB(255, 3, 20, 255),
//         elevation: 10,
//         shadowColor: Colors.blueAccent,
//         centerTitle: true,
//         toolbarHeight: 80,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.blueAccent, Colors.purple],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: _getUserLocation,
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : StreamBuilder<QuerySnapshot>(
//         stream: _stream,
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           final items = snapshot.data?.docs ?? [];
//           final nearbyPharmacies = items.where((doc) {
//             final data = doc.data() as Map<String, dynamic>;
//             final coordinates = data['coordinates'] as Map<String, dynamic>?;
//             if (coordinates == null) return false;
//
//             final latitude = coordinates['latitude'];
//             final longitude = coordinates['longitude'];
//             if (latitude == null || longitude == null) return false;
//
//             final distance = _calculateDistance(
//               _userPosition!.latitude,
//               _userPosition!.longitude,
//               latitude,
//               longitude,
//             );
//             return distance <= _maxDistanceInMeters;
//           }).toList();
//
//           if (nearbyPharmacies.isEmpty) {
//             return Center(child: Text("No nearby pharmacies found."));
//           }
//
//           final paginatedPharmacies =
//           nearbyPharmacies.skip(_weekNumber * 3).take(3).toList();
//
//           return ListView.builder(
//             itemCount: paginatedPharmacies.length,
//             itemBuilder: (context, index) {
//               final data =
//               paginatedPharmacies[index].data() as Map<String, dynamic>;
//               final coordinates =
//               data['coordinates'] as Map<String, dynamic>?;
//
//               final latitude = coordinates?['latitude'];
//               final longitude = coordinates?['longitude'];
//
//               return Card(
//                 elevation: 5,
//                 margin: EdgeInsets.symmetric(vertical: 10),
//                 child: ListTile(
//                   leading:
//                   Icon(Icons.local_pharmacy, color: Colors.green),
//                   title: Text(data['name'] ?? "Unknown"),
//                   subtitle: Text("Status: ${data['status'] ?? "Unknown"}"),
//                   trailing: (latitude != null && longitude != null)
//                       ? IconButton(
//                     icon: Icon(Icons.map, color: Colors.blue),
//                     onPressed: () => _openMap(latitude, longitude),
//                   )
//                       : Icon(Icons.error, color: Colors.red),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   void _openMap(double latitude, double longitude) async {
//     final url = "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
//     final uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("تعذر فتح الخريطة، يرجى المحاولة مرة أخرى.")),
//       );
//     }
//   }
// }
