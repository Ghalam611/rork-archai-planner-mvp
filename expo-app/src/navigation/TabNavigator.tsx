import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { createStackNavigator } from '@react-navigation/stack';
import { useTheme } from '@/theme/ThemeContext';

import HomeScreen from '@/screens/HomeScreen';
import CreateScreen from '@/screens/CreateScreen';
import ChatScreen from '@/screens/ChatScreen';
import ProjectsScreen from '@/screens/ProjectsScreen';
import ProfileScreen from '@/screens/ProfileScreen';
import SilentDesignerScreen from '@/screens/SilentDesignerScreen';
import EmptyLandVisionScreen from '@/screens/EmptyLandVisionScreen';
import CulturalArchitectureScreen from '@/screens/CulturalArchitectureScreen';
import RedesignAIScreen from '@/screens/RedesignAIScreen';

const Tab = createBottomTabNavigator();
const Stack = createStackNavigator();

function HomeStack() {
  return (
    <Stack.Navigator screenOptions={{ headerShown: false }}>
      <Stack.Screen name="Home" component={HomeScreen} />
      <Stack.Screen name="Create" component={CreateScreen} />
      <Stack.Screen name="SilentDesigner" component={SilentDesignerScreen} />
      <Stack.Screen name="EmptyLandVision" component={EmptyLandVisionScreen} />
      <Stack.Screen name="CulturalArchitecture" component={CulturalArchitectureScreen} />
      <Stack.Screen name="RedesignAI" component={RedesignAIScreen} />
    </Stack.Navigator>
  );
}

export default function TabNavigator() {
  const { theme } = useTheme();

  return (
    <Tab.Navigator
      screenOptions={({ route }) => ({
        tabBarIcon: ({ focused, color, size }) => {
          let iconName;
          
          switch (route.name) {
            case 'Home':
              iconName = 'home';
              break;
            case 'Create':
              iconName = 'add-circle';
              break;
            case 'Chat':
              iconName = 'chatbubble-ellipses';
              break;
            case 'Projects':
              iconName = 'folder';
              break;
            case 'Profile':
              iconName = 'person';
              break;
            default:
              iconName = 'help';
          }
          
          return <Ionicons name={iconName} size={size} color={color} />;
        },
        tabBarActiveTintColor: theme.colors.primary,
        tabBarInactiveTintColor: theme.colors.textSecondary,
        tabBarStyle: {
          backgroundColor: theme.colors.surface,
          borderTopColor: theme.colors.border,
          height: 60,
        },
        headerStyle: {
          backgroundColor: theme.colors.surface,
          borderBottomColor: theme.colors.border,
        },
        headerTintColor: theme.colors.text,
      })}
    >
      <Tab.Screen 
        name="Home" 
        component={HomeStack}
        options={{
          tabBarLabel: 'Home',
        }}
      />
      <Tab.Screen 
        name="Create" 
        component={CreateScreen}
        options={{
          tabBarLabel: 'Create',
        }}
      />
      <Tab.Screen 
        name="Chat" 
        component={ChatScreen}
        options={{
          tabBarLabel: 'AI Chat',
        }}
      />
      <Tab.Screen 
        name="Projects" 
        component={ProjectsScreen}
        options={{
          tabBarLabel: 'Projects',
        }}
      />
      <Tab.Screen 
        name="Profile" 
        component={ProfileScreen}
        options={{
          tabBarLabel: 'Profile',
        }}
      />
    </Tab.Navigator>
  );
}
