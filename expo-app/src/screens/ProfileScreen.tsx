import React from 'react';
import { View, Text, ScrollView, TouchableOpacity, StyleSheet, Switch } from 'react-native';
import { useTheme } from '@/theme/ThemeContext';
import { useAuth } from '@/services/AuthContext';

export default function ProfileScreen({ navigation }: any) {
  const { theme } = useTheme();
  const { user, logout } = useAuth();
  const [notifications, setNotifications] = React.useState(true);
  const [darkMode, setDarkMode] = React.useState(true);

  const handleLogout = () => {
    logout();
    navigation.reset({
      index: 0,
      routes: [{ name: 'Auth' }],
    });
  };

  const handleSettings = (setting: string) => {
    console.log('Navigate to settings:', setting);
  };

  const menuItems = [
    { icon: 'person', title: 'Edit Profile', onPress: () => handleSettings('profile') },
    { icon: 'settings', title: 'App Settings', onPress: () => handleSettings('app') },
    { icon: 'notifications', title: 'Notifications', onPress: () => handleSettings('notifications') },
    { icon: 'shield-checkmark', title: 'Privacy & Security', onPress: () => handleSettings('privacy') },
    { icon: 'help-circle', title: 'Help & Support', onPress: () => handleSettings('help') },
    { icon: 'information-circle', title: 'About', onPress: () => handleSettings('about') },
  ];

  const renderMenuItem = (item: any, index: number) => (
    <TouchableOpacity key={index} style={styles.menuItem} onPress={item.onPress}>
      <View style={styles.menuItemContent}>
        <Text style={[styles.menuIcon, { color: theme.colors.primary }]}>
          {item.icon}
        </Text>
        <Text style={[styles.menuText, { color: theme.colors.text }]}>
          {item.title}
        </Text>
      </View>
      <Text style={[styles.menuArrow, { color: theme.colors.textSecondary }]}>
        {'>'}
      </Text>
    </TouchableOpacity>
  );

  return (
    <View style={[styles.container, { backgroundColor: theme.colors.background }]}>
      <ScrollView style={styles.scrollView} showsVerticalScrollIndicator={false}>
        {/* Header */}
        <View style={styles.header}>
          <View style={styles.profileHeader}>
            <View style={styles.avatar}>
              <Text style={[styles.avatarText, { color: theme.colors.primary }]}>
                {user?.name?.charAt(0)?.toUpperCase() || 'U'}
              </Text>
            </View>
            <View style={styles.profileInfo}>
              <Text style={[styles.profileName, { color: theme.colors.text }]}>
                {user?.name || 'Guest User'}
              </Text>
              <Text style={[styles.profileEmail, { color: theme.colors.textSecondary }]}>
                {user?.email || 'guest@archaiplanner.com'}
              </Text>
            </View>
          </View>
        </View>

        {/* Settings Section */}
        <View style={styles.section}>
          <Text style={[styles.sectionTitle, { color: theme.colors.text }]}>
            Preferences
          </Text>
          
          <View style={styles.settingItem}>
            <Text style={[styles.settingLabel, { color: theme.colors.text }]}>
              Push Notifications
            </Text>
            <Switch
              value={notifications}
              onValueChange={setNotifications}
              trackColor={theme.colors.primary}
              thumbColor={theme.colors.text}
            />
          </View>
          
          <View style={styles.settingItem}>
            <Text style={[styles.settingLabel, { color: theme.colors.text }]}>
              Dark Mode
            </Text>
            <Switch
              value={darkMode}
              onValueChange={setDarkMode}
              trackColor={theme.colors.primary}
              thumbColor={theme.colors.text}
            />
          </View>
        </View>

        {/* Menu Items */}
        <View style={styles.section}>
          <Text style={[styles.sectionTitle, { color: theme.colors.text }]}>
            Account & Support
          </Text>
          
          {menuItems.map(renderMenuItem)}
        </View>

        {/* App Info */}
        <View style={styles.section}>
          <Text style={[styles.sectionTitle, { color: theme.colors.text }]}>
            About ArchAI Planner
          </Text>
          
          <View style={styles.appInfo}>
            <View style={styles.infoRow}>
              <Text style={[styles.infoLabel, { color: theme.colors.textSecondary }]}>
                Version
              </Text>
              <Text style={[styles.infoValue, { color: theme.colors.text }]}>
                1.0.0
              </Text>
            </View>
            
            <View style={styles.infoRow}>
              <Text style={[styles.infoLabel, { color: theme.colors.textSecondary }]}>
                Build
              </Text>
              <Text style={[styles.infoValue, { color: theme.colors.text }]}>
                Expo React Native
              </Text>
            </View>
            
            <View style={styles.infoRow}>
              <Text style={[styles.infoLabel, { color: theme.colors.textSecondary }]}>
                Platform
              </Text>
              <Text style={[styles.infoValue, { color: theme.colors.text }]}>
                iOS & Android
              </Text>
            </View>
          </View>
        </View>

        {/* Logout Button */}
        <View style={styles.section}>
          <TouchableOpacity
            style={[styles.logoutButton, { backgroundColor: theme.colors.surface, borderColor: theme.colors.error }]}
            onPress={handleLogout}
          >
            <Text style={[styles.logoutButtonText, { color: theme.colors.error }]}>
              Sign Out
            </Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  scrollView: {
    flex: 1,
  },
  header: {
    padding: 24,
    borderBottomWidth: 1,
    borderBottomColor: '#3a3a3a',
  },
  profileHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 24,
  },
  avatar: {
    width: 80,
    height: 80,
    borderRadius: 40,
    backgroundColor: '#D4AF37',
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 16,
  },
  avatarText: {
    fontSize: 32,
    fontWeight: 'bold',
  },
  profileInfo: {
    flex: 1,
  },
  profileName: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 4,
  },
  profileEmail: {
    fontSize: 14,
  },
  section: {
    marginBottom: 32,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '600',
    marginBottom: 16,
    paddingHorizontal: 24,
  },
  settingItem: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 24,
    paddingVertical: 12,
    borderBottomWidth: 1,
    borderBottomColor: '#3a3a3a',
  },
  settingLabel: {
    fontSize: 16,
  },
  menuItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 24,
    paddingVertical: 16,
    borderBottomWidth: 1,
    borderBottomColor: '#3a3a3a',
  },
  menuItemContent: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
  },
  menuIcon: {
    fontSize: 20,
    marginRight: 12,
  },
  menuText: {
    fontSize: 16,
    flex: 1,
  },
  menuArrow: {
    fontSize: 16,
  },
  appInfo: {
    paddingHorizontal: 24,
  },
  infoRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingVertical: 8,
  },
  infoLabel: {
    fontSize: 14,
    flex: 1,
  },
  infoValue: {
    fontSize: 14,
    fontWeight: '500',
  },
  logoutButton: {
    marginHorizontal: 24,
    paddingVertical: 16,
    borderRadius: 8,
    borderWidth: 1,
    alignItems: 'center',
  },
  logoutButtonText: {
    fontSize: 16,
    fontWeight: '600',
  },
});
