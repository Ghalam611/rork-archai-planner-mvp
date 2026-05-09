//
//  Theme.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

enum Theme {
    // MARK: - Premium Saudi Architecture Palette
    static let royalGold = Color(red: 0.92, green: 0.76, blue: 0.42)
    static let saudiGold = Color(red: 0.86, green: 0.68, blue: 0.34)
    static let antiqueGold = Color(red: 0.78, green: 0.62, blue: 0.28)
    static let desertSand = Color(red: 0.94, green: 0.87, blue: 0.78)
    static let warmStone = Color(red: 0.82, green: 0.76, blue: 0.68)
    static let deepOchre = Color(red: 0.65, green: 0.45, blue: 0.16)
    static let midnightBlue = Color(red: 0.08, green: 0.12, blue: 0.20)
    static let richMaroon = Color(red: 0.52, green: 0.15, blue: 0.15)
    static let pearlWhite = Color(red: 0.98, green: 0.97, blue: 0.95)
    static let shadowGray = Color(red: 0.25, green: 0.25, blue: 0.28)
    
    // MARK: - Modern Architecture Colors
    static let concrete = Color(red: 0.45, green: 0.45, blue: 0.48)
    static let steel = Color(red: 0.70, green: 0.72, blue: 0.75)
    static let glass = Color(red: 0.88, green: 0.90, blue: 0.92)
    static let accentEmerald = Color(red: 0.20, green: 0.78, blue: 0.65)
    static let accentCopper = Color(red: 0.88, green: 0.45, blue: 0.25)
    static let accentSapphire = Color(red: 0.15, green: 0.45, blue: 0.85)
    static let accentAmber = Color(red: 0.95, green: 0.65, blue: 0.25)
    
    // MARK: - Semantic Colors
    static let primary = royalGold
    static let secondary = warmStone
    static let background = Color.black
    static let surface = Color(red: 0.05, green: 0.045, blue: 0.035)
    static let surfaceLight = Color(red: 0.12, green: 0.11, blue: 0.10)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.72)
    static let textTertiary = Color.white.opacity(0.45)
    static let border = Color.white.opacity(0.12)
    static let overlay = Color.black.opacity(0.4)
    
    // MARK: - Premium Gradients
    static let royalGoldGradient = LinearGradient(
        colors: [
            Color(red: 0.98, green: 0.92, blue: 0.68),
            royalGold,
            Color(red: 0.78, green: 0.62, blue: 0.28)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let goldGradient = LinearGradient(
        colors: [
            Color(red: 0.98, green: 0.86, blue: 0.52),
            saudiGold,
            Color(red: 0.65, green: 0.45, blue: 0.16)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let luxuryCardGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.15),
            Color.white.opacity(0.08),
            Color.white.opacity(0.03)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let glassmorphismGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.12),
            Color.white.opacity(0.06),
            Color.white.opacity(0.02)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color.black,
            Color(red: 0.05, green: 0.045, blue: 0.035),
            Color(red: 0.11, green: 0.085, blue: 0.045)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let auroraGradient = LinearGradient(
        colors: [
            royalGold.opacity(0.3),
            accentSapphire.opacity(0.2),
            accentAmber.opacity(0.15)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let surfaceGradient = LinearGradient(
        colors: [
            surface,
            surfaceLight,
            Color(red: 0.15, green: 0.14, blue: 0.13)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - Elegant Typography
    enum Typography {
        // Display & Headers
        static let largeTitle = Font.system(size: 44, weight: .black, design: .serif)
        static let title1 = Font.system(size: 38, weight: .bold, design: .serif)
        static let title2 = Font.system(size: 32, weight: .semibold, design: .serif)
        static let title3 = Font.system(size: 26, weight: .semibold)
        static let headline = Font.system(size: 22, weight: .semibold)
        
        // Body Text
        static let body = Font.system(size: 18, weight: .regular)
        static let bodyLarge = Font.system(size: 20, weight: .medium)
        static let callout = Font.system(size: 17, weight: .regular)
        static let subheadline = Font.system(size: 16, weight: .medium)
        
        // Small Text
        static let footnote = Font.system(size: 14, weight: .regular)
        static let caption1 = Font.system(size: 13, weight: .semibold)
        static let caption2 = Font.system(size: 12, weight: .medium)
        static let caption3 = Font.system(size: 11, weight: .medium)
        
        // Elegant Variants
        static let elegantTitle = Font.system(size: 36, weight: .light, design: .serif)
        static let luxuryBody = Font.system(size: 17, weight: .light)
        static let refinedCaption = Font.system(size: 12, weight: .regular)
    }
    
    // MARK: - Premium Spacing
    enum Spacing {
        static let xs: CGFloat = 2
        static let sm: CGFloat = 6
        static let md: CGFloat = 12
        static let lg: CGFloat = 20
        static let xl: CGFloat = 28
        static let xxl: CGFloat = 40
        static let xxxl: CGFloat = 56
        static let xxxxl: CGFloat = 72
    }
    
    // MARK: - Premium Corner Radius
    enum CornerRadius {
        static let xs: CGFloat = 4
        static let small: CGFloat = 6
        static let medium: CGFloat = 10
        static let large: CGFloat = 14
        static let xlarge: CGFloat = 18
        static let xxlarge: CGFloat = 22
        static let xxxlarge: CGFloat = 26
        static let xxxxlarge: CGFloat = 32
    }
    
    // MARK: - Premium Shadows
    enum Shadow {
        static let xs = Color.black.opacity(0.05)
        static let small = Color.black.opacity(0.1)
        static let medium = Color.black.opacity(0.2)
        static let large = Color.black.opacity(0.3)
        static let xl = Color.black.opacity(0.4)
        static let royalGold = royalGold.opacity(0.3)
        static let gold = saudiGold.opacity(0.25)
        static let card = Color.black.opacity(0.15)
        static let premium = Color.black.opacity(0.25)
        static let glass = Color.white.opacity(0.1)
    }
}
