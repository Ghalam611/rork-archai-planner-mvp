//
//  HapticFeedback.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

// MARK: - Haptic Feedback Manager
class HapticFeedbackManager {
    static let shared = HapticFeedbackManager()
    
    private init() {}
    
    // MARK: - Basic Haptics
    func light() {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
    
    func medium() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
    
    func heavy() {
        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.impactOccurred()
    }
    
    // MARK: - Selection Haptics
    func selection() {
        let selection = UISelectionFeedbackGenerator()
        selection.selectionChanged()
    }
    
    // MARK: - Notification Haptics
    func success() {
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.success)
    }
    
    func warning() {
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.warning)
    }
    
    func error() {
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.error)
    }
    
    // MARK: - Custom Haptics
    func custom(intensity: Float, sharpness: Float) {
        if #available(iOS 13.0, *) {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred(intensity: intensity, sharpness: sharpness)
        }
    }
}

// MARK: - SwiftUI View Modifier
struct HapticFeedback: ViewModifier {
    let trigger: Any
    let type: HapticType
    
    func body(content: Content) -> some View {
        content
            .onChange(of: trigger) { _, _ in
                switch type {
                case .light:
                    HapticFeedbackManager.shared.light()
                case .medium:
                    HapticFeedbackManager.shared.medium()
                case .heavy:
                    HapticFeedbackManager.shared.heavy()
                case .selection:
                    HapticFeedbackManager.shared.selection()
                case .success:
                    HapticFeedbackManager.shared.success()
                case .warning:
                    HapticFeedbackManager.shared.warning()
                case .error:
                    HapticFeedbackManager.shared.error()
                }
            }
    }
}

extension View {
    func hapticFeedback(_ type: HapticType, trigger: Any) -> some View {
        self.modifier(HapticFeedback(trigger: trigger, type: type))
    }
}

enum HapticType {
    case light, medium, heavy, selection, success, warning, error
}

// MARK: - Sensory Feedback Wrapper
struct SensoryFeedbackWrapper: ViewModifier {
    let trigger: Any
    let feedback: SensoryFeedback
    
    func body(content: Content) -> some View {
        content
            .sensoryFeedback(feedback, trigger: trigger)
    }
}

extension View {
    func sensoryFeedbackWrapper(_ feedback: SensoryFeedback, trigger: Any) -> some View {
        self.modifier(SensoryFeedbackWrapper(trigger: trigger, feedback: feedback))
    }
}
