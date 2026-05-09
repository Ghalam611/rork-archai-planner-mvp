import React, { useState } from 'react';
import { View, Text, ScrollView, TouchableOpacity, TextInput, StyleSheet } from 'react-native';
import { useTheme } from '@/theme/ThemeContext';
import { useLoading } from '@/services/LoadingContext';

interface Message {
  id: string;
  role: 'user' | 'assistant';
  content: string;
  timestamp: string;
}

export default function ChatScreen({ navigation }: any) {
  const { theme } = useTheme();
  const { showLoading, hideLoading } = useLoading();
  const [messages, setMessages] = useState<Message[]>([]);
  const [inputText, setInputText] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const quickQuestions = [
    'What are the key features of Modern Saudi architecture?',
    'How do I design for Saudi climate?',
    'What materials work best in Saudi Arabia?',
    'How can I incorporate traditional elements in modern design?',
    'What are the latest trends in Saudi architecture?',
  ];

  const handleSendMessage = async () => {
    if (!inputText.trim()) return;

    const userMessage: Message = {
      id: Date.now().toString(),
      role: 'user',
      content: inputText.trim(),
      timestamp: new Date().toISOString(),
    };

    setMessages(prev => [...prev, userMessage]);
    setInputText('');
    setIsLoading(true);

    try {
      // Mock AI response - replace with real API call
      await new Promise(resolve => setTimeout(resolve, 2000));
      
      const aiMessage: Message = {
        id: (Date.now() + 1).toString(),
        role: 'assistant',
        content: generateAIResponse(inputText.trim()),
        timestamp: new Date().toISOString(),
      };

      setMessages(prev => [...prev, aiMessage]);
    } catch (error) {
      console.error('Error sending message:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const handleQuickQuestion = (question: string) => {
    setInputText(question);
  };

  const generateAIResponse = (userInput: string): string => {
    // Mock AI responses based on common questions
    if (userInput.toLowerCase().includes('modern saudi')) {
      return 'Modern Saudi architecture combines traditional Islamic design elements with contemporary building technologies. Key features include:\n\n• Clean geometric forms with traditional patterns\n• Use of local materials like limestone and coral stone\n• Integration of smart home technology\n• Energy-efficient design for desert climate\n• Courtyard designs adapted for modern living\n• Mashrabiya screens for privacy and decoration';
    }
    
    if (userInput.toLowerCase().includes('climate')) {
      return 'For Saudi climate adaptation, consider:\n\n• Thick walls for insulation\n• Small windows with deep overhangs for shade\n• Courtyard layouts for natural ventilation\n• Wind towers for passive cooling\n• Light-colored exteriors to reflect heat\n• Shaded outdoor spaces\n• Water features for evaporative cooling';
    }
    
    if (userInput.toLowerCase().includes('materials')) {
      return 'Recommended materials for Saudi construction:\n\n• Saudi limestone - excellent thermal properties\n• Coral stone - traditional coastal building\n• Palm wood - decorative elements\n• Modern composites - durability and efficiency\n• Solar-reflective materials\n• Local clay bricks - sustainability';
    }
    
    return 'That\'s an excellent question about Saudi architecture! As an AI assistant specializing in Saudi architectural design, I can help you with:\n\n• Traditional and modern Saudi architectural styles\n• Climate-appropriate design solutions\n• Local material recommendations\n• Cultural and religious considerations\n• Building code compliance\n• Sustainable design practices\n\nWhat specific aspect of Saudi architecture would you like to explore?';
  };

  const renderMessage = (message: Message) => (
    <View
      style={[
        styles.messageContainer,
        message.role === 'user' ? styles.userMessage : styles.aiMessage
      ]}
    >
      <Text
        style={[
          styles.messageText,
          { color: message.role === 'user' ? theme.colors.text : theme.colors.text }
        ]}
      >
        {message.content}
      </Text>
      <Text
        style={[styles.messageTime, { color: theme.colors.textSecondary }]}
      >
        {new Date(message.timestamp).toLocaleTimeString()}
      </Text>
    </View>
  );

  return (
    <View style={[styles.container, { backgroundColor: theme.colors.background }]}>
      {/* Header */}
      <View style={styles.header}>
        <Text style={[styles.title, { color: theme.colors.text }]}>
          AI Architecture Assistant
        </Text>
        <Text style={[styles.subtitle, { color: theme.colors.textSecondary }]}>
          Ask me anything about Saudi architecture
        </Text>
      </View>

      {/* Quick Questions */}
      <View style={styles.quickQuestions}>
        <Text style={[styles.sectionTitle, { color: theme.colors.text }]}>
          Quick Questions
        </Text>
        <ScrollView horizontal showsHorizontalScrollIndicator={false} style={styles.questionsScroll}>
          {quickQuestions.map((question, index) => (
            <TouchableOpacity
              key={index}
              style={[styles.questionChip, { backgroundColor: theme.colors.surface }]}
              onPress={() => handleQuickQuestion(question)}
            >
              <Text style={[styles.questionText, { color: theme.colors.primary }]}>
                {question}
              </Text>
            </TouchableOpacity>
          ))}
        </ScrollView>
      </View>

      {/* Messages */}
      <ScrollView style={styles.messagesContainer} showsVerticalScrollIndicator={false}>
        {messages.map(renderMessage)}
      </ScrollView>

      {/* Input */}
      <View style={styles.inputContainer}>
        <TextInput
          style={[
            styles.textInput,
            { color: theme.colors.text, borderColor: theme.colors.border }
          ]}
          placeholder="Ask about Saudi architecture..."
          placeholderTextColor={theme.colors.textSecondary}
          value={inputText}
          onChangeText={setInputText}
          multiline
          numberOfLines={3}
          editable={!isLoading}
        />
        <TouchableOpacity
          style={[
            styles.sendButton,
            { backgroundColor: inputText.trim() ? theme.colors.primary : theme.colors.surface }
          ]}
          onPress={handleSendMessage}
          disabled={!inputText.trim() || isLoading}
        >
          <Text
            style={[
              styles.sendButtonText,
              { color: inputText.trim() ? theme.colors.text : theme.colors.textSecondary }
            ]}
          >
            {isLoading ? '...' : 'Send'}
          </Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  header: {
    padding: 24,
    paddingBottom: 16,
    borderBottomWidth: 1,
    borderBottomColor: '#3a3a3a',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 4,
  },
  subtitle: {
    fontSize: 14,
  },
  quickQuestions: {
    marginBottom: 16,
  },
  sectionTitle: {
    fontSize: 16,
    fontWeight: '600',
    marginBottom: 12,
  },
  questionsScroll: {
    paddingHorizontal: 24,
  },
  questionChip: {
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderRadius: 20,
    marginRight: 8,
    borderWidth: 1,
    borderColor: '#3a3a3a',
  },
  questionText: {
    fontSize: 12,
    fontWeight: '500',
  },
  messagesContainer: {
    flex: 1,
    paddingHorizontal: 24,
    marginBottom: 16,
  },
  messageContainer: {
    marginBottom: 16,
    maxWidth: '80%',
  },
  userMessage: {
    alignSelf: 'flex-end',
    backgroundColor: '#D4AF37',
    borderTopLeftRadius: 16,
    borderTopRightRadius: 16,
    borderBottomLeftRadius: 4,
    borderBottomRightRadius: 16,
  },
  aiMessage: {
    alignSelf: 'flex-start',
    backgroundColor: '#2a2a2a',
    borderTopLeftRadius: 16,
    borderTopRightRadius: 16,
    borderBottomLeftRadius: 16,
    borderBottomRightRadius: 4,
    borderWidth: 1,
    borderColor: '#3a3a3a',
  },
  messageText: {
    fontSize: 14,
    lineHeight: 20,
    padding: 12,
  },
  messageTime: {
    fontSize: 10,
    paddingHorizontal: 12,
    paddingBottom: 4,
  },
  inputContainer: {
    flexDirection: 'row',
    padding: 16,
    borderTopWidth: 1,
    borderTopColor: '#3a3a3a',
    alignItems: 'flex-end',
    gap: 8,
  },
  textInput: {
    flex: 1,
    borderWidth: 1,
    borderRadius: 12,
    padding: 12,
    fontSize: 14,
    maxHeight: 100,
    backgroundColor: '#2a2a2a',
  },
  sendButton: {
    paddingHorizontal: 20,
    paddingVertical: 12,
    borderRadius: 12,
  },
  sendButtonText: {
    fontSize: 14,
    fontWeight: '600',
  },
});
