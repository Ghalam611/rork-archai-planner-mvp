//
//  RoomsTabView.swift
//  ArchAIPlanner
//
//  Created by Rork on May 9, 2026.
//

import SwiftUI

struct RoomsTabView: View {
    let rooms: [Room]
    @State private var selectedFloor: Int = 1
    
    private var floors: [Int] {
        Array(Set(rooms.map { $0.floor })).sorted()
    }
    
    private var roomsOnSelectedFloor: [Room] {
        rooms.filter { $0.floor == selectedFloor }
    }
    
    private var totalArea: Double {
        rooms.reduce(0) { $0 + $1.area }
    }
    
    var body: some View {
        LazyVStack(spacing: Theme.Spacing.lg) {
            // Floor Selection
            FloorSelectionView(
                floors: floors,
                selectedFloor: $selectedFloor
            )
            
            // Floor Plan Visualization
            FloorPlanView(
                rooms: roomsOnSelectedFloor,
                floorNumber: selectedFloor
            )
            
            // Room List
            RoomsListView(rooms: roomsOnSelectedFloor)
            
            // Room Statistics
            RoomStatisticsView(
                rooms: roomsOnSelectedFloor,
                totalArea: totalArea
            )
        }
    }
}

// MARK: - Floor Selection View
struct FloorSelectionView: View {
    let floors: [Int]
    @Binding var selectedFloor: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Theme.Spacing.sm) {
                ForEach(floors, id: \.self) { floor in
                    Button(action: { selectedFloor = floor }) {
                        VStack(spacing: Theme.Spacing.xs) {
                            Image(systemName: "building.2.fill")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(selectedFloor == floor ? Theme.background : Theme.saudiGold)
                            
                            Text("Floor \(floor)")
                                .font(Theme.Typography.callout)
                                .fontWeight(.medium)
                                .foregroundStyle(selectedFloor == floor ? Theme.background : Theme.textSecondary)
                        }
                        .frame(width: 80, height: 60)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                .fill(selectedFloor == floor ? Theme.saudiGold : Theme.surface)
                                .overlay(
                                    RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                        .stroke(Theme.border, lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, Theme.Spacing.lg)
        }
    }
}

// MARK: - Floor Plan View
struct FloorPlanView: View {
    let rooms: [Room]
    let floorNumber: Int
    
    var body: some View {
        PremiumCard {
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                HStack(spacing: Theme.Spacing.sm) {
                    Image(systemName: "square.grid.3x3.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Theme.royalGold)
                    
                    Text("Floor \(floorNumber) Plan")
                        .font(Theme.Typography.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.textPrimary)
                }
                
                // Simplified Floor Plan Layout
                ZStack {
                    // Background
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                        .fill(Theme.surface)
                        .frame(height: 200)
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                .stroke(Theme.border, lineWidth: 1)
                        )
                    
                    // Room Blocks
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: Theme.Spacing.sm) {
                        ForEach(Array(rooms.prefix(9).enumerated()), id: \.offset) { index, room in
                            RoomBlock(room: room, index: index)
                        }
                    }
                    .padding(Theme.Spacing.sm)
                }
            }
        }
    }
}

// MARK: - Room Block
struct RoomBlock: View {
    let room: Room
    let index: Int
    
    var body: some View {
        VStack(spacing: Theme.Spacing.xs) {
            Image(systemName: room.purpose.icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(room.purpose.color)
            
            Text(room.purpose.rawValue)
                .font(Theme.Typography.caption3)
                .fontWeight(.medium)
                .foregroundStyle(Theme.textSecondary)
                .lineLimit(1)
            
            Text("\(Int(room.area))m²")
                .font(Theme.Typography.caption3)
                .foregroundStyle(Theme.textTertiary)
        }
        .frame(maxWidth: .infinity, minHeight: 50)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                .fill(room.purpose.color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                        .stroke(room.purpose.color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Rooms List View
struct RoomsListView: View {
    let rooms: [Room]
    
    var body: some View {
        PremiumCard {
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                HStack(spacing: Theme.Spacing.sm) {
                    Image(systemName: "list.bullet.rectangle.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Theme.accentCopper)
                    
                    Text("Room Details")
                        .font(Theme.Typography.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.textPrimary)
                }
                
                LazyVStack(spacing: Theme.Spacing.md) {
                    ForEach(rooms) { room in
                        RoomDetailView(room: room)
                    }
                }
            }
        }
    }
}

// MARK: - Room Detail View
struct RoomDetailView: View {
    let room: Room
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack {
                // Room Icon and Name
                HStack(spacing: Theme.Spacing.sm) {
                    Image(systemName: room.purpose.icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(room.purpose.color)
                    
                    VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                        Text(room.name)
                            .font(Theme.Typography.callout)
                            .fontWeight(.semibold)
                            .foregroundStyle(Theme.textPrimary)
                        
                        Text("\(Int(room.area)) m² • Floor \(room.floor)")
                            .font(Theme.Typography.caption1)
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
                
                Spacer()
                
                // Expand/Collapse Button
                Button(action: { isExpanded.toggle() }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Theme.textTertiary)
                }
            }
            
            // Expanded Content
            if isExpanded {
                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                    // Features
                    if !room.features.isEmpty {
                        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                            Text("Features")
                                .font(Theme.Typography.caption1)
                                .fontWeight(.semibold)
                                .foregroundStyle(Theme.textPrimary)
                            
                            ForEach(room.features, id: \.self) { feature in
                                HStack(spacing: Theme.Spacing.xs) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 10))
                                        .foregroundStyle(Theme.accentEmerald)
                                    
                                    Text(feature)
                                        .font(Theme.Typography.caption2)
                                        .foregroundStyle(Theme.textSecondary)
                                }
                            }
                        }
                    }
                    
                    // Ventilation and Lighting
                    HStack(spacing: Theme.Spacing.lg) {
                        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                            Text("Ventilation")
                                .font(Theme.Typography.caption1)
                                .fontWeight(.semibold)
                                .foregroundStyle(Theme.textPrimary)
                            
                            Text(room.ventilation)
                                .font(Theme.Typography.caption2)
                                .foregroundStyle(Theme.textSecondary)
                        }
                        
                        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                            Text("Lighting")
                                .font(Theme.Typography.caption1)
                                .fontWeight(.semibold)
                                .foregroundStyle(Theme.textPrimary)
                            
                            Text(room.lighting)
                                .font(Theme.Typography.caption2)
                                .foregroundStyle(Theme.textSecondary)
                        }
                    }
                }
                .padding(Theme.Spacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                        .fill(Theme.surface)
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                                .stroke(Theme.border, lineWidth: 1)
                        )
                )
            }
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                .fill(Theme.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                        .stroke(Theme.border, lineWidth: 1)
                )
        )
    }
}

// MARK: - Room Statistics View
struct RoomStatisticsView: View {
    let rooms: [Room]
    let totalArea: Double
    
    private var floorArea: Double {
        rooms.reduce(0) { $0 + $1.area }
    }
    
    private var averageRoomSize: Double {
        rooms.isEmpty ? 0 : floorArea / Double(rooms.count)
    }
    
    private var largestRoom: Room? {
        rooms.max(by: { $0.area < $1.area })
    }
    
    var body: some View {
        PremiumCard {
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                HStack(spacing: Theme.Spacing.sm) {
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Theme.accentSapphire)
                    
                    Text("Floor Statistics")
                        .font(Theme.Typography.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.textPrimary)
                }
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: Theme.Spacing.md) {
                    StatisticCard(
                        title: "Total Area",
                        value: String(format: "%.0f m²", floorArea),
                        icon: "square.fill",
                        color: Theme.saudiGold
                    )
                    
                    StatisticCard(
                        title: "Room Count",
                        value: "\(rooms.count)",
                        icon: "door.left.right.open.fill",
                        color: Theme.accentCopper
                    )
                    
                    StatisticCard(
                        title: "Average Size",
                        value: String(format: "%.0f m²", averageRoomSize),
                        icon: "ruler.fill",
                        color: Theme.accentEmerald
                    )
                    
                    if let largestRoom = largestRoom {
                        StatisticCard(
                            title: "Largest Room",
                            value: largestRoom.name,
                            icon: "arrow.up.square.fill",
                            color: Theme.accentSapphire
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Statistic Card
struct StatisticCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: Theme.Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(color)
            
            Text(value)
                .font(Theme.Typography.callout)
                .fontWeight(.bold)
                .foregroundStyle(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text(title)
                .font(Theme.Typography.caption2)
                .foregroundStyle(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(Theme.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                .fill(Theme.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Preview
#Preview("Rooms Tab") {
    ScrollView {
        RoomsTabView(rooms: Room.sampleRooms)
    }
    .background(Theme.background)
}

// MARK: - Sample Data Extension
extension Room {
    static let sampleRooms: [Room] = [
        Room(
            name: "Grand Majlis",
            area: 65,
            floor: 1,
            purpose: .majlis,
            features: ["Traditional seating", "Arabic calligraphy", "Central chandelier"],
            ventilation: "Natural cross ventilation with mashrabiya",
            lighting: "LED with traditional lantern accents"
        ),
        Room(
            name: "Master Bedroom",
            area: 45,
            floor: 2,
            purpose: .bedroom,
            features: ["Walk-in closet", "En-suite bathroom", "Private balcony"],
            ventilation: "Centralized AC with fresh air intake",
            lighting: "Dimmable warm white LEDs"
        ),
        Room(
            name: "Modern Kitchen",
            area: 38,
            floor: 1,
            purpose: .kitchen,
            features: ["Island seating", "Smart appliances", "Pantry storage"],
            ventilation: "Exhaust hood with air purification",
            lighting: "Task lighting with under-cabinet LEDs"
        ),
        Room(
            name: "Family Living",
            area: 52,
            floor: 1,
            purpose: .living,
            features: ["Entertainment center", "Floor-to-ceiling windows", "Fireplace"],
            ventilation: "Natural ventilation with ceiling fans",
            lighting: "Layered lighting with dimmers"
        ),
        Room(
            name: "Prayer Room",
            area: 18,
            floor: 2,
            purpose: .prayer,
            features: ["Qibla indicator", "Ablution area", "Storage for Quran"],
            ventilation: "Dedicated fresh air system",
            lighting: "Soft directional lighting"
        )
    ]
}
