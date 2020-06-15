import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

// ignore: must_be_immutable
class DetailForm extends StatefulWidget{
  //const DetailForm({Key key}) : super(key: key);
  DetailForm({@required this.email, @required this.password, @required this.comingFrom, this.firstName="", this.lastName = "", this.phoneNumber = "", this.fileName = "", this.downloadURL = ""});

  final String email;
  final String password;
  String firstName;
  String lastName;
  String phoneNumber;
  String comingFrom;
  String fileName;
  String downloadURL;

  @override
  _DetailFormState createState() => _DetailFormState();
}

class _DetailFormState extends State<DetailForm>{

  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;

  FirebaseUser loggedInUser;


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool agreedTOS = true;
  bool _obscureText = true;
  bool _informationSaved = false;

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    widget.comingFrom = "";
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile == null){
      return;
    }
    setState(() {
      _image = File(pickedFile.path);
    });
  }

  void getCurrentUser() async {
    try {
      loggedInUser = await _auth.currentUser();
      if (loggedInUser != null) {
        print(loggedInUser.email);
        setState(() {});
      }
    } catch (e) {
      print("ABC");
    }
  }

  void toggle(){
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();

  @override
  void initState(){
    super.initState();
    emailController.text = widget.email;
    passwordController.text = widget.password;
    if(widget.comingFrom == "profile"){
      firstNameController.text = widget.firstName;
      lastNameController.text = widget.lastName;
      phoneNumberController.text = widget.phoneNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Update Information'),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () => Navigator.pop(context,false),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            labelText: 'First Name',
                          ),
                          controller: firstNameController,
                          validator: (String value){
                            if (value.trim().isEmpty){
                              return 'First Name is required';
                            }
                            return null;
                          },
                          onSaved: (value){
                            setState(() {
                              widget.firstName = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            labelText: 'Last Name',
                          ),
                          controller: lastNameController,
                          validator: (value){
                            if (value.trim().isEmpty){
                              return 'Last Name is required';
                            }
                            return null;
                          },
                          onSaved: (value){
                            setState(() {
                              widget.lastName = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                      labelText: 'Email',
                    ),
                    enabled: false,
                    controller: emailController,
                    validator: (value){
                      if(value.trim().isEmpty){
                        return 'Email is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: toggle,
                      ),
                    ),
                    enabled: widget.comingFrom == 'registration' ? false : true,
                    controller: passwordController,
                    validator: (value){
                      if (value.length < 6) {
                        return 'Password too short';
                      }
                      return null;
                    },
                    obscureText: _obscureText,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      labelText: 'Phone Number',
                    ),
                    controller: phoneNumberController,
                    keyboardType: TextInputType.phone,
                    validator: (value){
                      if (value.trim().isEmpty){
                        return 'Phone Number is required';
                      }
                      return null;
                    },
                    onSaved: (value){
                      setState(() {
                        widget.phoneNumber = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: widget.comingFrom == "profile" ? Image.network(widget.downloadURL) :
                    _image == null
                        ? Text('No Image Selected')
                        : Image.file(_image, fit: BoxFit.fill, width: 200, height: 200) ,
                  ),
                  SizedBox(height: 16),
                  RaisedButton(
                    onPressed: getImage,
                    child: Text('Select Image'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        Checkbox(
                          value: agreedTOS,
                          onChanged: setAgreedTOS,
                        ),
                        GestureDetector(
                          onTap: () => setAgreedTOS(!agreedTOS),
                          child: Text(
                            'I agree to the Terms of Service & Privacy Policy',
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Spacer(),
                      OutlineButton(
                        highlightedBorderColor: Theme.of(context).primaryColorDark,
                        onPressed: submittable() ? _submit : null,
                        child: Text('Upload Information'),
                      ),
                      OutlineButton(
                        highlightedBorderColor: Theme.of(context).primaryColorDark,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                        ),
                        onPressed: informationSaved() ? _moveForward : null,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }

  bool submittable() {
    return agreedTOS;
  }

  bool informationSaved() {
    return _informationSaved;
  }

  void _moveForward() {
    Navigator.pushNamed(_scaffoldKey.currentContext, 'home_screen');
  }

   void _submit() {
    final form = _formKey.currentState;
    if(form.validate()){
      if(agreedTOS){
        print('From submitted');
        form.save();
        _showDialog();
        uploadPic();
        //addUser();
        setState(() {
          _informationSaved = true;
        });
      }
      else{
        print('Form not submitted');
      }
    }
   // _formKey.currentState.validate();



  }

  void setAgreedTOS(bool newValue){
    setState(() {
      agreedTOS = newValue;
    });
  }

  _showDialog(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
            content: Text('Saving Information'),
          duration: Duration(seconds: 3),
        ),
    );
  }

  void addUser() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    await _firestore.collection('user').document(firebaseUser.uid).setData({

      'firstName' : widget.firstName,
      'lastName' : widget.lastName,
      'password': widget.password,
      'phoneNumber': widget.phoneNumber,
      'email': widget.email,
      'fileName': widget.fileName,
      'url': widget.downloadURL,
    }).then((_) {
      print("success");
    });
  }

  Future uploadPic() async{
    widget.fileName = basename(_image.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(widget.fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
    widget.downloadURL = await taskSnapshot.ref.getDownloadURL();
    print(widget.downloadURL);
    addUser();
    setState(() {
      print("Profile Picture uploaded");
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    });
  }
}