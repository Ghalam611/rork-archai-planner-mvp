import React, { useState } from 'react';
import { View, Text, ScrollView, TouchableOpacity, StyleSheet } from 'react-native';
import { useTheme } from '@/theme/ThemeContext';
import { useProject } from '@/services/ProjectContext';
import { useLoading } from '@/services/LoadingContext';

export default function RedesignAIScreen({ navigation }: any) {
  const { theme } = useTheme();
  const { generateProject } = useProject();
  const { showLoading, hideLoading } = useLoading();
  const [selectedProject, setSelectedProject] = useState<any>(null);
  const [redesignType, setRedesignType] = useState('modernize');
  const [selectedFeatures, setSelectedFeatures] = useState<string[]>([]);

  const redesignTypes = [
    { name: 'modernize', description: 'Modernize traditional design' },
    { name: 'expand', description: 'Add more space and rooms' },
    { name: 'sustainable', description: 'Add eco-friendly features' },
    { name: 'luxury', description: 'Upgrade to premium materials' },
  ];

  const features = [
    'Open Floor Plan',
    'Smart Home Integration',
    'Energy Efficiency',
    'Modern Kitchen',
    'Luxury Bathrooms',
    'Outdoor Living Space',
    'Home Office',
    'Guest Suite',
    'Storage Solutions',
    'Entertainment Room',
  ];

  const handleProjectSelect = () => {
    // Mock project selection - replace with actual project picker
    Alert.alert(
      'Select Project',
      'Choose a project to redesign from your saved projects.',
      [
        { text: 'Cancel', style: 'cancel' },
        { text: 'Select Project', onPress: () => {
          // Navigate to projects
          navigation.navigate('Projects');
        }}
      ]
    );
  };

  const handleFeatureToggle = (feature: string) => {
    setSelectedFeatures(prev => 
      prev.includes(feature) 
        ? prev.filter(f => f !== feature)
        : [...prev, feature]
    );
  };

  const handleRedesign = async () => {
    if (!selectedProject) {
      Alert.alert('Error', 'Please select a project to redesign');
      return;
    }

    try {
      showLoading('Redesigning with AI...');
      
      await generateProject({
        projectName: `${selectedProject.projectName} - Redesigned`,
        clientName: selectedProject.clientName,
        location: selectedProject.location,
        plotSize: selectedProject.plotSize,
        totalArea: selectedProject.totalArea * 1.2, // 20% expansion
        floors: selectedProject.floors,
        style: selectedProject.style,
        requirements: `Redesign type: ${redesignType}, Features: ${selectedFeatures.join(', ')}`,
      });

      hideLoading();
      
      Alert.alert(
        'Redesign Complete!',
        'AI has redesigned your project with modern enhancements.',
        [
          { text: 'View Project', onPress: () => navigation.navigate('Projects') },
          { text: 'OK', style: 'cancel' }
        ]
      );
    } catch (error) {
      hideLoading();
      Alert.alert('Error', 'Failed to redesign project. Please try again.');
    }
  };

  return (
    <View style={[styles.container, { backgroundColor: theme.colors.background }]}>
      <ScrollView style={styles.scrollView} showsVerticalScrollIndicator={false}>
        {/* Header */}
        <View style={styles.header}>
          <Text style={[styles.title, { color: theme.colors.text }]}>
            AI Redesign
          </Text>
          <Text style={[styles.subtitle, { color: theme.colors.textSecondary }]}>
            Transform your existing architecture with AI
          </Text>
        </View>

        {/* Project Selection */}
        <View style={styles.section}>
          <Text style={[styles.sectionTitle, { color: theme.colors.text }]}>
            Select Project to Redesign
          </Text>
          
          {selectedProject ? (
            <View style={styles.selectedProjectCard}>
              <Text style={[styles.selectedProjectName, { color: theme.colors.text }]}>
                {selectedProject.projectName}
              </Text>
              <Text style={[styles.selectedProjectDetails, { color: theme.colors.textSecondary }]}>
                {selectedProject.location} • {selectedProject.totalArea} m² • {selectedProject.style}
              </Text>
            </View>
          ) : (
            <TouchableOpacity
              style={[styles.selectProjectButton, { backgroundColor: theme.colors.primary }]}
              onPress={handleProjectSelect}
            >
              <Text style={[styles.selectProjectButtonText, { color: theme.colors.text }]}>
                Choose Project
              </Text>
            </TouchableOpacity>
          )}
        </View>

        {/* Redesign Type */}
        <View style={styles.section}>
          <Text style={[styles.sectionTitle, { color: theme.colors.text }]}>
            Redesign Type
          </Text>
          
          <View style={styles.redesignTypes}>
            {redesignTypes.map((type, index) => (
              <TouchableOpacity
                key={type.name}
                style={[
                  styles.redesignType,
                  redesignType === type.name && { backgroundColor: theme.colors.primary }
                ]}
                onPress={() => setRedesignType(type.name)}
              >
                <Text
                  style={[
                    styles.redesignTypeText,
                    { color: redesignType === type.name ? theme.colors.text : theme.colors.textSecondary }
                  ]}
                >
                  {type.name}
                </Text>
                <Text
                  style={[styles.redesignTypeDescription, { color: theme.colors.textSecondary }]}
                >
                  {type.description}
                </Text>
              </TouchableOpacity>
            ))}
          </View>
        </View>

        {/* Features Selection */}
        <View style={styles.section}>
          <Text style={[styles.sectionTitle, { color: theme.colors.text }]}>
            Features to Add
          </Text>
          <Text style={[styles.sectionSubtitle, { color: theme.colors.textSecondary }]}>
            Select features you want to enhance
          </Text>
          
          <View style={styles.featuresGrid}>
            {features.map(renderFeature)}
          </View>
        </View>

        {/* AI Capabilities */}
        <View style={styles.section}>
          <Text style={[styles.sectionTitle, { color: theme.colors.text }]}>
            AI Redesign Capabilities
          </Text>
          
          <View style={styles.capabilitiesList}>
            <View style={styles.capabilityItem}>
              <Text style={[styles.capabilityIcon, { color: theme.colors.primary }]}>🏗️</Text>
              <Text style={[styles.capabilityText, { color: theme.colors.text }]}>
                Structural Analysis
              </Text>
            </View>
            
            <View style={styles.capabilityItem}>
              <Text style={[styles.capabilityIcon, { color: theme.colors.primary }]}>🎨</Text>
              <Text style={[styles.capabilityText, { color: theme.colors.text }]}>
                Style Modernization
              </Text>
            </View>
            
            <View style={styles.capabilityItem}>
              <Text style={[styles.capabilityIcon, { color: theme.colors.primary }]}>⚡</Text>
              <Text style={[styles.capabilityText, { color: theme.colors.text }]}>
                Space Optimization
              </Text>
            </View>
            
            <View style={styles.capabilityItem}>
              <Text style={[styles.capabilityIcon, { color: theme.colors.primary }]}>🌱</Text>
              <Text style={[styles.capabilityText, { color: theme.colors.text }]}>
                Sustainable Materials
              </Text>
            </View>
            
            <View style={styles.capabilityItem}>
              <Text style={[styles.capabilityIcon, { color: theme.colors.primary }]}>🏠️</Text>
              <Text style={[styles.capabilityText, { color: theme.colors.text }]}>
                Cultural Integration
              </Text>
            </View>
          </View>
        </View>

        {/* Generate Button */}
        <TouchableOpacity
          style={[styles.generateButton, { backgroundColor: theme.colors.primary }]}
          onPress={handleRedesign}
          disabled={!selectedProject}
        >
          <Text style={[styles.generateButtonText, { color: theme.colors.text }]}>
            Generate AI Redesign
          </Text>
        </TouchableOpacity>
      </ScrollView>
    </View>
  );
}

const renderFeature = (feature: string) => (
  <TouchableOpacity
    key={feature}
    style={[
      styles.feature,
      selectedFeatures.includes(feature) && { backgroundColor: theme.colors.primary }
    ]}
    onPress={() => handleFeatureToggle(feature)}
  >
    <Text
      style={[
        styles.featureText,
        { color: selectedFeatures.includes(feature) ? theme.colors.text : theme.colors.textSecondary }
      ]}
    >
      {selectedFeatures.includes(feature) ? '✓ ' : ''}
      {feature}
    </Text>
  </TouchableOpacity>
);

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
  selectedProjectCard: {
    backgroundColor: '#2a2a2a',
    borderRadius: 12,
    padding: 16,
    borderWidth: 1,
    borderColor: '#3a3a3a',
  },
  selectedProjectName: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 4,
  },
  selectedProjectDetails: {
    fontSize: 14,
  },
  selectProjectButton: {
    paddingVertical: 16,
    borderRadius: 12,
    alignItems: 'center',
  },
  selectProjectButtonText: {
    fontSize: 16,
    fontWeight: '600',
  },
  redesignTypes: {
    gap: 8,
  },
  redesignType: {
    paddingVertical: 12,
    paddingHorizontal: 16,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: '#3a3a3a',
    backgroundColor: '#2a2a2a',
  },
  redesignTypeText: {
    fontSize: 14,
    fontWeight: '500',
    marginBottom: 4,
  },
  redesignTypeDescription: {
    fontSize: 12,
    color: '#B0B0B0',
  },
  featuresGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 8,
  },
  feature: {
    paddingVertical: 8,
    paddingHorizontal: 12,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: '#3a3a3a',
    backgroundColor: '#2a2a2a',
  },
  featureText: {
    fontSize: 14,
    fontWeight: '500',
  },
  capabilitiesList: {
    gap: 12,
  },
  capabilityItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 8,
  },
  capabilityIcon: {
    fontSize: 20,
    marginRight: 8,
  },
  capabilityText: {
    fontSize: 14,
    flex: 1,
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
