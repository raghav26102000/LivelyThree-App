import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "#",
        authDomain: "thelivelythree-v1.firebaseapp.com",
        projectId: "thelivelythree-v1",
        storageBucket: "thelivelythree-v1.firebasestorage.app",
        messagingSenderId: "675490404684",
        appId: "1:675490404684:android:ba6d843d5987d780d317e9",
        // Optional: only needed for Analytics
        measurementId: null,
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
}


// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';

// Future initFirebase() async {
//   if (kIsWeb) {
//     await Firebase.initializeApp(
//         options: FirebaseOptions(
//             apiKey: "#",
//             authDomain: "thelivelythree.firebaseapp.com",
//             projectId: "thelivelythree",
//             storageBucket: "thelivelythree.appspot.com",
//             messagingSenderId: "235588715926",
//             appId: "1:235588715926:web:835e03331a0d21cc9849b7",
//             measurementId: "G-74DYKPN401"));
//   } else {
//     await Firebase.initializeApp();
//   }
// }
