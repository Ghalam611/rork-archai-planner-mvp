import React from 'react';
import { createStackNavigator } from '@react-navigation/stack';
import { useTheme } from '@/theme/ThemeContext';
import { useAuth } from '@/services/AuthContext';

import LoginScreen from '@/screens/LoginScreen';
import RegisterScreen from '@/screens/RegisterScreen';

const Stack = createStackNavigator();

export default function AuthNavigator() {
  const { theme } = useTheme();
  const { user } = useAuth();

  return (
    <Stack.Navigator screenOptions={{ headerShown: false }}>
      <Stack.Screen 
        name="Login" 
        component={LoginScreen}
        options={{
          title: 'Login',
          headerStyle: {
            backgroundColor: theme.colors.surface,
          },
          headerTintColor: theme.colors.text,
        }}
      />
      <Stack.Screen 
        name="Register" 
        component={RegisterScreen}
        options={{
          title: 'Register',
          headerStyle: {
            backgroundColor: theme.colors.surface,
          },
          headerTintColor: theme.colors.text,
        }}
      />
    </Stack.Navigator>
  );
}
