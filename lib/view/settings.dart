import 'package:demirbasim/widgets/appbars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  Demirbas.appbars(context, 'Ayarlar'),     
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            ListTile(
              title: const Text('Kullanıcı Ayarları'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Kullanıcı Ayarları Sayfasına git
                if (kDebugMode) {
                  print('Kullanıcı Ayarlarına gidildi.');
                }
              },
            ),
            ListTile(
              title: const Text('Bildirim Ayarları'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Bildirim Ayarları Sayfasına git
                if (kDebugMode) {
                  print('Bildirim Ayarlarına gidildi.');
                }
              },
            ),
            ListTile(
              title: const Text('Hesap Ayarları'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Hesap Ayarları Sayfasına git
                if (kDebugMode) {
                  print('Hesap Ayarlarına gidildi.');
                }
              },
            ),
            SwitchListTile(
              title: const Text('Debug Mode'),
              value: true, // TODO: Gerçek değer burada belirlenecek
              onChanged: (bool value) {
                // TODO: Debug Mode'nun değerini güncelle
                if (kDebugMode) {
                  print('Debug Mode: $value');
                }
              },
            ),
            ListTile(
              title: const Text('Uygulama Hakkında'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Uygulama Hakkında Sayfasına git
                if (kDebugMode) {
                  print('Uygulama Hakkında Sayfasına gidildi.');
                }
              },
            ),
          ],
        ).toList(),
      ),
    );
  }
}
