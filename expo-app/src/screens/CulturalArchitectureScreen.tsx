import React, { useState } from 'react';
import { View, Text, ScrollView, TouchableOpacity, StyleSheet } from 'react-native';
import { useTheme } from '@/theme/ThemeContext';
import { useProject } from '@/services/ProjectContext';
import { useLoading } from '@/services/LoadingContext';

export default function CulturalArchitectureScreen({ navigation }: any) {
  const { theme } = useTheme();
  const { generateProject } = useProject();
  const { showLoading, hideLoading } = useLoading();
  const [selectedStyle, setSelectedStyle] = useState('Traditional Najdi');
  const [selectedElements, setSelectedElements] = useState<string[]>([]);

  const culturalStyles = [
    {
      name: 'Traditional Najdi',
      description: 'Authentic desert architecture with thick walls and small windows',
      features: ['Thick walls for insulation', 'Small windows for shade', 'Courtyard design', 'Natural ventilation', 'Local materials'],
      image: '🏜️'
    },
    {
      name: 'Modern Saudi',
      description: 'Contemporary design with traditional Saudi elements',
      features: ['Clean geometric forms', 'Smart home integration', 'Energy efficiency', 'Cultural patterns', 'Modern materials'],
      image: '🏙️'
    },
    {
      name: 'Islamic Architecture',
      description: 'Design following Islamic principles and geometric patterns',
      features: ['Geometric patterns', 'Calligraphy elements', 'Qibla orientation', 'Dome structures', 'Arabesque designs'],
      image: '🕌'
    },
    {
      name: 'Mediterranean',
      description: 'Coastal-inspired design with open, airy spaces',
      features: ['Open floor plans', 'Large windows', 'Courtyard gardens', 'Natural materials', 'Sea-inspired colors'],
      image: '🏖️'
    },
    {
      name: 'Palace Architecture',
      description: 'Grand, formal architecture with luxury elements',
      features: ['Grand entrances', 'Formal gardens', 'Luxury materials', 'Decorative elements', 'Spacious layouts'],
      image: '🏛️'
    },
  ];

  const architecturalElements = [
    { name: 'Mashrabiya', description: 'Traditional wooden screens for privacy and decoration' },
    { name: 'Wind Towers', description: 'Traditional structures for natural cooling and ventilation' },
    { name: 'Courtyards', description: 'Central open spaces for privacy and climate control' },
    { name: 'Arches', description: 'Decorative and structural arches in various styles' },
    { name: 'Domes', description: 'Architectural domes for religious and ceremonial buildings' },
    { name: 'Ornate Doors', description: 'Decorated wooden doors with traditional metalwork' },
    { name: 'Geometric Patterns', description: 'Islamic geometric patterns for decoration' },
    { name: 'Water Features', description: 'Fountains and water channels for cooling' },
    { name: 'Terraces', description: 'Roof terraces for outdoor living and ventilation' },
  ];

  const handleStyleSelect = (style: any) => {
    setSelectedStyle(style.name);
    setSelectedElements([]);
  };

  const toggleElement = (element: string) => {
    setSelectedElements(prev => 
      prev.includes(element) 
        ? prev.filter(e => e !== element)
        : [...prev, element]
    );
  };

  const handleGenerate = async () => {
    try {
      showLoading('Generating cultural architecture design...');
      
      await generateProject({
        projectName: `${selectedStyle} Cultural Architecture`,
        clientName: 'Cultural Heritage Client',
        location: 'Riyadh, Saudi Arabia',
        plotSize: 2500,
        totalArea: 1200,
        floors: 2,
        style: selectedStyle,
        requirements: `Include elements: ${selectedElements.join(', ')}`,
      });

      hideLoading();
      
      navigation.navigate('Projects');
    } catch (error) {
      hideLoading();
      console.error('Error generating cultural design:', error);
    }
  };

  const renderStyleCard = (style: any) => (
    <TouchableOpacity
      key={style.name}
      style={[
        styles.styleCard,
        selectedStyle === style.name && { backgroundColor: theme.colors.primary }
      ]}
      onPress={() => handleStyleSelect(style)}
    >
      <View style={styles.styleCardContent}>
        <Text style={[styles.styleImage, { color: selectedStyle === style.name ? theme.colors.text : theme.colors.textSecondary }]}>
          {style.image}
        </Text>
        <Text style={[styles.styleName, { color: selectedStyle === style.name ? theme.colors.text : theme.colors.text }]}>
          {style.name}
        </Text>
        <Text style={[styles.styleDescription, { color: theme.colors.textSecondary }]}>
          {style.description}
        </Text>
      </View>
    </TouchableOpacity>
  );

  const renderElement = (element: any) => (
    <TouchableOpacity
      key={element.name}
      style={[
        styles.elementCard,
        selectedElements.includes(element.name) && { backgroundColor: theme.colors.primary }
      ]}
      onPress={() => toggleElement(element.name)}
    >
      <View style={styles.elementContent}>
        <Text style={[
          styles.elementCheckbox,
          { color: selectedElements.includes(element.name) ? theme.colors.text : theme.colors.textSecondary }
        ]}>
          {selectedElements.includes(element.name) ? '✓' : ''}
        </Text>
        <Text style={[
          styles.elementName,
          { color: selectedElements.includes(element.name) ? theme.colors.text : theme.colors.text }
        ]}>
          {element.name}
        </Text>
        <Text style={[styles.elementDescription, { color: theme.colors.textSecondary }]}>
          {element.description}
        </Text>
      </View>
    </TouchableOpacity>
  );

  return (
    <View style={[styles.container, { backgroundColor: theme.colors.background }]}>
      <ScrollView style={styles.scrollView} showsVerticalScrollIndicator={false}>
        {/* Header */}
        <View style={styles.header}>
          <Text style={[styles.title, { color: theme.colors.text }]}>
            Cultural Architecture
          </Text>
          <Text style={[styles.subtitle, { color: theme.colors.textSecondary }]}>
            Explore traditional Saudi architectural styles and elements
          </Text>
        </View>

        {/* Style Selection */}
        <View style={styles.section}>
          <Text style={[styles.sectionTitle, { color: theme.colors.text }]}>
            Architectural Styles
          </Text>
          <View style={styles.stylesGrid}>
            {culturalStyles.map(renderStyleCard)}
          </View>
        </View>

        {/* Elements Selection */}
        <View style={styles.section}>
          <Text style={[styles.sectionTitle, { color: theme.colors.text }]}>
            Cultural Elements
          </Text>
          <Text style={[styles.sectionSubtitle, { color: theme.colors.textSecondary }]}>
            Select elements to include in your design
          </Text>
          <View style={styles.elementsGrid}>
            {architecturalElements.map(renderElement)}
          </View>
        </View>

        {/* Generate Button */}
        <TouchableOpacity
          style={[styles.generateButton, { backgroundColor: theme.colors.primary }]}
          onPress={handleGenerate}
        >
          <Text style={[styles.generateButtonText, { color: theme.colors.text }]}>
            Generate Cultural Design
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
  sectionSubtitle: {
    fontSize: 14,
    marginBottom: 16,
  },
  stylesGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 12,
  },
  styleCard: {
    width: '48%',
    backgroundColor: '#2a2a2a',
    borderRadius: 12,
    padding: 16,
    borderWidth: 1,
    borderColor: '#3a3a3a',
    marginBottom: 12,
  },
  styleCardContent: {
    alignItems: 'center',
  },
  styleImage: {
    fontSize: 32,
    marginBottom: 8,
  },
  styleName: {
    fontSize: 16,
    fontWeight: '600',
    marginBottom: 4,
  },
  styleDescription: {
    fontSize: 12,
    textAlign: 'center',
    lineHeight: 16,
  },
  elementsGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 8,
  },
  elementCard: {
    width: '48%',
    backgroundColor: '#2a2a2a',
    borderRadius: 12,
    padding: 12,
    borderWidth: 1,
    borderColor: '#3a3a3a',
    marginBottom: 8,
  },
  elementContent: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  elementCheckbox: {
    width: 20,
    height: 20,
    borderRadius: 4,
    borderWidth: 1,
    borderColor: '#3a3a3a',
    marginRight: 8,
    textAlign: 'center',
    lineHeight: 20,
  },
  elementName: {
    fontSize: 14,
    fontWeight: '500',
    flex: 1,
  },
  elementDescription: {
    fontSize: 11,
    lineHeight: 14,
    flex: 2,
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
