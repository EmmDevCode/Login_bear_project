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
  bool _isLoading = false; // Estado de carga para el botón

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

  // Función para determinar el primer error de password
  String? _getPasswordError(String pass) {
    // mínimo 8, una mayúscula, una minúscula, un dígito y un especial
    if (pass.length < 8) return 'Mínimo 8 caracteres';
    if (!RegExp(r'[A-Z]').hasMatch(pass)) return 'Debe contener al menos una mayúscula';
    if (!RegExp(r'[a-z]').hasMatch(pass)) return 'Debe contener al menos una minúscula';
    if (!RegExp(r'\d').hasMatch(pass)) return 'Debe contener al menos un número';
    if (!RegExp(r'[^A-Za-z0-9]').hasMatch(pass)) return 'Debe contener al menos un carácter especial';
    return null;
  }

  // Widget para construir un criterio del checklist
  Widget _buildCriterion(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check : Icons.close,
          color: isValid ? Colors.green : Colors.red,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
  
  // 4.4 accion al boton  
  void _onLogin() async {
    setState(() => _isLoading = true);

    // Normalizar estado
    FocusScope.of(context).unfocus();
    _typingDebounce?.cancel();
    isChecking?.change(false);
    isHandsUp?.change(false);
    numLook?.value = 50.0;

    // Esperar un frame para que la State Machine procese los cambios
    await Future.delayed(Duration.zero);

    // Validar
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text;
     
    // Recalcular errores
    final eError = email.isNotEmpty && !isValidEmail(email) ? 'Email inválido' : null;
    final pError = _getPasswordError(pass);

    //para que se muestre en la UI
    setState(() {
      emailError = eError;
      passError = pError;
    });

    // Simular envío por ~1s
    await Future.delayed(const Duration(seconds: 1));

    //4.7 Acitvar triggers
    if (eError == null && pError == null) {
      trigSuccess?.fire();
    } else {
      trigFail?.fire();
    }
    setState(() => _isLoading = false);
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
          numLook?.value = 50.0;
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
                child: RiveAnimation.asset(
                  'assets/animated_login_character.riv',
                  stateMachines: ["Login Machine"],
                  onInit: (artboard) {
                    controller = StateMachineController.fromArtboard(
                      artboard,
                      "Login Machine",
                    );
                    if (controller == null) return;
                    artboard.addController(controller!);
                    isChecking = controller!.findSMI<SMIBool>('isChecking');
                    isHandsUp = controller!.findSMI<SMIBool>('isHandsUp');
                    trigSuccess = controller!.findSMI('trigSuccess');
                    trigFail = controller!.findSMI('trigFail');
                    //2.3 enlazar variable con la animacion
                    numLook = controller!.findSMI('numLook');
                  },
                ),
              ),
              //Espacio entre el oso y el texto email
              const SizedBox(height: 10),
              //campo de texto del email 
              TextField(
                focusNode: emailFocus, // Asignación de FocusNode
                //4.8 enlazar controller al textfield
                controller: emailCtrl,
                onChanged: (value) {
                  isChecking?.change(value.isNotEmpty);
                  isHandsUp?.change(false);
                  //ajustes de limite de 0 a 100
                  //80 es una medida de calibracion
                  final look = (value.length / 120.0 * 100.0).clamp(0.0, 100.0);
                  numLook?.value = look;
                  //3.3 Debounnce: si vuelve a teclear, reinicia el contador
                  _typingDebounce?.cancel();
                  _typingDebounce = Timer(const Duration(seconds: 3), () {
                    if (!mounted) return;
                    //mirada neutra
                    isChecking?.change(false);
                  });
                  // Actualizar error en vivo para email
                  setState(() {
                    emailError = value.trim().isNotEmpty && !isValidEmail(value.trim()) ? 'Email inválido' : null;
                  });
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  errorText: emailError,
                  hintText: "Email",
                  prefixIcon: const Icon(Icons.mail),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                focusNode: passFocus,
                controller: passCtrl,
                onChanged: (value) {
                  // Actualizar error en vivo para password
                  setState(() {
                    passError = _getPasswordError(value);
                  });
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              // Checklist dinámico para password (solo si hay texto o foco)
              if (passFocus.hasFocus || passCtrl.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCriterion('Mínimo 8 caracteres', passCtrl.text.length >= 8),
                      _buildCriterion('Al menos una mayúscula', RegExp(r'[A-Z]').hasMatch(passCtrl.text)),
                      _buildCriterion('Al menos una minúscula', RegExp(r'[a-z]').hasMatch(passCtrl.text)),
                      _buildCriterion('Al menos un número', RegExp(r'\d').hasMatch(passCtrl.text)),
                      _buildCriterion('Al menos un carácter especial', RegExp(r'[^A-Za-z0-9]').hasMatch(passCtrl.text)),
                    ],
                  ),
                ),
              const SizedBox(height: 10),
              SizedBox(
                width: size.width,
                child: const Text(
                  "Forgot Password?",
                  textAlign: TextAlign.right, //alinear texto a la derecha
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(height: 10),
              MaterialButton(
                minWidth: size.width,
                height: 50,
                color: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onPressed: _isLoading ? null : _onLogin,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Color.fromARGB(255, 0, 0, 0))
                    : const Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
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
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
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
    //4.1 limíeza de los controller
    emailFocus.dispose();
    passFocus.dispose();
    controller?.dispose();
    _typingDebounce?.cancel();
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }
}