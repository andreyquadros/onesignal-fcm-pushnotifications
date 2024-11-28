import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class AppSignals extends StatefulWidget {
  const AppSignals({Key? key}) : super(key: key);

  @override
  State<AppSignals> createState() => _AppSignalsState();
}

class _AppSignalsState extends State<AppSignals> {

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // Defina o nível de log, se necessário
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    // Inicialize o OneSignal com o App ID
    OneSignal.initialize("9fec7181-752a-496b-aa0a-7bd04d2bea9e");

    // Solicite permissão para notificações push
    var status = await OneSignal.Notifications.requestPermission(true);
    if (status != OSNotificationPermission.authorized) {
      print('Usuário não autorizou notificações push');
    } else {
      print('Notificações autorizadas!');
    }

    // Tente obter o Player ID
    String? playerId = OneSignal.User.pushSubscription.id;
    if (playerId != null) {
      print("Player ID obtido: $playerId");
    } else {
      print("Player ID ainda não disponível. Tentando novamente em 5 segundos...");
      // Aguarde 5 segundos e tente novamente
      await Future.delayed(Duration(seconds: 5));
      playerId = OneSignal.User.pushSubscription.id;
      if (playerId != null) {
        print("Player ID obtido: $playerId");
      } else {
        print("Player ID ainda não disponível após nova tentativa.");
      }
    }

    // Configure handlers para eventos
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      print('Notificação recebida: ${event.notification.jsonRepresentation()}');
      event.preventDefault(); // Impede a exibição automática da notificação
      event.notification.display(); // Exibe a notificação manualmente
    });

    OneSignal.Notifications.addClickListener((event) {
      print('Notificação clicada: ${event.notification.jsonRepresentation()}');
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text('App Signals Example'),
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
