//
//  ChatView.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

struct ChatView: View {
    @Bindable var appState: AppState
    @State private var question: String = ""
    @State private var messages: [ChatBubbleMessage] = [
        ChatBubbleMessage(role: .ai, text: "Hi, I'm your AI architect. Ask me about layouts, privacy, facades, lighting, or material choices.")
    ]
    @State private var isThinking: Bool = false

    var body: some View {
        ZStack {
            LuxuryBackground()
            VStack(spacing: 14) {
                HeaderBlock(title: "AI Chat Assistant", subtitle: "Fast guidance for planning decisions and design tradeoffs.")
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(messages) { message in
                                ChatBubble(message: message)
                                    .id(message.id)
                            }
                            if isThinking {
                                HStack(spacing: 8) {
                                    ProgressView().tint(Theme.gold)
                                    Text("ArchAI is thinking...")
                                        .font(.caption)
                                        .foregroundStyle(.white.opacity(0.6))
                                }
                                .padding(.horizontal, 14)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .onChange(of: messages.count) { _, _ in
                        if let last = messages.last {
                            withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                        }
                    }
                }
                HStack(spacing: 10) {
                    TextField("Ask a question", text: $question)
                        .textFieldStyle(.plain)
                        .padding(14)
                        .background(.white.opacity(0.08), in: .rect(cornerRadius: 16))
                        .foregroundStyle(.white)
                    Button {
                        send()
                    } label: {
                        Image(systemName: "arrow.up")
                            .font(.headline)
                            .frame(width: 48, height: 48)
                    }
                    .buttonStyle(GoldIconButtonStyle())
                    .disabled(question.trimmingCharacters(in: .whitespaces).isEmpty || isThinking)
                }
                .padding(20)
            }
        }
        .navigationTitle("AI Chat")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func send() {
        let text = question.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }
        messages.append(ChatBubbleMessage(role: .user, text: text))
        question = ""
        isThinking = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            isThinking = false
            messages.append(ChatBubbleMessage(role: .ai, text: "Separate guest circulation with a direct majlis route from the entry court, then use a screened transition before family spaces. Keep service paths behind dining and kitchen for clean operation."))
        }
    }
}

struct ChatBubble: View {
    let message: ChatBubbleMessage

    var body: some View {
        HStack {
            if message.role == .user { Spacer(minLength: 40) }
            Text(message.text)
                .foregroundStyle(message.role == .user ? .black : .white.opacity(0.88))
                .padding(14)
                .background(
                    message.role == .user
                    ? AnyShapeStyle(Theme.goldGradient)
                    : AnyShapeStyle(Color.white.opacity(0.07)),
                    in: .rect(cornerRadius: 18)
                )
            if message.role == .ai { Spacer(minLength: 40) }
        }
    }
}
