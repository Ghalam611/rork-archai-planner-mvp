import React, { useState } from 'react';
import { View, Text, ScrollView, TouchableOpacity, StyleSheet } from 'react-native';
import { useTheme } from '@/theme/ThemeContext';
import { useProject } from '@/services/ProjectContext';
import { useLoading } from '@/services/LoadingContext';

export default function SilentDesignerScreen({ navigation }: any) {
  const { theme } = useTheme();
  const { generateProject } = useProject();
  const { showLoading, hideLoading } = useLoading();
  const [selectedStyle, setSelectedStyle] = useState('Modern Saudi');
  const [selectedRooms, setSelectedRooms] = useState('3');
  const [selectedFeatures, setSelectedFeatures] = useState<string[]>([]);

  const styles = ['Modern Saudi', 'Traditional Najdi', 'Mediterranean', 'Contemporary', 'Islamic', 'Luxury Villa', 'Palace'];
  const roomOptions = ['1', '2', '3', '4', '5', '6'];
  const features = [
    'Open Floor Plan',
    'Smart Home',
    'Traditional Majlis',
    'Courtyard',
    'Solar Panels',
    'Swimming Pool',
    'Home Theater',
    'Prayer Room',
    'Guest Suite',
    'Garage',
    'Garden',
  ];

  const handleStyleSelect = (style: string) => {
    setSelectedStyle(style);
  };

  const handleRoomSelect = (rooms: string) => {
    setSelectedRooms(rooms);
  };

  const toggleFeature = (feature: string) => {
    setSelectedFeatures(prev => 
      prev.includes(feature) 
        ? prev.filter(f => f !== feature)
        : [...prev, feature]
    );
  };

  const handleGenerate = async () => {
    try {
      showLoading('Generating silent design...');
      
      await generateProject({
        projectName: 'Silent Design Project',
        clientName: 'Private Client',
        location: 'Riyadh, Saudi Arabia',
        plotSize: 1500,
        totalArea: 650,
        floors: parseInt(selectedRooms),
        style: selectedStyle,
        requirements: selectedFeatures.join(', '),
      });

      hideLoading();
      
      navigation.navigate('Projects');
    } catch (error) {
      hideLoading();
      console.error('Error generating design:', error);
    }
  };

  const renderStyleOption = (style: string) => (
    <TouchableOpacity
      key={style}
      style={[
        styles.styleOption,
        selectedStyle === style && { backgroundColor: theme.colors.primary }
      ]}
      onPress={() => handleStyleSelect(style)}
    >
      <Text
        style={[
          styles.styleOptionText,
          { color: selectedStyle === style ? theme.colors.text : theme.colors.textSecondary }
        ]}
      >
        {style}
      </Text>
    </TouchableOpacity>
  );

  const renderRoomOption = (rooms: string) => (
    <TouchableOpacity
      key={rooms}
      style={[
        styles.roomOption,
        selectedRooms === rooms && { backgroundColor: theme.colors.primary }
      ]}
      onPress={() => handleRoomSelect(rooms)}
    >
      <Text
        style={[
          styles.roomOptionText,
          { color: selectedRooms === rooms ? theme.colors.text : theme.colors.textSecondary }
        ]}
      >
        {rooms} {rooms === '1' ? 'Room' : 'Rooms'}
      </Text>
    </TouchableOpacity>
  );

  const renderFeature = (feature: string) => (
    <TouchableOpacity
      key={feature}
      style={[
        styles.featureOption,
        selectedFeatures.includes(feature) && { backgroundColor: theme.colors.primary }
      ]}
      onPress={() => toggleFeature(feature)}
    >
      <View style={styles.featureContent}>
        <Text
          style={[
            styles.featureOptionText,
            { color: selectedFeatures.includes(feature) ? theme.colors.text : theme.colors.textSecondary }
          ]}
        >
          {feature}
        </Text>
        {selectedFeatures.includes(feature) && (
          <Text style={[styles.featureCheck, { color: theme.colors.text }]}>
            ✓
          </Text>
        )}
      </View>
    </TouchableOpacity>
  );

  return (
    <View style={[styles.container, { backgroundColor: theme.colors.background }]}>
      <ScrollView style={styles.scrollView} showsVerticalScrollIndicator={false}>
        {/* Header */}
        <View style={styles.header}>
          <Text style={[styles.title, { color: theme.colors.text }]}>
            Silent Designer
          </Text>
          <Text style={[styles.subtitle, { color: theme.colors.textSecondary }]}>
            Create architecture design without detailed input
          </Text>
        </View>

        {/* Style Selection */}
        <View style={styles.section}>
          <Text style={[styles.sectionTitle, { color: theme.colors.text }]}>
            Architecture Style
          </Text>
          <View style={styles.optionsGrid}>
            {styles.map(renderStyleOption)}
          </View>
        </View>

        {/* Rooms Selection */}
        <View style={styles.section}>
          <Text style={[styles.sectionTitle, { color: theme.colors.text }]}>
            Number of Rooms
          </Text>
          <View style={styles.optionsGrid}>
            {roomOptions.map(renderRoomOption)}
          </View>
        </View>

        {/* Features Selection */}
        <View style={styles.section}>
          <Text style={[styles.sectionTitle, { color: theme.colors.text }]}>
            Special Features
          </Text>
          <View style={styles.featuresGrid}>
            {features.map(renderFeature)}
          </View>
        </View>

        {/* Generate Button */}
        <TouchableOpacity
          style={[styles.generateButton, { backgroundColor: theme.colors.primary }]}
          onPress={handleGenerate}
        >
          <Text style={[styles.generateButtonText, { color: theme.colors.text }]}>
            Generate Silent Design
          </Text>
        </TouchableOpacity>
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
  section: {
    marginBottom: 32,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '600',
    marginBottom: 16,
  },
  optionsGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 8,
  },
  styleOption: {
    paddingVertical: 12,
    paddingHorizontal: 16,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: '#3a3a3a',
    backgroundColor: '#2a2a2a',
    minWidth: 100,
  },
  styleOptionText: {
    fontSize: 14,
    fontWeight: '500',
  },
  roomOption: {
    paddingVertical: 12,
    paddingHorizontal: 16,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: '#3a3a3a',
    backgroundColor: '#2a2a2a',
    minWidth: 80,
  },
  roomOptionText: {
    fontSize: 14,
    fontWeight: '500',
  },
  featuresGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 8,
  },
  featureOption: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 8,
    paddingHorizontal: 12,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: '#3a3a3a',
    backgroundColor: '#2a2a2a',
  },
  featureContent: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  featureOptionText: {
    fontSize: 14,
    fontWeight: '500',
  },
  featureCheck: {
    fontSize: 16,
    fontWeight: 'bold',
  },
  generateButton: {
    paddingVertical: 16,
    borderRadius: 12,
    alignItems: 'center',
    marginTop: 24,
  },
  generateButtonText: {
    fontSize: 16,
    fontWeight: '600',
  },
});
