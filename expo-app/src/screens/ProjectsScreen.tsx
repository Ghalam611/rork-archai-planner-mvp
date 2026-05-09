import React, { useState, useEffect } from 'react';
import { View, Text, ScrollView, TouchableOpacity, StyleSheet, Alert } from 'react-native';
import { useTheme } from '@/theme/ThemeContext';
import { useProject } from '@/services/ProjectContext';
import { useAuth } from '@/services/AuthContext';

interface ProjectCardProps {
  project: any;
  onPress: () => void;
}

function ProjectCard({ project, onPress }: ProjectCardProps) {
  const { theme } = useTheme();

  return (
    <TouchableOpacity style={styles.card} onPress={onPress}>
      <View style={styles.cardContent}>
        <View style={styles.cardHeader}>
          <Text style={[styles.cardTitle, { color: theme.colors.text }]}>
            {project.projectName}
          </Text>
          <Text style={[styles.cardLocation, { color: theme.colors.textSecondary }]}>
            {project.location}
          </Text>
        </View>
        <View style={styles.cardBody}>
          <Text style={[styles.cardStyle, { color: theme.colors.primary }]}>
            {project.style}
          </Text>
          <Text style={[styles.cardArea, { color: theme.colors.textSecondary }]}>
            {project.totalArea} m² • {project.floors} floors
          </Text>
        </View>
        <View style={styles.cardFooter}>
          <View style={styles.confidenceBar}>
            <View style={[styles.confidenceFill, { width: `${project.aiConfidence * 100}%` }]} />
          </View>
          <Text style={[styles.confidenceText, { color: theme.colors.textSecondary }]}>
            {Math.round(project.aiConfidence * 100)}% AI Confidence
          </Text>
        </View>
      </View>
    </TouchableOpacity>
  );
}

export default function ProjectsScreen({ navigation }: any) {
  const { theme } = useTheme();
  const { user } = useAuth();
  const { projects, savedProjects, loadProjects } = useProject();
  const [activeTab, setActiveTab] = useState('all');
  const [searchQuery, setSearchQuery] = useState('');

  useEffect(() => {
    loadProjects();
  }, []);

  const filteredProjects = () => {
    const allProjects = activeTab === 'saved' ? savedProjects : projects;
    if (!searchQuery.trim()) return allProjects;
    
    return allProjects.filter(project =>
      project.projectName.toLowerCase().includes(searchQuery.toLowerCase()) ||
      project.location.toLowerCase().includes(searchQuery.toLowerCase()) ||
      project.style.toLowerCase().includes(searchQuery.toLowerCase())
    );
  };

  const handleProjectPress = (project: any) => {
    navigation.navigate('ProjectDetails', { project });
  };

  const handleDeleteProject = (project: any) => {
    Alert.alert(
      'Delete Project',
      `Are you sure you want to delete "${project.projectName}"?`,
      [
        { text: 'Cancel', style: 'cancel' },
        { text: 'Delete', style: 'destructive', onPress: () => {
          // Handle project deletion
          console.log('Delete project:', project.id);
        }}
      ]
    );
  };

  const renderProjectCard = (project: any, index: number) => (
    <ProjectCard
      key={project.id}
      project={project}
      onPress={() => handleProjectPress(project)}
    />
  );

  const renderEmptyState = () => (
    <View style={styles.emptyState}>
      <Text style={[styles.emptyText, { color: theme.colors.textSecondary }]}>
        {activeTab === 'saved' 
          ? 'No saved projects yet. Create and save your first design!'
          : 'No projects yet. Create your first architecture design!'
        }
      </Text>
      <TouchableOpacity
        style={[styles.createButton, { backgroundColor: theme.colors.primary }]}
        onPress={() => navigation.navigate('Create')}
      >
        <Text style={[styles.createButtonText, { color: theme.colors.text }]}>
          Create First Project
        </Text>
      </TouchableOpacity>
    </View>
  );

  return (
    <View style={[styles.container, { backgroundColor: theme.colors.background }]}>
      {/* Header */}
      <View style={styles.header}>
        <Text style={[styles.title, { color: theme.colors.text }]}>
          Projects
        </Text>
        <Text style={[styles.subtitle, { color: theme.colors.textSecondary }]}>
          {activeTab === 'saved' ? savedProjects.length : projects.length} projects
        </Text>
      </View>

      {/* Search Bar */}
      <View style={styles.searchContainer}>
        <TextInput
          style={[styles.searchInput, { color: theme.colors.text, borderColor: theme.colors.border }]}
          placeholder="Search projects..."
          placeholderTextColor={theme.colors.textSecondary}
          value={searchQuery}
          onChangeText={setSearchQuery}
        />
      </View>

      {/* Tabs */}
      <View style={styles.tabs}>
        <TouchableOpacity
          style={[
            styles.tab,
            activeTab === 'all' && { backgroundColor: theme.colors.primary }
          ]}
          onPress={() => setActiveTab('all')}
        >
          <Text
            style={[
              styles.tabText,
              { color: activeTab === 'all' ? theme.colors.text : theme.colors.textSecondary }
            ]}
          >
            All Projects ({projects.length})
          </Text>
        </TouchableOpacity>
        
        <TouchableOpacity
          style={[
            styles.tab,
            activeTab === 'saved' && { backgroundColor: theme.colors.primary }
          ]}
          onPress={() => setActiveTab('saved')}
        >
          <Text
            style={[
              styles.tabText,
              { color: activeTab === 'saved' ? theme.colors.text : theme.colors.textSecondary }
            ]}
          >
            Saved ({savedProjects.length})
          </Text>
        </TouchableOpacity>
      </View>

      {/* Projects List */}
      <ScrollView style={styles.scrollView} showsVerticalScrollIndicator={false}>
        {filteredProjects().length > 0 ? (
          <View style={styles.projectsGrid}>
            {filteredProjects().map(renderProjectCard)}
          </View>
        ) : (
          renderEmptyState()
        )}
      </ScrollView>
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
    borderBottomWidth: 1,
    borderBottomColor: '#3a3a3a',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 4,
  },
  subtitle: {
    fontSize: 14,
  },
  searchContainer: {
    paddingHorizontal: 24,
    marginBottom: 16,
  },
  searchInput: {
    borderWidth: 1,
    borderRadius: 8,
    padding: 12,
    fontSize: 14,
    backgroundColor: '#2a2a2a',
  },
  tabs: {
    flexDirection: 'row',
    paddingHorizontal: 24,
    marginBottom: 16,
    gap: 8,
  },
  tab: {
    paddingVertical: 8,
    paddingHorizontal: 16,
    borderRadius: 20,
    borderWidth: 1,
    borderColor: '#3a3a3a',
    backgroundColor: '#2a2a2a',
  },
  tabText: {
    fontSize: 14,
    fontWeight: '500',
  },
  scrollView: {
    flex: 1,
  },
  projectsGrid: {
    paddingHorizontal: 24,
    gap: 16,
  },
  card: {
    backgroundColor: '#2a2a2a',
    borderRadius: 16,
    padding: 16,
    marginBottom: 16,
    borderWidth: 1,
    borderColor: '#3a3a3a',
  },
  cardContent: {
    flex: 1,
  },
  cardHeader: {
    marginBottom: 12,
  },
  cardTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 4,
  },
  cardLocation: {
    fontSize: 14,
  },
  cardBody: {
    marginBottom: 12,
  },
  cardStyle: {
    fontSize: 14,
    fontWeight: '600',
    marginBottom: 4,
  },
  cardArea: {
    fontSize: 12,
  },
  cardFooter: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  confidenceBar: {
    flex: 1,
    height: 4,
    backgroundColor: '#3a3a3a',
    borderRadius: 2,
    overflow: 'hidden',
  },
  confidenceFill: {
    height: '100%',
    backgroundColor: '#D4AF37',
    borderRadius: 2,
  },
  confidenceText: {
    fontSize: 11,
  },
  emptyState: {
    alignItems: 'center',
    paddingVertical: 64,
    paddingHorizontal: 24,
  },
  emptyText: {
    fontSize: 16,
    textAlign: 'center',
    lineHeight: 24,
  },
  createButton: {
    paddingVertical: 16,
    paddingHorizontal: 24,
    borderRadius: 12,
    marginTop: 24,
  },
  createButtonText: {
    fontSize: 16,
    fontWeight: '600',
  },
});
