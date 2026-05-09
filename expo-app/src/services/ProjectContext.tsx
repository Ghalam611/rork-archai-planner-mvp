import React, { createContext, useContext, useState, ReactNode } from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';

interface AIResult {
  id: string;
  projectName: string;
  clientName: string;
  location: string;
  plotSize: number;
  totalArea: number;
  floors: number;
  style: string;
  summary: any;
  rooms: any[];
  materials: any[];
  budget: any;
  images: any[];
  timestamp: string;
  aiConfidence: number;
  processingTime: number;
}

interface ProjectContextType {
  projects: AIResult[];
  savedProjects: AIResult[];
  isLoading: boolean;
  saveProject: (project: AIResult) => Promise<void>;
  loadProjects: () => Promise<void>;
  deleteProject: (projectId: string) => Promise<void>;
  generateProject: (params: any) => Promise<AIResult>;
}

const ProjectContext = createContext<ProjectContextType | undefined>(undefined);

export function ProjectProvider({ children }: { children: ReactNode }) {
  const [projects, setProjects] = useState<AIResult[]>([]);
  const [savedProjects, setSavedProjects] = useState<AIResult[]>([]);
  const [isLoading, setIsLoading] = useState(false);

  const saveProject = async (project: AIResult) => {
    try {
      const existingProjects = await AsyncStorage.getItem('savedProjects');
      const projects = existingProjects ? JSON.parse(existingProjects) : [];
      
      if (!projects.find((p: AIResult) => p.id === project.id)) {
        projects.unshift(project);
        await AsyncStorage.setItem('savedProjects', JSON.stringify(projects));
        setSavedProjects(projects);
      }
    } catch (error) {
      console.error('Error saving project:', error);
      throw error;
    }
  };

  const loadProjects = async () => {
    setIsLoading(true);
    try {
      const savedData = await AsyncStorage.getItem('savedProjects');
      if (savedData) {
        const projects = JSON.parse(savedData);
        setSavedProjects(projects);
      }
      
      // Load sample projects for demo
      const sampleProjects = generateSampleProjects();
      setProjects(sampleProjects);
    } catch (error) {
      console.error('Error loading projects:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const deleteProject = async (projectId: string) => {
    try {
      const existingProjects = await AsyncStorage.getItem('savedProjects');
      const projects = existingProjects ? JSON.parse(existingProjects) : [];
      
      const filteredProjects = projects.filter((p: AIResult) => p.id !== projectId);
      await AsyncStorage.setItem('savedProjects', JSON.stringify(filteredProjects));
      setSavedProjects(filteredProjects);
    } catch (error) {
      console.error('Error deleting project:', error);
      throw error;
    }
  };

  const generateProject = async (params: any): Promise<AIResult> => {
    setIsLoading(true);
    try {
      // Mock AI generation - replace with real API call
      await new Promise(resolve => setTimeout(resolve, 3000));
      
      const newProject: AIResult = {
        id: Date.now().toString(),
        projectName: params.projectName,
        clientName: params.clientName,
        location: params.location,
        plotSize: params.plotSize,
        totalArea: params.totalArea,
        floors: params.floors,
        style: params.style,
        summary: generateMockSummary(params),
        rooms: generateMockRooms(params),
        materials: generateMockMaterials(params),
        budget: generateMockBudget(params),
        images: generateMockImages(params),
        timestamp: new Date().toISOString(),
        aiConfidence: 0.92,
        processingTime: 3.5,
      };
      
      setProjects(prev => [newProject, ...prev]);
      return newProject;
    } catch (error) {
      console.error('Error generating project:', error);
      throw error;
    } finally {
      setIsLoading(false);
    }
  };

  const value = {
    projects,
    savedProjects,
    isLoading,
    saveProject,
    loadProjects,
    deleteProject,
    generateProject,
  };

  return (
    <ProjectContext.Provider value={value}>
      {children}
    </ProjectContext.Provider>
  );
}

export function useProject() {
  const context = useContext(ProjectContext);
  if (context === undefined) {
    throw new Error('useProject must be used within a ProjectProvider');
  }
  return context;
}

// Mock data generators
function generateSampleProjects(): AIResult[] {
  return [
    {
      id: '1',
      projectName: 'Royal Desert Villa',
      clientName: 'Al Saud Family',
      location: 'Riyadh, Saudi Arabia',
      plotSize: 2000,
      totalArea: 850,
      floors: 2,
      style: 'Modern Saudi',
      summary: {
        concept: 'Luxury modern villa with traditional Saudi elements',
        keyFeatures: ['Open floor plan', 'Smart home features', 'Traditional majlis'],
        sustainabilityScore: 0.85,
        energyEfficiency: 'High efficiency with solar panels',
        climateAdaptation: 'Optimized for desert climate',
        culturalElements: ['Traditional courtyard', 'Islamic geometric patterns'],
      },
      rooms: [
        {
          name: 'Grand Majlis',
          area: 65,
          floor: 1,
          purpose: 'majlis',
          features: ['Traditional seating', 'Modern entertainment system'],
          ventilation: 'Natural cross ventilation',
          lighting: 'LED with traditional lantern design',
        },
        {
          name: 'Master Suite',
          area: 45,
          floor: 2,
          purpose: 'bedroom',
          features: ['Walk-in closet', 'Private balcony'],
          ventilation: 'Central AC with smart controls',
          lighting: 'Dimmable warm lighting',
        },
      ],
      materials: [
        {
          name: 'Saudi Limestone',
          category: 'exterior',
          description: 'Premium local limestone with excellent thermal properties',
          benefits: ['Natural cooling', 'Local availability', 'Cultural authenticity'],
          estimatedCost: 250,
          durability: 'Excellent',
          sustainability: 'Good',
          localAvailability: true,
        },
      ],
      budget: {
        total: 2500000,
        currency: 'SAR',
        breakdown: [
          { name: 'Foundation & Structure', amount: 750000, percentage: 30 },
          { name: 'Exterior Finishes', amount: 500000, percentage: 20 },
          { name: 'Interior Works', amount: 625000, percentage: 25 },
          { name: 'MEP Systems', amount: 375000, percentage: 15 },
          { name: 'Landscaping', amount: 250000, percentage: 10 },
        ],
        contingency: 250000,
        timeline: '8-12 months',
      },
      images: [],
      timestamp: new Date().toISOString(),
      aiConfidence: 0.92,
      processingTime: 3.5,
    },
  ];
}

function generateMockSummary(params: any) {
  return {
    concept: `Modern ${params.style.toLowerCase()} architecture with cultural elements`,
    keyFeatures: ['Open design', 'Smart technology', 'Cultural authenticity'],
    sustainabilityScore: 0.85,
    energyEfficiency: 'High efficiency with modern systems',
    climateAdaptation: 'Optimized for Saudi climate',
    culturalElements: ['Traditional patterns', 'Cultural spaces'],
  };
}

function generateMockRooms(params: any) {
  return [
    {
      name: 'Main Majlis',
      area: 60,
      floor: 1,
      purpose: 'majlis',
      features: ['Traditional seating', 'Modern amenities'],
      ventilation: 'Natural ventilation',
      lighting: 'Traditional with modern fixtures',
    },
    {
      name: 'Master Bedroom',
      area: 40,
      floor: 2,
      purpose: 'bedroom',
      features: ['En-suite bathroom', 'Walk-in closet'],
      ventilation: 'Central AC',
      lighting: 'Warm ambient lighting',
    },
  ];
}

function generateMockMaterials(params: any) {
  return [
    {
      name: 'Saudi Marble',
      category: 'flooring',
      description: 'Premium Saudi marble with beautiful patterns',
      benefits: ['Durability', 'Local availability', 'Cultural value'],
      estimatedCost: 300,
      durability: 'Excellent',
      sustainability: 'Good',
      localAvailability: true,
    },
  ];
}

function generateMockBudget(params: any) {
  const baseCost = params.totalArea * 2500; // SAR per sqm
  return {
    total: baseCost,
    currency: 'SAR',
    breakdown: [
      { name: 'Foundation', amount: baseCost * 0.2, percentage: 20 },
      { name: 'Structure', amount: baseCost * 0.25, percentage: 25 },
      { name: 'Finishes', amount: baseCost * 0.3, percentage: 30 },
      { name: 'MEP', amount: baseCost * 0.15, percentage: 15 },
      { name: 'Landscaping', amount: baseCost * 0.1, percentage: 10 },
    ],
    contingency: baseCost * 0.1,
    timeline: '6-9 months',
  };
}

function generateMockImages(params: any) {
  return [
    {
      type: 'exterior',
      description: `${params.style} style exterior view`,
      url: null,
      placeholder: 'AI-generated exterior view',
      isAI: true,
    },
    {
      type: 'interior',
      description: `${params.style} style interior design`,
      url: null,
      placeholder: 'AI-generated interior view',
      isAI: true,
    },
  ];
}
