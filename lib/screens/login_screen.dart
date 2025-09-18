import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  StateMachineController? controller; 
  SMIBool? isChecking;
  SMIBool? isHandsUp;
  SMIBool? trigSuccess; 
  SMIBool? trigFail;

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
              child: RiveAnimation.asset('assets/animated_login_character.riv',
              stateMachines: ["Login Machine"],
              onInit: (artboard){
                controller = StateMachineController.fromArtboard(
                  artboard, 
                  "Login Machine",
                );
                 if(controller == null) return;
                  artboard.addController(controller!);

                  isChecking  = controller!.findSMI('isChecking');
                  isHandsUp   = controller!.findSMI('isHandsUp');
                      trigSuccess = controller!.findSMI('trigSuccess');
                      trigFail    = controller!.findSMI('trigFail');
                       },
              ),
            ), 
            //Espacio entre el oso y el texto email
            const SizedBox(height: 10),
            //campo de texto del email
            TextField(
              onChanged: (value){
                if(isHandsUp != null){
                  isHandsUp!.change(false);
                  }
                if(isChecking == null) return;
                 isChecking!.change(true);
              },
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
              onChanged: (value) {
                if(isHandsUp != null){  
                    isHandsUp!.change(true);
                  }
                  if(isChecking == null) return;
                  isChecking!.change(false);
              },
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
                        isHandsUp!.change(false);
                      });
                    },
                  ),
                    border: OutlineInputBorder(
                    //esquina redondeadas
                    borderRadius: BorderRadius.circular(12),
                  )
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: size.width,
                child: const Text("Forgot Password?",
                textAlign: TextAlign.right,
                style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(height: 10),
               MaterialButton(
                minWidth:size.width,
                height: 50,
                color: Colors.purple,
                shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                ),
                onPressed: () {},
                child: Text("Login",
                style: TextStyle(
                  color: Colors.white)),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {},
                       child: const Text("Sign Up",
                       style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline
                        ),
                       ),
                    ),
            ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}