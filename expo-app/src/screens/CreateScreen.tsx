import React, { useState } from 'react';
import { View, Text, ScrollView, TouchableOpacity, TextInput, StyleSheet, Alert } from 'react-native';
import { useTheme } from '@/theme/ThemeContext';
import { useProject } from '@/services/ProjectContext';
import { useLoading } from '@/services/LoadingContext';

interface FormData {
  projectName: string;
  clientName: string;
  location: string;
  plotSize: string;
  totalArea: string;
  floors: string;
  style: string;
  requirements: string;
}

export default function CreateScreen({ navigation }: any) {
  const { theme } = useTheme();
  const { generateProject } = useProject();
  const { showLoading, hideLoading } = useLoading();
  
  const [formData, setFormData] = useState<FormData>({
    projectName: '',
    clientName: '',
    location: '',
    plotSize: '',
    totalArea: '',
    floors: '2',
    style: 'Modern Saudi',
    requirements: '',
  });

  const styles = ['Modern Saudi', 'Traditional Najdi', 'Mediterranean', 'Contemporary', 'Islamic', 'Luxury Villa', 'Palace'];
  const floorOptions = ['1', '2', '3', '4', '5'];

  const handleInputChange = (field: keyof FormData, value: string) => {
    setFormData(prev => ({ ...prev, [field]: value }));
  };

  const validateForm = () => {
    if (!formData.projectName.trim()) {
      Alert.alert('Error', 'Project name is required');
      return false;
    }
    if (!formData.location.trim()) {
      Alert.alert('Error', 'Location is required');
      return false;
    }
    if (!formData.plotSize.trim() || isNaN(Number(formData.plotSize))) {
      Alert.alert('Error', 'Valid plot size is required');
      return false;
    }
    if (!formData.totalArea.trim() || isNaN(Number(formData.totalArea))) {
      Alert.alert('Error', 'Valid total area is required');
      return false;
    }
    return true;
  };

  const handleGenerate = async () => {
    if (!validateForm()) return;

    try {
      showLoading('Generating architecture design...');
      
      await generateProject({
        projectName: formData.projectName.trim(),
        clientName: formData.clientName.trim(),
        location: formData.location.trim(),
        plotSize: Number(formData.plotSize),
        totalArea: Number(formData.totalArea),
        floors: Number(formData.floors),
        style: formData.style,
        requirements: formData.requirements.trim(),
      });

      hideLoading();
      
      Alert.alert(
        'Success!',
        'Architecture design generated successfully!',
        [
          { text: 'View Project', onPress: () => navigation.navigate('Projects') },
          { text: 'OK', style: 'cancel' }
        ]
      );
    } catch (error) {
      hideLoading();
      Alert.alert('Error', 'Failed to generate design. Please try again.');
    }
  };

  const renderInput = (
    title: string,
    field: keyof FormData,
    placeholder: string,
    keyboardType: 'default' | 'numeric-pad' = 'default',
    multiline: boolean = false
  ) => (
    <View style={styles.inputGroup}>
      <Text style={[styles.inputLabel, { color: theme.colors.text }]}>
        {title}
      </Text>
      <TextInput
        style={[styles.input, { color: theme.colors.text, borderColor: theme.colors.border }]}
        placeholder={placeholder}
        placeholderTextColor={theme.colors.textSecondary}
        value={formData[field]}
        onChangeText={(value) => handleInputChange(field, value)}
        keyboardType={keyboardType}
        multiline={multiline}
        numberOfLines={multiline ? 4 : 1}
      />
    </View>
  );

  const renderStyleOption = (style: string) => (
    <TouchableOpacity
      style={[
        styles.styleOption,
        formData.style === style && { backgroundColor: theme.colors.primary }
      ]}
      onPress={() => handleInputChange('style', style)}
    >
      <Text
        style={[
          styles.styleOptionText,
          { color: formData.style === style ? theme.colors.text : theme.colors.textSecondary }
        ]}
      >
        {style}
      </Text>
    </TouchableOpacity>
  );

  const renderFloorOption = (floors: string) => (
    <TouchableOpacity
      style={[
        styles.floorOption,
        formData.floors === floors && { backgroundColor: theme.colors.primary }
      ]}
      onPress={() => handleInputChange('floors', floors)}
    >
      <Text
        style={[
          styles.floorOptionText,
          { color: formData.floors === floors ? theme.colors.text : theme.colors.textSecondary }
        ]}
      >
        {floors} {floors === '1' ? 'Floor' : 'Floors'}
      </Text>
    </TouchableOpacity>
  );

  return (
    <View style={[styles.container, { backgroundColor: theme.colors.background }]}>
      <ScrollView style={styles.scrollView} showsVerticalScrollIndicator={false}>
        {/* Header */}
        <View style={styles.header}>
          <Text style={[styles.title, { color: theme.colors.text }]}>
            Create Architecture Design
          </Text>
          <Text style={[styles.subtitle, { color: theme.colors.textSecondary }]}>
            Describe your dream architecture and let AI bring it to life
          </Text>
        </View>

        {/* Form */}
        <View style={styles.form}>
          {/* Basic Information */}
          <View style={styles.section}>
            <Text style={[styles.sectionTitle, { color: theme.colors.text }]}>
              Project Information
            </Text>
            
            {renderInput('Project Name', 'projectName', 'Enter project name')}
            {renderInput('Client Name', 'clientName', 'Enter client name')}
            {renderInput('Location', 'location', 'Enter location')}
          </View>

          {/* Measurements */}
          <View style={styles.section}>
            <Text style={[styles.sectionTitle, { color: theme.colors.text }]}>
              Measurements
            </Text>
            
            {renderInput('Plot Size (m²)', 'plotSize', 'Enter plot size', 'numeric-pad')}
            {renderInput('Total Area (m²)', 'totalArea', 'Enter total area', 'numeric-pad')}
          </View>

          {/* Style Selection */}
          <View style={styles.section}>
            <Text style={[styles.sectionTitle, { color: theme.colors.text }]}>
              Architecture Style
            </Text>
            
            <View style={styles.styleGrid}>
              {styles.map(renderStyleOption)}
            </View>
          </View>

          {/* Floors Selection */}
          <View style={styles.section}>
            <Text style={[styles.sectionTitle, { color: theme.colors.text }]}>
              Number of Floors
            </Text>
            
            <View style={styles.floorGrid}>
              {floorOptions.map(renderFloorOption)}
            </View>
          </View>

          {/* Requirements */}
          <View style={styles.section}>
            <Text style={[styles.sectionTitle, { color: theme.colors.text }]}>
              Special Requirements
            </Text>
            
            {renderInput('Requirements', 'requirements', 'Enter any special requirements...', 'default', true)}
          </View>

          {/* Generate Button */}
          <TouchableOpacity
            style={[styles.generateButton, { backgroundColor: theme.colors.primary }]}
            onPress={handleGenerate}
          >
            <Text style={[styles.generateButtonText, { color: theme.colors.text }]}>
              Generate Architecture Design
            </Text>
          </TouchableOpacity>
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
  form: {
    paddingHorizontal: 24,
  },
  section: {
    marginBottom: 32,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '600',
    marginBottom: 16,
  },
  inputGroup: {
    marginBottom: 16,
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
  },
  styleGrid: {
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
  floorGrid: {
    flexDirection: 'row',
    gap: 8,
  },
  floorOption: {
    paddingVertical: 12,
    paddingHorizontal: 16,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: '#3a3a3a',
    backgroundColor: '#2a2a2a',
    minWidth: 80,
  },
  floorOptionText: {
    fontSize: 14,
    fontWeight: '500',
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
