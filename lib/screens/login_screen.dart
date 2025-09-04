import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  @override
  Widget build(BuildContext context) {

    //para obtener el tamaño de la pantalla (dispositivo)
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
              width: size.width,
              height: 200,
              child: RiveAnimation.asset('assets/animated_login_character.riv'),
            ), 
            //Espacio entre el oso y el texto email
            const SizedBox(height: 10),
            //campo de texto del email
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Email",
                prefixIcon: const Icon(Icons.mail),
                border: OutlineInputBorder(
                  //esquina redondeadas
                  borderRadius: BorderRadius.circular(12),
                )
              ),
            ),
            const SizedBox(height: 10),
            //campo de texto para password
            TextField(
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: "Password",
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                    border: OutlineInputBorder(
                    //esquina redondeadas
                    borderRadius: BorderRadius.circular(12),
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}