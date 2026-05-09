import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet, Alert } from 'react-native';
import { useTheme } from '@/theme/ThemeContext';
import { useAuth } from '@/services/AuthContext';
import { useLoading } from '@/services/LoadingContext';

export default function LoginScreen({ navigation }: any) {
  const { theme } = useTheme();
  const { login } = useAuth();
  const { showLoading, hideLoading } = useLoading();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);

  const handleLogin = async () => {
    if (!email.trim() || !password.trim()) {
      Alert.alert('Error', 'Please enter both email and password');
      return;
    }

    try {
      showLoading('Signing in...');
      await login(email.trim(), password.trim());
      hideLoading();
      
      // Navigation will be handled by AuthProvider
      Alert.alert('Success!', 'Welcome back to ArchAI Planner!');
    } catch (error) {
      hideLoading();
      Alert.alert('Error', 'Failed to login. Please try again.');
    }
  };

  const handleRegister = () => {
    navigation.navigate('Register');
  };

  return (
    <View style={[styles.container, { backgroundColor: theme.colors.background }]}>
      <View style={styles.content}>
        {/* Header */}
        <View style={styles.header}>
          <Text style={[styles.title, { color: theme.colors.text }]}>
            Welcome Back
          </Text>
          <Text style={[styles.subtitle, { color: theme.colors.textSecondary }]}>
            Sign in to continue your architectural journey
          </Text>
        </View>

        {/* Logo */}
        <View style={styles.logo}>
          <Text style={[styles.logoText, { color: theme.colors.primary }]}>
            🏗️
          </Text>
          <Text style={[styles.logoText, { color: theme.colors.text }]}>
            ArchAI
          </Text>
          <Text style={[styles.logoText, { color: theme.colors.primary }]}>
            Planner
          </Text>
        </View>

        {/* Form */}
        <View style={styles.form}>
          <Text style={[styles.inputLabel, { color: theme.colors.text }]}>
            Email
          </Text>
          <TextInput
            style={[styles.input, { color: theme.colors.text, borderColor: theme.colors.border }]}
            placeholder="Enter your email"
            placeholderTextColor={theme.colors.textSecondary}
            value={email}
            onChangeText={setEmail}
            keyboardType="email-address"
            autoCapitalize="none"
          />

          <Text style={[styles.inputLabel, { color: theme.colors.text }]}>
            Password
          </Text>
          <View style={styles.passwordContainer}>
            <TextInput
              style={[styles.input, { color: theme.colors.text, borderColor: theme.colors.border }]}
              placeholder="Enter your password"
              placeholderTextColor={theme.colors.textSecondary}
              value={password}
              onChangeText={setPassword}
              secureTextEntry={!showPassword}
            />
            <TouchableOpacity
              style={styles.showPasswordButton}
              onPress={() => setShowPassword(!showPassword)}
            >
              <Text style={[styles.showPasswordText, { color: theme.colors.textSecondary }]}>
                {showPassword ? 'Hide' : 'Show'}
              </Text>
            </TouchableOpacity>
          </View>

          <TouchableOpacity
            style={[styles.loginButton, { backgroundColor: theme.colors.primary }]}
            onPress={handleLogin}
          >
            <Text style={[styles.loginButtonText, { color: theme.colors.text }]}>
              Sign In
            </Text>
          </TouchableOpacity>
        </View>

        {/* Register Link */}
        <View style={styles.registerContainer}>
          <Text style={[styles.registerText, { color: theme.colors.textSecondary }]}>
            Don't have an account?
          </Text>
          <TouchableOpacity onPress={handleRegister}>
            <Text style={[styles.registerLink, { color: theme.colors.primary }]}>
              Register Here
            </Text>
          </TouchableOpacity>
        </View>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  content: {
    flex: 1,
    justifyContent: 'center',
    paddingHorizontal: 24,
  },
  header: {
    alignItems: 'center',
    marginBottom: 32,
  },
  title: {
    fontSize: 32,
    fontWeight: 'bold',
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 16,
    textAlign: 'center',
  },
  logo: {
    alignItems: 'center',
    marginBottom: 32,
  },
  logoText: {
    fontSize: 24,
    fontWeight: 'bold',
  },
  form: {
    width: '100%',
    maxWidth: 300,
  },
  inputLabel: {
    fontSize: 14,
    fontWeight: '500',
    marginBottom: 8,
  },
  input: {
    borderWidth: 1,
    borderRadius: 8,
    padding: 16,
    fontSize: 16,
    backgroundColor: '#2a2a2a',
    marginBottom: 16,
  },
  passwordContainer: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  showPasswordButton: {
    position: 'absolute',
    right: 16,
  },
  showPasswordText: {
    fontSize: 12,
    color: '#B0B0B0',
  },
  loginButton: {
    paddingVertical: 16,
    borderRadius: 8,
    alignItems: 'center',
    marginTop: 24,
  },
  loginButtonText: {
    fontSize: 16,
    fontWeight: '600',
  },
  registerContainer: {
    flexDirection: 'row',
    justifyContent: 'center',
    marginTop: 24,
  },
  registerText: {
    fontSize: 14,
  },
  registerLink: {
    fontSize: 14,
    fontWeight: '600',
  },
});
