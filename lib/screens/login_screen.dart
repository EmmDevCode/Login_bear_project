import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
//3.1 libreria para timer
import 'dart:async';

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
  SMITrigger? trigSuccess; 
  SMITrigger? trigFail;
  SMINumber? numLook; //2.1 variable para el recorrido de la memoria

  final emailFocus = FocusNode();
  final passFocus = FocusNode();

  // 3.2 Timer para detener la mirada al dejar de teclear
  Timer? _typingDebounce;

  // 4.1 Controllers
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  // 4.2 Errores para mostrar en el UI
  String? emailError;
  String? passError;

  //4.3 Validadores
  bool isValidEmail(String email) {
    final re = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return re.hasMatch(email);
  }

  bool isValidPassword(String pass) {
    // mínimo 8, una mayúscula, una minúscula, un dígito y un especial
    final re = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$',
    );
    return re.hasMatch(pass);
  }

  // 4.4 accion al boton 
  void _onLogin(){
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text;

   // Recalcular errores

   final eError = isValidEmail(email) ? null : 'Email Invalido';
   final pError = isValidPassword(pass) ? null :
   'Minimo 8 Caracteres, 1 mayuscula, 1 minuscula, 1 numero y 1 caracter especial';
  
  //para que se muestre en la UI
  setState(() {
    emailError = eError;
    passError = pError;
  });

   //4.5 cerrar el teclado y bajar
   FocusScope.of(context).unfocus();
   _typingDebounce?.cancel();
   isChecking?.change(false);
   isHandsUp?.change(false);
   numLook?.value = 50.0; 


   //4.7 Acitvar triggers
   if (eError == null && pError == null){
    trigSuccess?.fire();
   } else{
   trigFail?.fire();
   }
  }

 


  // 2) Listeners (Oyentes/Chismosito)
  @override
  void initState() {
    super.initState();
    
    // Listener para el campo de Email
    emailFocus.addListener(() {
      setState(() {
        if (emailFocus.hasFocus) {
          isHandsUp?.change(false);
          //2.2  mirada neutral al escribir al enfocar email
          numLook?.value = 50.0;

         
              
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
                      trigSuccess = controller!.findSMI('trigSuccess');
                      trigFail = controller!.findSMI('trigFail');
                      //2.3 enlazar variable con la animacion
                      numLook = controller!.findSMI('numLook');
                       },//clamp
              ),
            ), 
            //Espacio entre el oso y el texto email
            const SizedBox(height: 10),
            //campo de texto del email 
            TextField(
               focusNode: emailFocus, // Asignación de FocusNode
               //4.8 enlazar controller al textfield
               controller: emailCtrl,
              onChanged: (value){
                isChecking?.change(value.isNotEmpty);
                isHandsUp?.change(false);
                //ajustes de limite de 0 a 100
                //80 es una medida de calibracion
                final look = (value.length/ 120.0 * 100.0).clamp(
                  0.0, 
                  100.0
                  );
                  numLook?.value = look;
                  //3.3 Debounnce: si vuelve a teclear, reinicia el contador
                  _typingDebounce?.cancel(); //cancela cualquier timer existente
                  _typingDebounce = Timer(const Duration(seconds: 3), (){
                    if (!mounted) return;
                  //mirada neutra
                    isChecking?.change(false);
                  }
                  );
               //si la pantalla se cierra
              },
          
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                errorText: emailError,
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
              controller: passCtrl,
              onChanged: (value) {
                // No es necesario cambiar la lógica de manos aquí, se gestiona con el focusListener.
                    // Si quieres que las manos se levanten solo si hay focus Y estás escribiendo:
                    // isHandsUp?.change(passFocus.hasFocus);
              },
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                errorText: passError,
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
                onPressed: (_onLogin), 
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

  // 3) Dispose (Limpieza para evitar pérdidas de memoria)
  @override
  void dispose() {
    // Es crucial liberar los recursos de FocusNode y Rive Controller
    //4.1 limíeza de los controllers
    emailFocus.dispose();
    passFocus.dispose();
    controller?.dispose();
    super.dispose();
    _typingDebounce?.cancel();
  }
}
