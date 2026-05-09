//
//  Architecture Generation Routes
//  AI-powered architecture design generation
//

const express = require('express');
const router = express.Router();
const Joi = require('joi');
const { OpenAI } = require('openai');
const { createClient } = require('@supabase/supabase-js');
require('dotenv').config();

// Initialize OpenAI
const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY,
});

// Initialize Supabase
const supabase = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
);

// Validation Schemas
const architecturePromptSchema = Joi.object({
    projectName: Joi.string().required().min(1).max(100),
    clientName: Joi.string().optional().max(100),
    location: Joi.string().required().min(1).max(200),
    plotSize: Joi.number().required().min(100).max(100000),
    totalArea: Joi.number().required().min(50).max(10000),
    floors: Joi.number().integer().required().min(1).max(10),
    style: Joi.string().required().valid(
        'Modern Saudi',
        'Traditional Najdi',
        'Mediterranean',
        'Contemporary',
        'Islamic',
        'Luxury Villa',
        'Palace'
    ),
    requirements: Joi.string().optional().max(1000)
});

// POST /api/architecture/generate
// Generate complete architecture design with AI
router.post('/generate', async (req, res, next) => {
    try {
        // Validate input
        const { error, value } = architecturePromptSchema.validate(req.body);
        if (error) {
            const validationError = new Error('Validation failed');
            validationError.name = 'ValidationError';
            validationError.details = error.details;
            return next(validationError);
        }

        const {
            projectName,
            clientName,
            location,
            plotSize,
            totalArea,
            floors,
            style,
            requirements
        } = value;

        console.log(`🏗️ Generating architecture: ${projectName} in ${location}`);

        // Create comprehensive prompt for OpenAI
        const systemPrompt = `You are an expert Saudi architect specializing in both traditional and modern architecture. You have deep knowledge of:

- Saudi architectural styles (Modern Saudi, Traditional Najdi, Mediterranean, Islamic, Luxury Villa, Palace)
- Local climate considerations for Saudi Arabia
- Traditional materials and construction methods
- Islamic design principles and cultural elements
- Modern building technologies and sustainability
- Local building codes and regulations

Generate a complete, detailed architecture design that is both culturally authentic and functionally modern.`;

        const userPrompt = `Generate a complete architecture design for the following project:

Project Name: ${projectName}
Client: ${clientName || 'Private Client'}
Location: ${location}
Plot Size: ${plotSize} m²
Total Area: ${totalArea} m²
Floors: ${floors}
Style: ${style}
Special Requirements: ${requirements || 'None specified'}

Please provide a comprehensive architecture design including:

1. **Design Concept**: Overall vision and approach
2. **Room Layout**: Detailed room distribution with sizes and purposes
3. **Materials Recommendations**: Local Saudi materials and modern alternatives
4. **Cultural Elements**: Traditional Saudi architectural features
5. **Sustainability Features**: Energy efficiency and environmental considerations
6. **Budget Estimation**: Detailed cost breakdown in SAR
7. **Timeline**: Construction phases and duration

Format your response as a complete JSON object with the following structure:
{
    "concept": "Overall design concept and vision",
    "keyFeatures": ["Feature 1", "Feature 2", "Feature 3"],
    "sustainabilityScore": 0.85,
    "energyEfficiency": "Energy efficiency rating and details",
    "climateAdaptation": "How the design adapts to local climate",
    "culturalElements": ["Cultural element 1", "Cultural element 2"],
    "rooms": [
        {
            "name": "Room Name",
            "area": 45.5,
            "floor": 1,
            "purpose": "bedroom/living/kitchen/majlis/prayer",
            "features": ["Feature 1", "Feature 2"],
            "ventilation": "Ventilation type",
            "lighting": "Lighting design"
        }
    ],
    "materials": [
        {
            "name": "Material Name",
            "category": "foundation/exterior/interior/roofing/flooring",
            "description": "Detailed description",
            "benefits": ["Benefit 1", "Benefit 2"],
            "estimatedCost": 250.0,
            "durability": "Excellent/Good/Moderate/Poor",
            "sustainability": "Excellent/Good/Moderate/Poor",
            "localAvailability": true/false
        }
    ],
    "budget": {
        "total": 2500000,
        "currency": "SAR",
        "breakdown": [
            {
                "name": "Foundation & Structure",
                "amount": 750000,
                "percentage": 30.0
            }
        ],
        "contingency": 250000,
        "timeline": "8-12 months"
    }
}

Ensure all values are realistic for Saudi construction costs and local conditions.`;

        // Call OpenAI API
        const completion = await openai.chat.completions.create({
            model: 'gpt-4',
            messages: [
                {
                    role: 'system',
                    content: systemPrompt
                },
                {
                    role: 'user',
                    content: userPrompt
                }
            ],
            max_tokens: 4000,
            temperature: 0.7,
            response_format: { type: 'json_object' }
        });

        const aiResponse = JSON.parse(completion.choices[0].message.content);

        // Create complete AI result
        const aiResult = {
            id: require('uuid').v4(),
            projectName,
            clientName: clientName || 'Private Client',
            location,
            plotSize,
            totalArea,
            floors,
            style,
            summary: {
                concept: aiResponse.concept,
                keyFeatures: aiResponse.keyFeatures,
                sustainabilityScore: aiResponse.sustainabilityScore,
                energyEfficiency: aiResponse.energyEfficiency,
                climateAdaptation: aiResponse.climateAdaptation,
                culturalElements: aiResponse.culturalElements
            },
            rooms: aiResponse.rooms,
            materials: aiResponse.materials,
            budget: aiResponse.budget,
            images: generateImagePlaceholders(style),
            timestamp: new Date().toISOString(),
            aiConfidence: 0.92,
            processingTime: 3.5
        };

        // Save to Supabase (if configured)
        if (process.env.SUPABASE_URL && process.env.SUPABASE_SERVICE_ROLE_KEY) {
            try {
                const { data, error } = await supabase
                    .from('projects')
                    .insert([aiResult])
                    .select();

                if (error) {
                    console.error('Supabase save error:', error);
                    // Continue even if save fails
                } else {
                    console.log('✅ Project saved to Supabase:', data[0].id);
                }
            } catch (saveError) {
                console.error('Failed to save to Supabase:', saveError);
            }
        }

        console.log(`✅ Architecture generated successfully: ${projectName}`);
        
        res.json({
            success: true,
            data: aiResult,
            timestamp: new Date().toISOString(),
            processingTime: 3.5
        });

    } catch (error) {
        console.error('Architecture generation error:', error);
        
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

// POST /api/architecture/analyze-text
// Analyze architecture from text description
router.post('/analyze-text', async (req, res, next) => {
    try {
        const { text } = req.body;

        if (!text || text.trim().length === 0) {
            const error = new Error('Text is required');
            error.name = 'ValidationError';
            return next(error);
        }

        const completion = await openai.chat.completions.create({
            model: 'gpt-4',
            messages: [
                {
                    role: 'system',
                    content: 'You are an expert architecture analyst. Analyze the provided architecture description and provide detailed insights about style, materials, layout, and design elements.'
                },
                {
                    role: 'user',
                    content: `Analyze this architecture description: ${text}`
                }
            ],
            max_tokens: 1000,
            temperature: 0.7
        });

        const analysis = completion.choices[0].message.content;

        res.json({
            success: true,
            data: {
                analysis: analysis,
                style: extractStyleFromAnalysis(analysis),
                keyFeatures: extractFeaturesFromAnalysis(analysis),
                materials: extractMaterialsFromAnalysis(analysis),
                estimatedCost: estimateCostFromAnalysis(analysis),
                sustainabilityScore: 0.85,
                recommendations: generateRecommendations(analysis)
            },
            timestamp: new Date().toISOString()
        });

    } catch (error) {
        console.error('Text analysis error:', error);
        next(error);
    }
});

// POST /api/architecture/analyze-image
// Analyze architecture from image (placeholder for future implementation)
router.post('/analyze-image', async (req, res, next) => {
    try {
        // This would require image upload handling and vision API
        // For now, return a structured response
        res.json({
            success: true,
            data: {
                message: 'Image analysis requires additional setup with file upload and vision API',
                status: 'Not implemented yet',
                suggestion: 'Use text analysis endpoint for now'
            },
            timestamp: new Date().toISOString()
        });

    } catch (error) {
        console.error('Image analysis error:', error);
        next(error);
    }
});

// Helper Functions
function generateImagePlaceholders(style) {
    return [
        {
            type: 'exterior',
            description: `${style} style exterior view`,
            url: null,
            placeholder: 'AI-generated exterior view',
            isAI: true
        },
        {
            type: 'interior',
            description: `${style} style interior design`,
            url: null,
            placeholder: 'AI-generated interior view',
            isAI: true
        },
        {
            type: 'floorPlan',
            description: 'Detailed floor plan layout',
            url: null,
            placeholder: 'AI-generated floor plan',
            isAI: true
        },
        {
            type: 'elevation',
            description: 'Architectural elevation drawing',
            url: null,
            placeholder: 'AI-generated elevation',
            isAI: true
        },
        {
            type: 'aerial',
            description: 'Aerial view of the complete property',
            url: null,
            placeholder: 'AI-generated aerial view',
            isAI: true
        },
        {
            type: 'night',
            description: 'Night view with lighting',
            url: null,
            placeholder: 'AI-generated night view',
            isAI: true
        }
    ];
}

function extractStyleFromAnalysis(analysis) {
    const styles = ['Modern Saudi', 'Traditional Najdi', 'Mediterranean', 'Contemporary', 'Islamic', 'Luxury Villa', 'Palace'];
    for (const style of styles) {
        if (analysis.toLowerCase().includes(style.toLowerCase())) {
            return style;
        }
    }
    return 'Contemporary';
}

function extractFeaturesFromAnalysis(analysis) {
    const features = [];
    if (analysis.toLowerCase().includes('open')) features.push('Open floor plan');
    if (analysis.toLowerCase().includes('courtyard')) features.push('Courtyard design');
    if (analysis.toLowerCase().includes('majlis')) features.push('Traditional majlis');
    if (analysis.toLowerCase().includes('solar')) features.push('Solar panels');
    return features;
}

function extractMaterialsFromAnalysis(analysis) {
    const materials = [];
    if (analysis.toLowerCase().includes('concrete')) materials.push('Concrete');
    if (analysis.toLowerCase().includes('stone')) materials.push('Natural stone');
    if (analysis.toLowerCase().includes('wood')) materials.push('Traditional wood');
    if (analysis.toLowerCase().includes('glass')) materials.push('Modern glass');
    return materials;
}

function estimateCostFromAnalysis(analysis) {
    // Simple cost estimation based on analysis complexity
    const baseCost = 2000000; // Base cost in SAR
    const complexity = analysis.length > 500 ? 1.5 : 1.0;
    return Math.round(baseCost * complexity);
}

function generateRecommendations(analysis) {
    const recommendations = [];
    if (analysis.toLowerCase().includes('traditional')) {
        recommendations.push('Consider modern insulation while preserving traditional appearance');
    }
    if (analysis.toLowerCase().includes('modern')) {
        recommendations.push('Incorporate traditional Saudi elements for cultural authenticity');
    }
    recommendations.push('Use locally sourced materials for sustainability');
    recommendations.push('Implement energy-efficient cooling systems');
    return recommendations;
}

module.exports = router;
