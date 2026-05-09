//
//  ModernTextField.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct ModernTextField: View {
    @Binding var text: String
    let title: String
    let icon: String
    let placeholder: String?
    let isSecure: Bool
    let keyboardType: UIKeyboardType
    let autocapitalization: TextInputAutocapitalization
    
    @State private var isFocused = false
    @State private var showPassword = false
    
    init(
        _ title: String,
        text: Binding<String>,
        icon: String,
        placeholder: String? = nil,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        autocapitalization: TextInputAutocapitalization = .never
    ) {
        self._text = text
        self.title = title
        self.icon = icon
        self.placeholder = placeholder
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.autocapitalization = autocapitalization
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
            Text(title)
                .font(Theme.Typography.caption1)
                .fontWeight(.medium)
                .foregroundStyle(Theme.textSecondary)
            
            HStack(spacing: Theme.Spacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(isFocused ? Theme.saudiGold : Theme.textTertiary)
                    .animation(.easeInOut(duration: 0.2), value: isFocused)
                
                Group {
                    if isSecure && !showPassword {
                        SecureField(placeholder ?? title, text: $text)
                    } else {
                        TextField(placeholder ?? title, text: $text)
                    }
                }
                .keyboardType(keyboardType)
                .textInputAutocapitalization(autocapitalization)
                .font(Theme.Typography.body)
                .foregroundStyle(Theme.textPrimary)
                .onTapGesture {
                    isFocused = true
                }
                
                if isSecure {
                    Button(action: {
                        showPassword.toggle()
                    }) {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Theme.textTertiary)
                    }
                }
            }
            .padding(Theme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                    .fill(isFocused ? Theme.surfaceLight : Theme.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                            .stroke(
                                isFocused ? Theme.saudiGold : Theme.border,
                                lineWidth: isFocused ? 2 : 1
                            )
                    )
                    .animation(.easeInOut(duration: 0.2), value: isFocused)
            )
        }
        .onTapGesture {
            isFocused = true
        }
    }
}

struct ModernTextEditor: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    let minHeight: CGFloat
    
    @State private var isFocused = false
    
    init(
        _ title: String,
        text: Binding<String>,
        placeholder: String = "",
        minHeight: CGFloat = 120
    ) {
        self._text = text
        self.title = title
        self.placeholder = placeholder
        self.minHeight = minHeight
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
            Text(title)
                .font(Theme.Typography.caption1)
                .fontWeight(.medium)
                .foregroundStyle(Theme.textSecondary)
            
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(Theme.Typography.body)
                        .foregroundStyle(Theme.textTertiary)
                        .padding(Theme.Spacing.md)
                }
                
                TextEditor(text: $text)
                    .font(Theme.Typography.body)
                    .foregroundStyle(Theme.textPrimary)
                    .scrollContentBackground(.hidden)
                    .padding(Theme.Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                            .fill(isFocused ? Theme.surfaceLight : Theme.surface)
                            .overlay(
                                RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                                    .stroke(
                                        isFocused ? Theme.saudiGold : Theme.border,
                                        lineWidth: isFocused ? 2 : 1
                                    )
                            )
                            .animation(.easeInOut(duration: 0.2), value: isFocused)
                    )
                    .onTapGesture {
                        isFocused = true
                    }
            }
            .frame(minHeight: minHeight)
        }
    }
}
