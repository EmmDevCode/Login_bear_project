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

  final emailFocus = FocusNode();
  final passFocus = FocusNode();

  // 2) Listeners (Oyentes/Chismosito)
  @override
  void initState() {
    super.initState();
    
    // Listener para el campo de Email
    emailFocus.addListener(() {
      setState(() {
        if (emailFocus.hasFocus) {
          isHandsUp?.change(false);
          isChecking?.change(true); // Activa la animación "checking" al enfocarse
        } else {
          isChecking?.change(false); // Desactiva al perder el foco
        }
      });
    });

    // Listener para el campo de Contraseña (CORREGIDO: Ahora dentro de initState)
    passFocus.addListener(() {
      setState(() {
        // Manos arriba en password (tapa los ojos)
        isHandsUp?.change(passFocus.hasFocus);
        // Desactiva la animación "checking" cuando está en el campo de contraseña
        isChecking?.change(false);
      });
    });
  }

  // 3) Dispose (Limpieza para evitar pérdidas de memoria)
  @override
  void dispose() {
    // Es crucial liberar los recursos de FocusNode y Rive Controller
    emailFocus.dispose();
    passFocus.dispose();
    controller?.dispose();
    super.dispose();
  }

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

                  isChecking = controller!.findSMI<SMIBool>('isChecking');
                      isHandsUp = controller!.findSMI<SMIBool>('isHandsUp');
                      trigSuccess = controller!.findSMI<SMIBool>('trigSuccess');
                      trigFail = controller!.findSMI<SMIBool>('trigFail');
                       },
              ),
            ), 
            //Espacio entre el oso y el texto email
            const SizedBox(height: 10),
            //campo de texto del email 
            TextField(
               focusNode: emailFocus, // Asignación de FocusNode
              onChanged: (value){
                isChecking?.change(value.isNotEmpty);
                isHandsUp?.change(false);
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
              focusNode: passFocus, // Asignación de FocusNode
              onChanged: (value) {
                // No es necesario cambiar la lógica de manos aquí, se gestiona con el focusListener.
                    // Si quieres que las manos se levanten solo si hay focus Y estás escribiendo:
                    // isHandsUp?.change(passFocus.hasFocus);
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
                        isHandsUp?.change(_obscurePassword && passFocus.hasFocus);
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
                textAlign: TextAlign.right,  //alinear texto a la derecha
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
                onPressed: () { // Ejemplo: llamar a trigSuccess o trigFail al presionar el botón
                    // trigSuccess?.change(true); 
                    // trigFail?.change(true);
},
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