import 'package:flutter/material.dart';
import 'package:winksy/mixin/constants.dart';
import 'package:winksy/mixin/mixins.dart';

import '../../component/app_bar.dart';
import '../../theme/custom_colors.dart';

class IGameSettings extends StatefulWidget {
  const IGameSettings({Key? key}) : super(key: key);

  @override
  State<IGameSettings> createState() => _IGameSettingsState();
}

class _IGameSettingsState extends State<IGameSettings> {
  bool _vibrationsEnabled = false;
  bool _soundsEnabled = false;
  bool _isDarkTheme = false;


  @override
  void initState() {
    super.initState();
    _getSettings();
  }

  Future<void> _getSettings() async {
    final String? hapticsPref = await Mixin.getPrefString(key: GAME_HAPTICS);
    final String? soundPref = await Mixin.getPrefString(key: GAME_SOUND);
    final String? themePref = await Mixin.getPrefString(key: GAME_THEME);

    setState(() {
      _vibrationsEnabled = hapticsPref == 'true';
      _soundsEnabled = soundPref == 'true';
      _isDarkTheme = themePref == 'true';
    });
  }


  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Scaffold(
      backgroundColor: color.xPrimaryColor,
      appBar: IAppBar(
        leading: true,
        title: "Game Settings",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Audio & Haptics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color.xTextColorSecondary
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingCard(
              icon: Icons.vibration,
              title: 'Vibrations',
              subtitle: 'Haptic feedback during gameplay',
              value: _vibrationsEnabled,
              onChanged: (value) {
                setState(() {
                  _vibrationsEnabled = value;
                  Mixin.prefString(pref: _vibrationsEnabled.toString(), key: GAME_HAPTICS);
                });
              },
            ),
            const SizedBox(height: 12),
            _buildSettingCard(
              icon: Icons.volume_up,
              title: 'Sounds',
              subtitle: 'Game sound effects and music',
              value: _soundsEnabled,
              onChanged: (value) {
                setState(() {
                  _soundsEnabled = value;
                  Mixin.prefString(pref: _soundsEnabled.toString(), key: GAME_SOUND);
                });
              },
            ),
            const SizedBox(height: 32),
            Text(
              'Appearance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color.xTextColorSecondary
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingCard(
              icon: _isDarkTheme ? Icons.dark_mode : Icons.light_mode,
              title: 'Theme',
              subtitle: _isDarkTheme ? 'Dark mode enabled' : 'Light mode enabled',
              value: _isDarkTheme,
              onChanged: (value) {
                setState(() {
                  _isDarkTheme = value;
                  Mixin.prefString(pref: _isDarkTheme.toString(), key: GAME_THEME);
                });
              },
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.xSecondaryColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: color.xSecondaryColor,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue[600],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Settings are automatically saved and will apply immediately.',
                      style: TextStyle(
                        color: color.xTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final color = Theme.of(context).extension<CustomColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: color.xSecondaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:  Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.xSecondaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color.xTextColor,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: color.xTextColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: color.xTextColor,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blue[600],
          activeTrackColor: Colors.blue[200],
          inactiveThumbColor:color.xPrimaryColor,
          inactiveTrackColor: color.xSecondaryColor,
          trackOutlineWidth: WidgetStateProperty.all(.1),
        ),
      ),
    );
  }
}
