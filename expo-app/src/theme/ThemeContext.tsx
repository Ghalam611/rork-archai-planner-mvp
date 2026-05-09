import React, { createContext, useContext, useState, ReactNode } from 'react';
import { StyleSheet } from 'react-native';

// Theme types
export interface Theme {
  colors: {
    background: string;
    surface: string;
    primary: string;
    secondary: string;
    accent: string;
    text: string;
    textSecondary: string;
    border: string;
    success: string;
    warning: string;
    error: string;
    gold: string;
    saudiGold: string;
    antiqueGold: string;
    richMaroon: string;
    accentEmerald: string;
    accentAmber: string;
    accentCopper: string;
    accentSapphire: string;
  };
  spacing: {
    xs: number;
    sm: number;
    md: number;
    lg: number;
    xl: number;
    xxl: number;
  };
  borderRadius: {
    small: number;
    medium: number;
    large: number;
    xlarge: number;
  };
  typography: {
    h1: {
      fontSize: number;
      fontWeight: string;
    };
    h2: {
      fontSize: number;
      fontWeight: string;
    };
    h3: {
      fontSize: number;
      fontWeight: string;
    };
    body: {
      fontSize: number;
      fontWeight: string;
    };
    caption: {
      fontSize: number;
      fontWeight: string;
    };
  };
}

// Saudi-inspired theme
const saudiTheme: Theme = {
  colors: {
    background: '#1a1a1a',
    surface: '#2a2a2a',
    primary: '#D4AF37',
    secondary: '#8B7355',
    accent: '#FF6B35',
    text: '#FFFFFF',
    textSecondary: '#B0B0B0',
    border: '#3a3a3a',
    success: '#10B981',
    warning: '#F59E0B',
    error: '#EF4444',
    gold: '#D4AF37',
    saudiGold: '#FFD700',
    antiqueGold: '#B8860B',
    richMaroon: '#8B0000',
    accentEmerald: '#10B981',
    accentAmber: '#F59E0B',
    accentCopper: '#B87333',
    accentSapphire: '#0F4C75',
  },
  spacing: {
    xs: 4,
    sm: 8,
    md: 16,
    lg: 24,
    xl: 32,
    xxl: 48,
  },
  borderRadius: {
    small: 8,
    medium: 12,
    large: 16,
    xlarge: 24,
  },
  typography: {
    h1: {
      fontSize: 32,
      fontWeight: 'bold',
    },
    h2: {
      fontSize: 24,
      fontWeight: 'bold',
    },
    h3: {
      fontSize: 20,
      fontWeight: '600',
    },
    body: {
      fontSize: 16,
      fontWeight: 'normal',
    },
    caption: {
      fontSize: 14,
      fontWeight: 'normal',
    },
  },
};

// Create theme context
interface ThemeContextType {
  theme: Theme;
  isDark: boolean;
  toggleTheme: () => void;
}

const ThemeContext = createContext<ThemeContextType | undefined>(undefined);

// Theme provider component
export function ThemeProvider({ children }: { children: ReactNode }) {
  const [isDark, setIsDark] = useState(true);

  const toggleTheme = () => {
    setIsDark(!isDark);
  };

  const value = {
    theme: saudiTheme,
    isDark,
    toggleTheme,
  };

  return (
    <ThemeContext.Provider value={value}>
      {children}
    </ThemeContext.Provider>
  );
}

// Hook to use theme
export function useTheme() {
  const context = useContext(ThemeContext);
  if (context === undefined) {
    throw new Error('useTheme must be used within a ThemeProvider');
  }
  return context;
}

// Create styles helper
export function createStyles<T extends Record<string, any>>(styles: T) {
  return StyleSheet.create(styles);
}

export { saudiTheme };
