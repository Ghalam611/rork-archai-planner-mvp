//
//  GeneratedProjectCard.swift
//  ArchAIPlanner
//
//  Created by Rork on May 9, 2026.
//

import SwiftUI

struct GeneratedProjectCard: View {
    let project: AIResult
    let onTap: () -> Void
    let onSave: () -> Void
    let onShare: () -> Void
    @State private var isSaved = false
    @State private var showingShareSheet = false
    
    init(project: AIResult, onTap: @escaping () -> Void, onSave: @escaping () -> Void, onShare: @escaping () -> Void) {
        self.project = project
        self.onTap = onTap
        self.onSave = onSave
        self.onShare = onShare
    }
    
    var body: some View {
        Button(action: onTap) {
            PremiumCard {
                VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                    // Header with Actions
                    HStack {
                        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                            Text(project.projectName)
                                .font(Theme.Typography.headline)
                                .fontWeight(.bold)
                                .foregroundStyle(Theme.textPrimary)
                                .lineLimit(1)
                            
                            HStack(spacing: Theme.Spacing.sm) {
                                Image(systemName: "location.fill")
                                    .font(.system(size: 12))
                                    .foregroundStyle(Theme.saudiGold)
                                
                                Text(project.location)
                                    .font(Theme.Typography.caption1)
                                    .foregroundStyle(Theme.textSecondary)
                                    .lineLimit(1)
                            }
                        }
                        
                        Spacer()
                        
                        VStack(spacing: Theme.Spacing.xs) {
                            Button(action: onSave) {
                                Image(systemName: isSaved ? "heart.fill" : "heart")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(isSaved ? Theme.accentCopper : Theme.textSecondary)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Button(action: { showingShareSheet = true }) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(Theme.textSecondary)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    // Style Badge
                    HStack(spacing: Theme.Spacing.sm) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(project.style.accentColor)
                        
                        Text(project.style.rawValue)
                            .font(Theme.Typography.caption1)
                            .fontWeight(.semibold)
                            .foregroundStyle(project.style.accentColor)
                    }
                    .padding(.horizontal, Theme.Spacing.sm)
                    .padding(.vertical, Theme.Spacing.xs)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                            .fill(project.style.accentColor.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                                    .stroke(project.style.accentColor.opacity(0.3), lineWidth: 1)
                            )
                    )
                    
                    // Key Metrics
                    HStack(spacing: Theme.Spacing.lg) {
                        MetricItem(
                            title: "Area",
                            value: String(format: "%.0f m²", project.totalArea),
                            icon: "square.fill"
                        )
                        
                        MetricItem(
                            title: "Floors",
                            value: "\(project.floors)",
                            icon: "building.2.fill"
                        )
                        
                        MetricItem(
                            title: "Rooms",
                            value: "\(project.rooms.count)",
                            icon: "door.left.right.open.fill"
                        )
                    }
                    
                    // Budget Preview
                    HStack {
                        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                            Text("Estimated Budget")
                                .font(Theme.Typography.caption1)
                                .foregroundStyle(Theme.textSecondary)
                            
                            Text(project.budget.formattedTotalWithContingency)
                                .font(Theme.Typography.callout)
                                .fontWeight(.bold)
                                .foregroundStyle(Theme.saudiGold)
                        }
                        
                        Spacer()
                        
                        // AI Confidence Badge
                        HStack(spacing: Theme.Spacing.xs) {
                            Image(systemName: "brain.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(Theme.accentEmerald)
                            
                            Text("\(Int(project.aiConfidence * 100))%")
                                .font(Theme.Typography.caption2)
                                .fontWeight(.semibold)
                                .foregroundStyle(Theme.accentEmerald)
                        }
                        .padding(.horizontal, Theme.Spacing.sm)
                        .padding(.vertical, Theme.Spacing.xs)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                                .fill(Theme.accentEmerald.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                                        .stroke(Theme.accentEmerald.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                    
                    // Preview Images
                    if !project.images.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: Theme.Spacing.sm) {
                                ForEach(Array(project.images.prefix(3).enumerated()), id: \.offset) { index, image in
                                    ImagePreviewThumbnail(image: image)
                                }
                                
                                if project.images.count > 3 {
                                    VStack(spacing: Theme.Spacing.xs) {
                                        RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                                            .fill(Theme.surface)
                                            .frame(width: 60, height: 45)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                                                    .stroke(Theme.border, lineWidth: 1)
                                            )
                                            .overlay(
                                                Text("+\(project.images.count - 3)")
                                                    .font(Theme.Typography.caption2)
                                                    .fontWeight(.bold)
                                                    .foregroundStyle(Theme.textTertiary)
                                            )
                                        
                                        Text("More")
                                            .font(Theme.Typography.caption3)
                                            .foregroundStyle(Theme.textTertiary)
                                    }
                                }
                            }
                            .padding(.horizontal, Theme.Spacing.sm)
                        }
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            // Check if project is saved
            isSaved = false // This would be managed by ProjectManager
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(items: [shareText])
        }
    }
    
    private var shareText: String {
        """
        Check out this amazing AI-generated architecture project: \(project.projectName)
        
        📍 Location: \(project.location)
        🏛️ Style: \(project.style.rawValue)
        📐 Area: \(String(format: "%.0f m²", project.totalArea))
        💰 Budget: \(project.budget.formattedTotalWithContingency)
        
        Generated with ArchAI Planner - AI Architecture Assistant
        """
    }
}

// MARK: - Metric Item
struct MetricItem: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: Theme.Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Theme.saudiGold)
            
            Text(value)
                .font(Theme.Typography.callout)
                .fontWeight(.bold)
                .foregroundStyle(Theme.textPrimary)
            
            Text(title)
                .font(Theme.Typography.caption2)
                .foregroundStyle(Theme.textSecondary)
        }
    }
}

// MARK: - Image Preview Thumbnail
struct ImagePreviewThumbnail: View {
    let image: GeneratedImage
    
    var body: some View {
        VStack(spacing: Theme.Spacing.xs) {
            RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                .fill(Theme.surface)
                .frame(width: 60, height: 45)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                        .stroke(Theme.border, lineWidth: 1)
                )
                .overlay(
                    Image(systemName: image.type.icon)
                        .font(.system(size: 16))
                        .foregroundStyle(Theme.saudiGold)
                )
            
            Text(image.type.rawValue)
                .font(Theme.Typography.caption3)
                .foregroundStyle(Theme.textTertiary)
                .lineLimit(1)
        }
    }
}

// MARK: - Project Grid View
struct ProjectGridView: View {
    let projects: [AIResult]
    @StateObject private var projectManager = ProjectManager()
    @State private var selectedProject: AIResult?
    @State private var showingProjectDetail = false
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: Theme.Spacing.lg) {
            ForEach(projects) { project in
                GeneratedProjectCard(
                    project: project,
                    onTap: {
                        selectedProject = project
                        showingProjectDetail = true
                    },
                    onSave: {
                        projectManager.toggleSaveStatus(for: project)
                    },
                    onShare: {
                        // Share functionality
                    }
                )
            }
        }
        .sheet(isPresented: $showingProjectDetail) {
            if let selectedProject = selectedProject {
                NavigationView {
                    AIResultDetailView(result: selectedProject)
                }
            }
        }
    }
}

// MARK: - Recent Projects Section
struct RecentProjectsSection: View {
    let projects: [AIResult]
    let onSeeAll: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
            HStack {
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text("Recent Projects")
                        .font(Theme.Typography.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.textPrimary)
                    
                    Text("Latest AI-generated architecture designs")
                        .font(Theme.Typography.callout)
                        .foregroundStyle(Theme.textSecondary)
                }
                
                Spacer()
                
                Button("See All", action: onSeeAll)
                    .font(Theme.Typography.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Theme.saudiGold)
            }
            
            if projects.isEmpty {
                EmptyRecentProjectsView()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Theme.Spacing.lg) {
                        ForEach(projects) { project in
                            GeneratedProjectCard(
                                project: project,
                                onTap: {
                                    // Navigate to project detail
                                },
                                onSave: {
                                    // Save project
                                },
                                onShare: {
                                    // Share project
                                }
                            )
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.lg)
                }
            }
        }
    }
}

// MARK: - Empty Recent Projects View
struct EmptyRecentProjectsView: View {
    var body: some View {
        PremiumCard {
            VStack(spacing: Theme.Spacing.lg) {
                Image(systemName: "building.2.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(Theme.textTertiary)
                
                Text("No Projects Yet")
                    .font(Theme.Typography.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Theme.textPrimary)
                
                Text("Start creating amazing AI-generated architecture designs to see them here.")
                    .font(Theme.Typography.callout)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                
                ModernButton("Create First Project", style: .primary) {
                    // Navigate to create project
                }
            }
            .padding(Theme.Spacing.xl)
        }
    }
}

// MARK: - Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Preview
#Preview("Generated Project Card") {
    ScrollView {
        VStack(spacing: Theme.Spacing.lg) {
            GeneratedProjectCard(
                project: .sample,
                onTap: {},
                onSave: {},
                onShare: {}
            )
            
            ProjectGridView(projects: [.sample, .sample, .sample, .sample])
        }
        .padding(Theme.Spacing.lg)
    }
    .background(Theme.background)
}

#Preview("Recent Projects Section") {
    ScrollView {
        RecentProjectsSection(
            projects: [.sample, .sample, .sample],
            onSeeAll: {}
        )
        .padding(Theme.Spacing.lg)
    }
    .background(Theme.background)
}
