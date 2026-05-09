//
//  ImagesTabView.swift
//  ArchAIPlanner
//
//  Created by Rork on May 9, 2026.
//

import SwiftUI

struct ImagesTabView: View {
    let images: [GeneratedImage]
    @State private var selectedImage: GeneratedImage?
    @State private var showingImageDetail = false
    
    private var columns: [GridItem] {
        [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    }
    
    var body: some View {
        LazyVStack(spacing: Theme.Spacing.lg) {
            // Images Grid
            if images.isEmpty {
                EmptyImagesView()
            } else {
                LazyVGrid(columns: columns, spacing: Theme.Spacing.md) {
                    ForEach(images) { image in
                        GeneratedImageCard(image: image) {
                            selectedImage = image
                            showingImageDetail = true
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingImageDetail) {
            if let selectedImage = selectedImage {
                ImageDetailView(image: selectedImage)
            }
        }
    }
}

// MARK: - Empty Images View
struct EmptyImagesView: View {
    var body: some View {
        PremiumCard {
            VStack(spacing: Theme.Spacing.lg) {
                Image(systemName: "photo.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(Theme.textTertiary)
                
                Text("AI Images Generating")
                    .font(Theme.Typography.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Theme.textPrimary)
                
                Text("Our AI is creating stunning architectural visualizations for your project. This may take a few moments.")
                    .font(Theme.Typography.callout)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                
                // Loading Animation
                HStack(spacing: Theme.Spacing.sm) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(Theme.saudiGold)
                            .frame(width: 8, height: 8)
                            .scaleEffect(1.0)
                            .opacity(0.3)
                            .animation(
                                .easeInOut(duration: 1.0)
                                .repeatForever()
                                .delay(Double(index) * 0.2),
                                value: UUID()
                            )
                    }
                }
            }
            .padding(Theme.Spacing.xl)
        }
    }
}

// MARK: - Generated Image Card
struct GeneratedImageCard: View {
    let image: GeneratedImage
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                // Image Placeholder
                ZStack {
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                        .fill(Theme.surface)
                        .aspectRatio(16/9, contentMode: .fit)
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                .stroke(Theme.border, lineWidth: 1)
                        )
                    
                    VStack(spacing: Theme.Spacing.sm) {
                        Image(systemName: image.type.icon)
                            .font(.system(size: 32))
                            .foregroundStyle(Theme.saudiGold)
                        
                        if image.isAI {
                            HStack(spacing: Theme.Spacing.xs) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 12))
                                    .foregroundStyle(Theme.accentAmber)
                                Text("AI Generated")
                                    .font(Theme.Typography.caption2)
                                    .fontWeight(.medium)
                                    .foregroundStyle(Theme.accentAmber)
                            }
                            .padding(.horizontal, Theme.Spacing.sm)
                            .padding(.vertical, Theme.Spacing.xs)
                            .background(
                                RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                                    .fill(Theme.accentAmber.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                                            .stroke(Theme.accentAmber.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                    }
                }
                
                // Image Info
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    HStack {
                        Text(image.type.rawValue)
                            .font(Theme.Typography.callout)
                            .fontWeight(.semibold)
                            .foregroundStyle(Theme.textPrimary)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right.circle")
                            .font(.system(size: 14))
                            .foregroundStyle(Theme.textTertiary)
                    }
                    
                    Text(image.description)
                        .font(Theme.Typography.caption1)
                        .foregroundStyle(Theme.textSecondary)
                        .lineLimit(2)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Image Detail View
struct ImageDetailView: View {
    let image: GeneratedImage
    @Environment(\.dismiss) private var dismiss
    @State private var isSharing = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.Spacing.lg) {
                    // Main Image
                    ZStack {
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                            .fill(Theme.surface)
                            .aspectRatio(16/9, contentMode: .fit)
                            .overlay(
                                RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                                    .stroke(Theme.border, lineWidth: 2)
                            )
                        
                        VStack(spacing: Theme.Spacing.lg) {
                            Image(systemName: image.type.icon)
                                .font(.system(size: 64))
                                .foregroundStyle(Theme.saudiGold)
                            
                            if image.isAI {
                                VStack(spacing: Theme.Spacing.sm) {
                                    HStack(spacing: Theme.Spacing.sm) {
                                        Image(systemName: "sparkles")
                                            .font(.system(size: 20))
                                            .foregroundStyle(Theme.accentAmber)
                                        Text("AI Generated")
                                            .font(Theme.Typography.headline)
                                            .fontWeight(.bold)
                                            .foregroundStyle(Theme.accentAmber)
                                    }
                                    
                                    Text("Created using advanced architectural AI")
                                        .font(Theme.Typography.callout)
                                        .foregroundStyle(Theme.textSecondary)
                                }
                            }
                        }
                    }
                    .padding(Theme.Spacing.lg)
                    
                    // Image Details
                    PremiumCard {
                        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                            HStack(spacing: Theme.Spacing.sm) {
                                Image(systemName: "info.circle.fill")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundStyle(Theme.royalGold)
                                
                                Text("Image Details")
                                    .font(Theme.Typography.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Theme.textPrimary)
                            }
                            
                            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                                // Type
                                HStack {
                                    Text("Type")
                                        .font(Theme.Typography.callout)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Theme.textSecondary)
                                    
                                    Spacer()
                                    
                                    Text(image.type.rawValue)
                                        .font(Theme.Typography.callout)
                                        .foregroundStyle(Theme.textPrimary)
                                }
                                
                                // Description
                                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                                    Text("Description")
                                        .font(Theme.Typography.callout)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Theme.textSecondary)
                                    
                                    Text(image.description)
                                        .font(Theme.Typography.body)
                                        .foregroundStyle(Theme.textPrimary)
                                        .lineSpacing(2)
                                }
                                
                                // AI Badge
                                if image.isAI {
                                    HStack(spacing: Theme.Spacing.sm) {
                                        Image(systemName: "brain.fill")
                                            .font(.system(size: 16))
                                            .foregroundStyle(Theme.accentAmber)
                                        
                                        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                                            Text("AI Generated")
                                                .font(Theme.Typography.callout)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(Theme.accentAmber)
                                            
                                            Text("Generated using state-of-the-art architectural AI")
                                                .font(Theme.Typography.caption1)
                                                .foregroundStyle(Theme.textSecondary)
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(Theme.Spacing.md)
                                    .background(
                                        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                            .fill(Theme.accentAmber.opacity(0.1))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                                    .stroke(Theme.accentAmber.opacity(0.3), lineWidth: 1)
                                            )
                                    )
                                }
                            }
                        }
                    }
                    
                    // Actions
                    HStack(spacing: Theme.Spacing.md) {
                        ModernButton("Download", style: .secondary) {
                            // Download functionality
                        }
                        
                        ModernButton("Share", style: .primary) {
                            isSharing = true
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.lg)
                }
            }
            .background(Theme.backgroundGradient)
            .navigationTitle(image.type.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(Theme.saudiGold)
                }
            }
        }
        .sheet(isPresented: $isSharing) {
            // Share sheet implementation
            Text("Share functionality would be implemented here")
                .padding()
        }
    }
}

// MARK: - Preview
#Preview("Images Tab") {
    ScrollView {
        ImagesTabView(images: GeneratedImage.sampleImages)
    }
    .background(Theme.background)
}

// MARK: - Sample Data Extension
extension GeneratedImage {
    static let sampleImages: [GeneratedImage] = [
        GeneratedImage(
            type: .exterior,
            description: "Modern Saudi villa with traditional Najdi architectural elements, featuring a grand entrance and elegant facade",
            url: nil,
            placeholder: "exterior_view",
            isAI: true
        ),
        GeneratedImage(
            type: .interior,
            description: "Luxurious living room with Arabic-inspired decor, modern furnishings, and floor-to-ceiling windows",
            url: nil,
            placeholder: "interior_living",
            isAI: true
        ),
        GeneratedImage(
            type: .floorPlan,
            description: "Detailed floor plan showing room layout, dimensions, and traffic flow for optimal living experience",
            url: nil,
            placeholder: "floor_plan",
            isAI: true
        ),
        GeneratedImage(
            type: .elevation,
            description: "Architectural elevation drawing showing the front facade with detailed measurements and materials",
            url: nil,
            placeholder: "elevation_front",
            isAI: true
        ),
        GeneratedImage(
            type: .aerial,
            description: "Aerial view of the complete property showing the villa, gardens, and surrounding landscape",
            url: nil,
            placeholder: "aerial_view",
            isAI: true
        ),
        GeneratedImage(
            type: .night,
            description: "Stunning night view with illuminated exterior, landscape lighting, and warm interior glow",
            url: nil,
            placeholder: "night_view",
            isAI: true
        )
    ]
}
