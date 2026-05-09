import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet, Alert } from 'react-native';
import { useTheme } from '@/theme/ThemeContext';
import { useAuth } from '@/services/AuthContext';
import { useLoading } from '@/services/LoadingContext';

export default function RegisterScreen({ navigation }: any) {
  const { theme } = useTheme();
  const { register } = useAuth();
  const { showLoading, hideLoading } = useLoading();
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    password: '',
    confirmPassword: '',
  });

  const handleInputChange = (field: string, value: string) => {
    setFormData(prev => ({ ...prev, [field]: value }));
  };

  const validateForm = () => {
    if (!formData.name.trim()) {
      Alert.alert('Error', 'Name is required');
      return false;
    }
    if (!formData.email.trim()) {
      Alert.alert('Error', 'Email is required');
      return false;
    }
    if (!formData.password.trim()) {
      Alert.alert('Error', 'Password is required');
      return false;
    }
    if (formData.password.length < 6) {
      Alert.alert('Error', 'Password must be at least 6 characters');
      return false;
    }
    if (formData.password !== formData.confirmPassword) {
      Alert.alert('Error', 'Passwords do not match');
      return false;
    }
    return true;
  };

  const handleRegister = async () => {
    if (!validateForm()) return;

    try {
      showLoading('Creating account...');
      await register(formData.name.trim(), formData.email.trim(), formData.password.trim());
      hideLoading();
      
      Alert.alert(
        'Success!',
        'Account created successfully! Please login.',
        [
          { text: 'OK', onPress: () => navigation.navigate('Login') }
        ]
      );
    } catch (error) {
      hideLoading();
      Alert.alert('Error', 'Failed to create account. Please try again.');
    }
  };

  const handleLogin = () => {
    navigation.navigate('Login');
  };

  return (
    <View style={[styles.container, { backgroundColor: theme.colors.background }]}>
      {/* Header */}
      <View style={styles.header}>
        <Text style={[styles.title, { color: theme.colors.text }]}>
          Create Account
        </Text>
        <Text style={[styles.subtitle, { color: theme.colors.textSecondary }]}>
          Join ArchAI Planner to start creating
        </Text>
      </View>

      {/* Form */}
      <View style={styles.form}>
        <Text style={[styles.inputLabel, { color: theme.colors.text }]}>
          Full Name
        </Text>
        <TextInput
          style={[styles.input, { color: theme.colors.text, borderColor: theme.colors.border }]}
          placeholder="Enter your full name"
          placeholderTextColor={theme.colors.textSecondary}
          value={formData.name}
          onChangeText={(value) => handleInputChange('name', value)}
        />

        <Text style={[styles.inputLabel, { color: theme.colors.text }]}>
          Email Address
        </Text>
        <TextInput
          style={[styles.input, { color: theme.colors.text, borderColor: theme.colors.border }]}
          placeholder="Enter your email"
          placeholderTextColor={theme.colors.textSecondary}
          value={formData.email}
          onChangeText={(value) => handleInputChange('email', value)}
          keyboardType="email-address"
          autoCapitalize="none"
        />

        <Text style={[styles.inputLabel, { color: theme.colors.text }]}>
          Password
        </Text>
        <View style={styles.passwordContainer}>
          <TextInput
            style={[styles.input, { color: theme.colors.text, borderColor: theme.colors.border }]}
            placeholder="Create a strong password"
            placeholderTextColor={theme.colors.textSecondary}
            value={formData.password}
            onChangeText={(value) => handleInputChange('password', value)}
            secureTextEntry
          />
          <TouchableOpacity
            style={styles.showPasswordButton}
            onPress={() => {
              // Toggle password visibility
            }}
          >
            <Text style={[styles.showPasswordText, { color: theme.colors.textSecondary }]}>
              👁
            </Text>
          </TouchableOpacity>
        </View>

        <Text style={[styles.inputLabel, { color: theme.colors.text }]}>
          Confirm Password
        </Text>
        <View style={styles.passwordContainer}>
          <TextInput
            style={[styles.input, { color: theme.colors.text, borderColor: theme.colors.border }]}
            placeholder="Confirm your password"
            placeholderTextColor={theme.colors.textSecondary}
            value={formData.confirmPassword}
            onChangeText={(value) => handleInputChange('confirmPassword', value)}
            secureTextEntry
          />
          <TouchableOpacity
            style={styles.showPasswordButton}
            onPress={() => {
              // Toggle password visibility
            }}
          >
            <Text style={[styles.showPasswordText, { color: theme.colors.textSecondary }]}>
              👁
            </Text>
          </TouchableOpacity>
        </View>
      </View>

      {/* Register Button */}
      <TouchableOpacity
        style={[styles.registerButton, { backgroundColor: theme.colors.primary }]}
        onPress={handleRegister}
      >
        <Text style={[styles.registerButtonText, { color: theme.colors.text }]}>
          Create Account
        </Text>
      </TouchableOpacity>

      {/* Login Link */}
      <View style={styles.loginContainer}>
        <Text style={[styles.loginText, { color: theme.colors.textSecondary }]}>
          Already have an account?
        </Text>
        <TouchableOpacity onPress={handleLogin}>
          <Text style={[styles.loginLink, { color: theme.colors.primary }]}>
            Sign In
          </Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  header: {
    padding: 24,
    paddingBottom: 16,
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 16,
    marginBottom: 24,
  },
  form: {
    paddingHorizontal: 24,
  },
  inputLabel: {
    fontSize: 14,
    fontWeight: '500',
    marginBottom: 8,
  },
  input: {
    borderWidth: 1,
    borderRadius: 8,
    padding: 12,
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
    fontSize: 16,
  },
  registerButton: {
    paddingVertical: 16,
    borderRadius: 8,
    alignItems: 'center',
    marginTop: 24,
  },
  registerButtonText: {
    fontSize: 16,
    fontWeight: '600',
  },
  loginContainer: {
    flexDirection: 'row',
    justifyContent: 'center',
    marginTop: 24,
  },
  loginText: {
    fontSize: 14,
  },
  loginLink: {
    fontSize: 14,
    fontWeight: '600',
  },
});
