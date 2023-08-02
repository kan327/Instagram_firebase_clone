import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_flutter/responsive/responsive_layout_screen.dart';
import 'package:instagram_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/view/login_view.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: 'AIzaSyCLIRE7-RZXsbsGrZyZtV97O7-cH3usF1A',
            appId: '1:1080426379018:web:62d6a7e29134cccac2acf3',
            messagingSenderId: '1080426379018',
            projectId: 'instagramflutter-26927',
            storageBucket: 'instagramflutter-26927.appspot.com'));
  } else {
    await Firebase.initializeApp();
  }
  // await Firebase.initializeApp(
  //   options: FirebaseOptions(apiKey: apiKey, appId: appId, messagingSenderId: messagingSenderId, projectId: projectId)
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return const MaterialApp(
    //   home: Scaffold(
    //     body: Center(
    //       child: Text("this is web, hello"),
    //     ),
    //   ),
    // );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,  
        title: 'instagram clone',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          // apa perbedaan dari ketiga stream ada dibawah ini
          // stream: FirebaseAuth.instance.idTokenChanges(),
          // stream: FirebaseAuth.instance.userChanges(),
          stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const ResponsiveLayout(
                      mobileScreenLayout: MobileScreenLayout(),
                      webScreenLayout: WebScreenLayout());
                } else if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text('Err :3\n ${snapshot.error}'),
                    ),
                  );
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                );
              }

              return const LoginView();
            },
        ),
      ),
    );
  }
}

// flutter run -d chrome --web-renderer html // to run the app

// flutter build web --web-renderer html --release // to generate a production build

// Stream
// idTokenChanges() dapat digunakan untuk memperbarui token akses untuk memperbarui data pengguna yang terautentikasi di Firebase. 
//  Misalnya, pada aplikasi toko online, saat pengguna memperbarui profil mereka, token akses baru akan dihasilkan sehingga data profil dapat diperbarui dengan benar.

// userChanges() dapat digunakan untuk memperbarui tampilan UI aplikasi saat status otentikasi pengguna berubah. 
//  Misalnya, pada aplikasi toko online, saat pengguna masuk atau keluar, tampilan keranjang belanja akan berubah untuk menampilkan produk yang tersedia untuk pembelian.

// authStateChanges() dapat digunakan untuk memverifikasi status otentikasi pengguna saat masuk ke aplikasi. 
//  Misalnya, pada aplikasi perbankan, jika pengguna tidak masuk, mereka tidak dapat mengakses layanan perbankan. Jadi, dengan authStateChanges(), aplikasi dapat memastikan bahwa pengguna masuk sebelum mengakses layanan perbankan.