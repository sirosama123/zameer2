
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:url_launcher/url_launcher.dart';


class Slider23 extends StatefulWidget {
  const Slider23({super.key});

  @override
  State<Slider23> createState() => _Slider23State();
}

class _Slider23State extends State<Slider23> {
  @override
  
  late PageController _pageController;
  int activeIndex = 0;
  List<String> images = [
    "https://lh5.googleusercontent.com/p/AF1QipOJWL6kpJCRsJbv4OEQNcKwq2eqy69II1KyOjF5=w203-h152-k-no",
    "https://lh5.googleusercontent.com/p/AF1QipPM8ojt_sR69O4gybgv-LRfKHkQl32fAJS8gQpJ=w203-h270-k-no",
    "https://lh5.googleusercontent.com/p/AF1QipPry8BBjB8ONOqZZXgEqCOG84eXawHHbeOePggl=w203-h152-k-no",
    "https://lh5.googleusercontent.com/p/AF1QipPry8BBjB8ONOqZZXgEqCOG84eXawHHbeOePggl=w203-h152-k-no",
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
  }
 int activePage = 0;
@override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: images.length, 
          itemBuilder: (context,index,realIndex){
            final img = images[index];
            return buildImage(img,index);
          }, 
          options: CarouselOptions(   
            height: 200.h,
            autoPlay: true,
            reverse: true,
            autoPlayInterval: Duration(seconds: 2),
            viewportFraction: 1/2,
            onPageChanged: (index, reason) {
              setState(() {
                activeIndex = index;
              });
            },
          )),
          SizedBox(height: 10,),
        
      ],
    );

      
  }
  Widget buildImage(String img , int index)=> Padding(
    padding:EdgeInsets.all(10),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.white,width: 2),
        image: DecorationImage(
          image: NetworkImage(img),
          fit: BoxFit.cover
          )
      ),
          
        ),
  );
  
}
