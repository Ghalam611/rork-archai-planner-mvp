import React, { useState } from 'react';
import { View, Text, ScrollView, TouchableOpacity, StyleSheet, Image } from 'react-native';
import { useTheme } from '@/theme/ThemeContext';
import { useLoading } from '@/services/LoadingContext';

export default function EmptyLandVisionScreen({ navigation }: any) {
  const { theme } = useTheme();
  const { showLoading, hideLoading } = useLoading();
  const [selectedImage, setSelectedImage] = useState<string | null>(null);
  const [isAnalyzing, setIsAnalyzing] = useState(false);

  const handleImageSelect = () => {
    // Mock image picker - replace with actual implementation
    Alert.alert(
      'Select Image',
      'Choose how to add land image:',
      [
        { text: 'Camera', onPress: () => handleCamera() },
        { text: 'Gallery', onPress: () => handleGallery() },
        { text: 'Cancel', style: 'cancel' }
      ]
    );
  };

  const handleCamera = () => {
    console.log('Open camera for land vision');
    // Mock camera functionality
    setSelectedImage('mock-camera-image');
  };

  const handleGallery = () => {
    console.log('Open gallery for land vision');
    // Mock gallery functionality
    setSelectedImage('mock-gallery-image');
  };

  const handleAnalyze = async () => {
    if (!selectedImage) {
      Alert.alert('Error', 'Please select an image first');
      return;
    }

    setIsAnalyzing(true);
    showLoading('Analyzing land for architecture...');

    try {
      // Mock AI analysis - replace with real API call
      await new Promise(resolve => setTimeout(resolve, 3000));
      
      hideLoading();
      
      Alert.alert(
        'Analysis Complete!',
        'AI has analyzed your land and generated architecture suggestions.',
        [
          { text: 'View Suggestions', onPress: () => navigation.navigate('Create') },
          { text: 'OK', style: 'cancel' }
        ]
      );
    } catch (error) {
      hideLoading();
      Alert.alert('Error', 'Failed to analyze land. Please try again.');
    } finally {
      setIsAnalyzing(false);
    }
  };

  const renderImagePlaceholder = () => (
    <TouchableOpacity style={styles.imagePlaceholder} onPress={handleImageSelect}>
      <View style={styles.placeholderContent}>
        <Text style={[styles.placeholderText, { color: theme.colors.textSecondary }]}>
          {selectedImage ? 'Change Image' : 'Tap to select land image'}
        </Text>
        {selectedImage ? (
          <View style={styles.selectedImage}>
            <Text style={[styles.imageText, { color: theme.colors.primary }]}>
              ✓ Selected
            </Text>
          </View>
        ) : (
          <Text style={[styles.iconText, { color: theme.colors.primary }]}>
            📷
          </Text>
        )}
      </View>
    </TouchableOpacity>
  );

  const renderAnalysisFeature = (icon: string, title: string, description: string) => (
    <View style={styles.featureCard}>
      <View style={styles.featureHeader}>
        <Text style={[styles.featureIcon, { color: theme.colors.primary }]}>
          {icon}
        </Text>
        <Text style={[styles.featureTitle, { color: theme.colors.text }]}>
          {title}
        </Text>
      </View>
      <Text style={[styles.featureDescription, { color: theme.colors.textSecondary }]}>
        {description}
      </Text>
    </View>
  );

  return (
    <View style={[styles.container, { backgroundColor: theme.colors.background }]}>
      <ScrollView style={styles.scrollView} showsVerticalScrollIndicator={false}>
        {/* Header */}
        <View style={styles.header}>
          <Text style={[styles.title, { color: theme.colors.text }]}>
            Empty Land Vision
          </Text>
          <Text style={[styles.subtitle, { color: theme.colors.textSecondary }]}>
            AI-powered land analysis for architecture design
          </Text>
        </View>

        {/* Image Selection */}
        <View style={styles.section}>
          <Text style={[styles.sectionTitle, { color: theme.colors.text }]}>
            Land Image
          </Text>
          {renderImagePlaceholder()}
        </View>

        {/* AI Analysis Features */}
        <View style={styles.section}>
          <Text style={[styles.sectionTitle, { color: theme.colors.text }]}>
            AI Analysis Capabilities
          </Text>
          
          {renderAnalysisFeature(
            '🏗️',
            'Topography Analysis',
            'AI analyzes terrain elevation, slopes, and natural features for optimal building placement and foundation design.'
          )}
          
          {renderAnalysisFeature(
            '🌡️',
            'Climate Assessment',
            'Evaluates sun exposure, wind patterns, and temperature variations for energy-efficient design orientation.'
          )}
          
          {renderAnalysisFeature(
            '🌱',
            'Soil Analysis',
            'Identifies soil composition and bearing capacity for appropriate foundation engineering recommendations.'
          )}
          
          {renderAnalysisFeature(
            '🏛️',
            'Building Constraints',
            'Detects legal boundaries, easements, and zoning restrictions for development planning.'
          )}
          
          {renderAnalysisFeature(
            '🌳',
            'Vegetation Mapping',
            'Analyzes existing trees and vegetation for landscape integration and preservation planning.'
          )}
          
          {renderAnalysisFeature(
            '📐',
            'Optimal Layout',
            'Suggests ideal building placement, access points, and circulation patterns based on land characteristics.'
          )}
        </View>

        {/* Analysis Button */}
        <TouchableOpacity
          style={[
            styles.analyzeButton,
            { backgroundColor: selectedImage && !isAnalyzing ? theme.colors.primary : theme.colors.surface }
          ]}
          onPress={handleAnalyze}
          disabled={!selectedImage || isAnalyzing}
        >
          <Text
            style={[
              styles.analyzeButtonText,
              { color: selectedImage && !isAnalyzing ? theme.colors.text : theme.colors.textSecondary }
            ]}
          >
            {isAnalyzing ? 'Analyzing...' : 'Analyze Land'}
          </Text>
        </TouchableOpacity>
      </View>

        {/* Benefits */}
        <View style={styles.section}>
          <Text style={[styles.sectionTitle, { color: theme.colors.text }]}>
            Benefits of AI Land Analysis
          </Text>
          
          <View style={styles.benefitsList}>
            <View style={styles.benefitItem}>
              <Text style={[styles.benefitIcon, { color: theme.colors.primary }]}>✓</Text>
              <Text style={[styles.benefitText, { color: theme.colors.text }]}>
                Save time on manual site analysis
              </Text>
            </View>
            
            <View style={styles.benefitItem}>
              <Text style={[styles.benefitIcon, { color: theme.colors.primary }]}>✓</Text>
              <Text style={[styles.benefitText, { color: theme.colors.text }]}>
                Identify optimal building placement
              </Text>
            </View>
            
            <View style={styles.benefitItem}>
              <Text style={[styles.benefitIcon, { color: theme.colors.primary }]}>✓</Text>
              <Text style={[styles.benefitText, { color: theme.colors.text }]}>
                Discover design opportunities and constraints
              </Text>
            </View>
            
            <View style={styles.benefitItem}>
              <Text style={[styles.benefitIcon, { color: theme.colors.primary }]}>✓</Text>
              <Text style={[styles.benefitText, { color: theme.colors.text }]}>
                Get climate-adapted architecture suggestions
              </Text>
            </View>
          </View>
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
  imagePlaceholder: {
    borderWidth: 2,
    borderColor: '#3a3a3a',
    borderRadius: 12,
    height: 200,
    justifyContent: 'center',
    alignItems: 'center',
    borderStyle: 'dashed',
    marginBottom: 16,
  },
  placeholderContent: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  placeholderText: {
    fontSize: 14,
    textAlign: 'center',
  },
  selectedImage: {
    marginTop: 8,
  },
  imageText: {
    fontSize: 12,
    fontWeight: '600',
  },
  iconText: {
    fontSize: 32,
  },
  featureCard: {
    backgroundColor: '#2a2a2a',
    padding: 16,
    borderRadius: 12,
    marginBottom: 12,
    borderWidth: 1,
    borderColor: '#3a3a3a',
  },
  featureHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  featureIcon: {
    fontSize: 20,
    marginRight: 8,
  },
  featureTitle: {
    fontSize: 16,
    fontWeight: '600',
  },
  featureDescription: {
    fontSize: 14,
    lineHeight: 20,
  },
  analyzeButton: {
    paddingVertical: 16,
    borderRadius: 12,
    alignItems: 'center',
  },
  analyzeButtonText: {
    fontSize: 16,
    fontWeight: '600',
  },
  benefitsList: {
    gap: 12,
  },
  benefitItem: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  benefitIcon: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#10B981',
    marginRight: 8,
  },
  benefitText: {
    fontSize: 14,
    flex: 1,
  },
});
