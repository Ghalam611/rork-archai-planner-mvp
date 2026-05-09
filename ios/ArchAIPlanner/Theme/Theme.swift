//
//  Theme.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

enum Theme {
    // MARK: - Saudi Architecture Inspired Palette
    static let saudiGold = Color(red: 0.86, green: 0.68, blue: 0.34)
    static let desertSand = Color(red: 0.94, green: 0.87, blue: 0.78)
    static let deepOchre = Color(red: 0.65, green: 0.45, blue: 0.16)
    static let warmStone = Color(red: 0.82, green: 0.76, blue: 0.68)
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
    
    // MARK: - Semantic Colors
    static let primary = saudiGold
    static let secondary = warmStone
    static let background = Color.black
    static let surface = Color(red: 0.05, green: 0.045, blue: 0.035)
    static let surfaceLight = Color(red: 0.12, green: 0.11, blue: 0.10)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.72)
    static let textTertiary = Color.white.opacity(0.45)
    static let border = Color.white.opacity(0.12)
    static let overlay = Color.black.opacity(0.4)
    
    // MARK: - Gradients
    static let goldGradient = LinearGradient(
        colors: [
            Color(red: 0.98, green: 0.86, blue: 0.52),
            Color(red: 0.86, green: 0.68, blue: 0.34),
            Color(red: 0.65, green: 0.45, blue: 0.16)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let luxuryCardGradient = LinearGradient(
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
            saudiGold.opacity(0.3),
            accentEmerald.opacity(0.2),
            accentCopper.opacity(0.15)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - Typography
    enum Typography {
        static let largeTitle = Font.system(size: 40, weight: .bold, design: .serif)
        static let title1 = Font.system(size: 34, weight: .bold, design: .serif)
        static let title2 = Font.system(size: 28, weight: .semibold, design: .serif)
        static let title3 = Font.system(size: 22, weight: .semibold)
        static let headline = Font.system(size: 20, weight: .semibold)
        static let body = Font.system(size: 17, weight: .regular)
        static let callout = Font.system(size: 16, weight: .regular)
        static let subheadline = Font.system(size: 15, weight: .medium)
        static let footnote = Font.system(size: 13, weight: .regular)
        static let caption1 = Font.system(size: 12, weight: .medium)
        static let caption2 = Font.system(size: 11, weight: .medium)
    }
    
    // MARK: - Spacing
    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
        static let xxxl: CGFloat = 64
    }
    
    // MARK: - Corner Radius
    enum CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xlarge: CGFloat = 20
        static let xxlarge: CGFloat = 24
        static let xxxlarge: CGFloat = 28
    }
    
    // MARK: - Shadows
    enum Shadow {
        static let small = Color.black.opacity(0.1)
        static let medium = Color.black.opacity(0.2)
        static let large = Color.black.opacity(0.3)
        static let gold = saudiGold.opacity(0.25)
        static let card = Color.black.opacity(0.15)
    }
}
