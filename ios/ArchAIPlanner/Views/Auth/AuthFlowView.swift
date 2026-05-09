//
//  AuthFlowView.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct AuthFlowView: View {
    @Bindable var appState: AppState
    @State private var isSignup: Bool = false
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""

    var body: some View {
        ZStack {
            LuxuryBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    Spacer(minLength: 56)
                    VStack(alignment: .leading, spacing: 14) {
                        Text("ArchAI")
                            .font(.system(size: 54, weight: .black, design: .serif))
                            .foregroundStyle(Theme.goldGradient)
                        Text("Planner")
                            .font(.system(size: 46, weight: .semibold, design: .serif))
                            .foregroundStyle(.white)
                        Text("Generate architectural concepts, early layouts, room distributions, and refined villa ideas with AI.")
                            .font(.title3)
                            .foregroundStyle(.white.opacity(0.72))
                            .lineSpacing(4)
                    }

                    VStack(spacing: 14) {
                        if isSignup {
                            LuxuryTextField(title: "Full name", text: $name, icon: "person")
                        }
                        LuxuryTextField(title: "Email", text: $email, icon: "envelope")
                        LuxurySecureField(title: "Password", text: $password, icon: "lock")

                        Button {
                            appState.userName = name.isEmpty ? "Founder" : name
                            appState.isAuthenticated = true
                        } label: {
                            Text(isSignup ? "Create account" : "Enter studio")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(GoldButtonStyle())

                        Button {
                            withAnimation(.spring(response: 0.38, dampingFraction: 0.86)) {
                                isSignup.toggle()
                            }
                        } label: {
                            Text(isSignup ? "Already have an account? Login" : "New here? Create an account")
                                .font(.callout.weight(.medium))
                                .foregroundStyle(Theme.gold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                        }
                    }
                    .padding(18)
                    .background(.white.opacity(0.06), in: .rect(cornerRadius: 28))
                    .overlay(.white.opacity(0.12), in: .rect(cornerRadius: 28).stroke(lineWidth: 1))
                }
                .padding(22)
            }
        }
    }
}
