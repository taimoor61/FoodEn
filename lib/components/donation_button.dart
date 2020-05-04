import 'package:flutter/material.dart';

class DonationButton extends StatelessWidget {
  
  DonationButton({this.image});

  final AssetImage image;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, 'payment_screen');
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 2.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Image(
          image: image,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
