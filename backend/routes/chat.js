//
//  AI Chat Routes
//  Architecture assistant chat functionality
//

const express = require('express');
const router = express.Router();
const Joi = require('joi');
const { OpenAI } = require('openai');
require('dotenv').config();

// Initialize OpenAI
const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY,
});

// Validation Schemas
const chatMessageSchema = Joi.object({
    messages: Joi.array().items(
        Joi.object({
            id: Joi.string().optional(),
            role: Joi.string().valid('user', 'assistant').required(),
            content: Joi.string().required().min(1).max(2000)
        })
    ).min(1).required()
});

// POST /api/chat/architecture
// Chat with AI architecture assistant
router.post('/architecture', async (req, res, next) => {
    try {
        // Validate input
        const { error, value } = chatMessageSchema.validate(req.body);
        if (error) {
            const validationError = new Error('Validation failed');
            validationError.name = 'ValidationError';
            validationError.details = error.details;
            return next(validationError);
        }

        const { messages } = value;

        console.log(`💬 Chat request with ${messages.length} messages`);

        // Create system prompt for architecture assistant
        const systemPrompt = `You are an expert Saudi architecture assistant with deep knowledge of:

🏗️ **Architecture Expertise:**
- Traditional Najdi architecture and construction methods
- Modern Saudi architectural trends
- Islamic design principles and elements
- Mediterranean and contemporary styles
- Local Saudi building materials and suppliers
- Climate-adapted design for Saudi Arabia
- Building codes and regulations in Saudi cities
- Cultural considerations for Saudi families

🏛️ **Cultural Context:**
- Understand importance of privacy (separate majlis for men/women)
- Knowledge of prayer room requirements and orientation
- Familiarity with courtyard designs and natural ventilation
- Understanding of Saudi family structures and hospitality spaces
- Knowledge of traditional materials like mud brick, limestone, coral stone

🌡️ **Climate Adaptation:**
- Expertise in passive cooling for desert climate
- Knowledge of wind towers and natural ventilation
- Understanding of solar protection and shading techniques
- Familiarity with water conservation in arid regions
- Knowledge of modern HVAC integration with traditional aesthetics

💰 **Cost & Materials:**
- Current Saudi construction costs and market rates
- Local suppliers and material availability
- Sustainable and traditional material options
- Budget optimization for different economic levels
- Understanding of luxury vs. practical material choices

🏙️ **Modern Integration:**
- Smart home technology integration
- Energy efficiency and solar solutions
- Modern amenities while preserving cultural authenticity
- International building standards compliance
- Sustainable and green building practices

Always provide responses that are:
- Culturally sensitive and appropriate for Saudi context
- Practically applicable with specific, actionable advice
- Respectful of traditional values while embracing modern solutions
- Detailed and thorough with examples when helpful
- Cost-conscious and realistic about implementation challenges

Format responses clearly with relevant examples and specific recommendations for Saudi architecture projects.`;

        // Prepare messages for OpenAI
        const chatMessages = [
            {
                role: 'system',
                content: systemPrompt
            },
            ...messages.map(msg => ({
                role: msg.role,
                content: msg.content
            }))
        ];

        // Call OpenAI API
        const completion = await openai.chat.completions.create({
            model: 'gpt-4',
            messages: chatMessages,
            max_tokens: 1500,
            temperature: 0.7,
            presence_penalty: 0.1,
            frequency_penalty: 0.1
        });

        const aiResponse = completion.choices[0].message.content;

        console.log(`✅ Chat response generated (${aiResponse.length} characters)`);

        res.json({
            success: true,
            data: {
                id: require('uuid').v4(),
                role: 'assistant',
                content: aiResponse,
                timestamp: new Date().toISOString(),
                model: 'gpt-4',
                usage: completion.usage
            },
            timestamp: new Date().toISOString()
        });

    } catch (error) {
        console.error('Chat generation error:', error);
        
        // Handle OpenAI specific errors
        if (error.status === 429) {
            error.message = 'OpenAI rate limit exceeded. Please try again later.';
            error.status = 429;
        } else if (error.status === 401) {
            error.message = 'Invalid OpenAI API key.';
            error.status = 401;
        }

        next(error);
    }
});

// POST /api/chat/quick-advice
// Get quick architecture advice
router.post('/quick-advice', async (req, res, next) => {
    try {
        const { topic, context } = req.body;

        if (!topic) {
            const error = new Error('Topic is required');
            error.name = 'ValidationError';
            return next(error);
        }

        const quickPrompt = `As a Saudi architecture expert, provide concise but comprehensive advice about: ${topic}

${context ? `Context: ${context}` : ''}

Provide practical, actionable advice specific to Saudi architecture and construction. Include cultural considerations where relevant.`;

        const completion = await openai.chat.completions.create({
            model: 'gpt-4',
            messages: [
                {
                    role: 'system',
                    content: 'You are a Saudi architecture expert providing quick, practical advice.'
                },
                {
                    role: 'user',
                    content: quickPrompt
                }
            ],
            max_tokens: 800,
            temperature: 0.7
        });

        const advice = completion.choices[0].message.content;

        res.json({
            success: true,
            data: {
                topic,
                advice,
                context,
                timestamp: new Date().toISOString()
            }
        });

    } catch (error) {
        console.error('Quick advice error:', error);
        next(error);
    }
});

// POST /api/chat/style-recommendation
// Get architecture style recommendations
router.post('/style-recommendation', async (req, res, next) => {
    try {
        const { preferences, location, budget } = req.body;

        const recommendationPrompt = `Based on the following requirements, recommend the most suitable Saudi architecture style:

Preferences: ${preferences || 'Not specified'}
Location: ${location || 'Saudi Arabia'}
Budget Level: ${budget || 'Not specified'}

Consider these Saudi architecture styles:
1. Modern Saudi - Contemporary with traditional elements
2. Traditional Najdi - Authentic desert architecture
3. Mediterranean - Coastal, open design
4. Contemporary - International modern style
5. Islamic - Religious and cultural elements
6. Luxury Villa - High-end modern design
7. Palace - Grand, formal architecture

Provide a detailed recommendation with:
- Recommended style with reasoning
- Key features of this style
- Adaptation to the specified location and budget
- Cultural considerations
- Materials that work well with this style
- Potential challenges and solutions`;

        const completion = await openai.chat.completions.create({
            model: 'gpt-4',
            messages: [
                {
                    role: 'system',
                    content: 'You are an expert in Saudi architecture styles and recommendations.'
                },
                {
                    role: 'user',
                    content: recommendationPrompt
                }
            ],
            max_tokens: 1200,
            temperature: 0.7
        });

        const recommendation = completion.choices[0].message.content;

        res.json({
            success: true,
            data: {
                recommendation,
                preferences,
                location,
                budget,
                timestamp: new Date().toISOString()
            }
        });

    } catch (error) {
        console.error('Style recommendation error:', error);
        next(error);
    }
});

// POST /api/chat/material-advice
// Get material recommendations for specific use case
router.post('/material-advice', async (req, res, next) => {
    try {
        const { useCase, location, budget, sustainability } = req.body;

        const materialPrompt = `As a Saudi construction materials expert, recommend materials for:

Use Case: ${useCase || 'General construction'}
Location: ${location || 'Saudi Arabia'}
Budget Level: ${budget || 'Medium'}
Sustainability Priority: ${sustainability || 'Medium'}

Consider:
- Local Saudi materials and suppliers
- Climate-appropriate materials for desert environment
- Traditional vs. modern material options
- Cost-effectiveness and availability
- Sustainability and environmental impact
- Durability and maintenance requirements
- Cultural appropriateness

Provide specific material recommendations with:
- Material names and types
- Pros and cons for each material
- Estimated costs in SAR
- Local availability in Saudi market
- Installation considerations
- Maintenance requirements`;

        const completion = await openai.chat.completions.create({
            model: 'gpt-4',
            messages: [
                {
                    role: 'system',
                    content: 'You are an expert in Saudi construction materials with deep knowledge of local suppliers and climate considerations.'
                },
                {
                    role: 'user',
                    content: materialPrompt
                }
            ],
            max_tokens: 1000,
            temperature: 0.7
        });

        const materialAdvice = completion.choices[0].message.content;

        res.json({
            success: true,
            data: {
                materialAdvice: materialAdvice,
                useCase,
                location,
                budget,
                sustainability,
                timestamp: new Date().toISOString()
            }
        });

    } catch (error) {
        console.error('Material advice error:', error);
        next(error);
    }
});

module.exports = router;
