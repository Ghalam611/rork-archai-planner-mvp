import React, { useState, useEffect } from 'react';
import { View, Text, ScrollView, TouchableOpacity, StyleSheet, Image } from 'react-native';
import { useTheme } from '@/theme/ThemeContext';
import { useProject } from '@/services/ProjectContext';
import { useAuth } from '@/services/AuthContext';
import { useLoading } from '@/services/LoadingContext';

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

export default function HomeScreen({ navigation }: any) {
  const { theme } = useTheme();
  const { user } = useAuth();
  const { projects, savedProjects, loadProjects } = useProject();
  const { showLoading, hideLoading } = useLoading();
  const [activeTab, setActiveTab] = useState('recent');

  useEffect(() => {
    loadProjects();
  }, []);

  const handleProjectPress = (project: any) => {
    navigation.navigate('ProjectDetails', { project });
  };

  const handleCreatePress = () => {
    navigation.navigate('Create');
  };

  const handleChatPress = () => {
    navigation.navigate('Chat');
  };

  const renderProjectCard = (project: any, index: number) => (
    <ProjectCard
      key={project.id}
      project={project}
      onPress={() => handleProjectPress(project)}
    />
  );

  return (
    <View style={[styles.container, { backgroundColor: theme.colors.background }]}>
      <ScrollView style={styles.scrollView} showsVerticalScrollIndicator={false}>
        {/* Header */}
        <View style={styles.header}>
          <View>
            <Text style={[styles.title, { color: theme.colors.text }]}>
              Welcome back, {user?.name || 'Architect'}
            </Text>
            <Text style={[styles.subtitle, { color: theme.colors.textSecondary }]}>
              Create stunning Saudi architecture with AI
            </Text>
          </View>
        </View>

        {/* Quick Actions */}
        <View style={styles.quickActions}>
          <TouchableOpacity
            style={[styles.actionButton, { backgroundColor: theme.colors.primary }]}
            onPress={handleCreatePress}
          >
            <Text style={[styles.actionButtonText, { color: theme.colors.text }]}>
              Create Design
            </Text>
          </TouchableOpacity>
          
          <TouchableOpacity
            style={[styles.actionButton, { backgroundColor: theme.colors.secondary }]}
            onPress={handleChatPress}
          >
            <Text style={[styles.actionButtonText, { color: theme.colors.text }]}>
              AI Chat
            </Text>
          </TouchableOpacity>
        </View>

        {/* Projects Section */}
        <View style={styles.section}>
          <View style={styles.sectionHeader}>
            <Text style={[styles.sectionTitle, { color: theme.colors.text }]}>
              Recent Projects
            </Text>
            <TouchableOpacity onPress={() => navigation.navigate('Projects')}>
              <Text style={[styles.seeAllText, { color: theme.colors.primary }]}>
                See All
              </Text>
            </TouchableOpacity>
          </View>
          
          {projects.length > 0 ? (
            <View style={styles.projectsGrid}>
              {projects.slice(0, 3).map(renderProjectCard)}
            </View>
          ) : (
            <View style={styles.emptyState}>
              <Text style={[styles.emptyText, { color: theme.colors.textSecondary }]}>
                No projects yet. Create your first design!
              </Text>
            </View>
          )}
        </View>

        {/* Saved Projects Section */}
        {savedProjects.length > 0 && (
          <View style={styles.section}>
            <View style={styles.sectionHeader}>
              <Text style={[styles.sectionTitle, { color: theme.colors.text }]}>
                Saved Projects
              </Text>
              <TouchableOpacity onPress={() => navigation.navigate('Projects')}>
                <Text style={[styles.seeAllText, { color: theme.colors.primary }]}>
                  See All
                </Text>
              </TouchableOpacity>
            </View>
            
            <View style={styles.projectsGrid}>
              {savedProjects.slice(0, 3).map(renderProjectCard)}
            </View>
          </View>
        )}

        {/* Features */}
        <View style={styles.section}>
          <Text style={[styles.sectionTitle, { color: theme.colors.text }]}>
            AI Features
          </Text>
          <View style={styles.featuresGrid}>
            <View style={styles.featureCard}>
              <Text style={[styles.featureTitle, { color: theme.colors.text }]}>
                Silent Designer
              </Text>
              <Text style={[styles.featureDescription, { color: theme.colors.textSecondary }]}>
                AI-powered design generation
              </Text>
            </View>
            
            <View style={styles.featureCard}>
              <Text style={[styles.featureTitle, { color: theme.colors.text }]}>
                Empty Land Vision
              </Text>
              <Text style={[styles.featureDescription, { color: theme.colors.textSecondary }]}>
                Analyze land for architecture
              </Text>
            </View>
            
            <View style={styles.featureCard}>
              <Text style={[styles.featureTitle, { color: theme.colors.text }]}>
                Cultural Architecture
              </Text>
              <Text style={[styles.featureDescription, { color: theme.colors.textSecondary }]}>
                Saudi traditional styles
              </Text>
            </View>
            
            <View style={styles.featureCard}>
              <Text style={[styles.featureTitle, { color: theme.colors.text }]}>
                Redesign AI
              </Text>
              <Text style={[styles.featureDescription, { color: theme.colors.textSecondary }]}>
                Transform existing designs
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
  quickActions: {
    flexDirection: 'row',
    paddingHorizontal: 24,
    marginBottom: 32,
    gap: 12,
  },
  actionButton: {
    flex: 1,
    paddingVertical: 16,
    borderRadius: 12,
    alignItems: 'center',
  },
  actionButtonText: {
    fontSize: 16,
    fontWeight: '600',
  },
  section: {
    marginBottom: 32,
  },
  sectionHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 24,
    marginBottom: 16,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: '600',
  },
  seeAllText: {
    fontSize: 14,
    fontWeight: '500',
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
    paddingVertical: 32,
  },
  emptyText: {
    fontSize: 16,
    textAlign: 'center',
  },
  featuresGrid: {
    paddingHorizontal: 24,
    gap: 16,
  },
  featureCard: {
    backgroundColor: '#2a2a2a',
    padding: 16,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: '#3a3a3a',
  },
  featureTitle: {
    fontSize: 16,
    fontWeight: '600',
    marginBottom: 4,
  },
  featureDescription: {
    fontSize: 14,
    lineHeight: 20,
  },
});
