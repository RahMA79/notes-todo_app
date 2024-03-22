
import 'package:flutter/material.dart';
import 'package:notes_app/Notes&ToDo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
          () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return const HomePage();
        }));
      },
    );
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(

          clipBehavior: Clip.none,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
              image: AssetImage(
                "assets/R.png",
              ),
                      ),
              SizedBox(
                height: 30,
              ),
              Text('Todo App', style: TextStyle(
                color: Colors.black,
                fontSize: 40,
                fontWeight: FontWeight.w400,

                shadows: [
                  Shadow(color: Colors.black12,
                  blurRadius: 2,
                  offset: Offset(2, 3))
                ]
              ),)
            ],
          ),),),

    );
  }
}
