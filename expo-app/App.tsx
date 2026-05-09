import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { StatusBar } from 'expo-status-bar';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { QueryClient, QueryClientProvider } from 'react-query';

import { ThemeProvider } from '@/theme/ThemeContext';
import { AuthProvider } from '@/services/AuthContext';
import { ProjectProvider } from '@/services/ProjectContext';
import { LoadingProvider } from '@/services/LoadingContext';

import TabNavigator from '@/navigation/TabNavigator';
import AuthNavigator from '@/navigation/AuthNavigator';
import { useAuth } from '@/services/AuthContext';

// Create React Query client
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      retry: 3,
      retryDelay: attemptIndex => Math.min(1000 * 2 ** attemptIndex, 30000),
      staleTime: 5 * 60 * 1000, // 5 minutes
    },
  },
});

// Create stack navigator
const Stack = createNativeStackNavigator();

function AppContent() {
  const { user, isLoading } = useAuth();

  if (isLoading) {
    return <LoadingScreen />;
  }

  return (
    <Stack.Navigator screenOptions={{ headerShown: false }}>
      {user ? (
        <Stack.Screen name="Main" component={TabNavigator} />
      ) : (
        <Stack.Screen name="Auth" component={AuthNavigator} />
      )}
    </Stack.Navigator>
  );
}

function LoadingScreen() {
  return (
    <View style={styles.loadingContainer}>
      <ActivityIndicator size="large" color="#D4AF37" />
      <Text style={styles.loadingText}>ArchAI Planner</Text>
    </View>
  );
}

export default function App() {
  return (
    <SafeAreaProvider>
      <QueryClientProvider client={queryClient}>
        <ThemeProvider>
          <LoadingProvider>
            <AuthProvider>
              <ProjectProvider>
                <NavigationContainer>
                  <StatusBar style="light" backgroundColor="#1a1a1a" />
                  <AppContent />
                </NavigationContainer>
              </ProjectProvider>
            </AuthProvider>
          </LoadingProvider>
        </ThemeProvider>
      </QueryClientProvider>
    </SafeAreaProvider>
  );
}

const styles = StyleSheet.create({
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#1a1a1a',
  },
  loadingText: {
    marginTop: 16,
    fontSize: 18,
    fontWeight: 'bold',
    color: '#D4AF37',
  },
});
