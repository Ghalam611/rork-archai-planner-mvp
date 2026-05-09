//
//  Analysis Routes
//  Architecture analysis and insights
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
const textAnalysisSchema = Joi.object({
    text: Joi.string().required().min(10).max(2000),
    context: Joi.string().optional().max(500)
});

const costAnalysisSchema = Joi.object({
    projectDetails: Joi.object().required(),
    location: Joi.string().required(),
    budget: Joi.number().optional(),
    materials: Joi.array().optional()
});

const sustainabilitySchema = Joi.object({
    projectData: Joi.object().required(),
    climate: Joi.string().required(),
    energyGoals: Joi.array().optional()
});

// POST /api/analysis/text
// Deep analysis of architecture description
router.post('/text', async (req, res, next) => {
    try {
        // Validate input
        const { error, value } = textAnalysisSchema.validate(req.body);
        if (error) {
            const validationError = new Error('Validation failed');
            validationError.name = 'ValidationError';
            validationError.details = error.details;
            return next(validationError);
        }

        const { text, context } = value;

        console.log(`📝 Analyzing text: ${text.substring(0, 100)}...`);

        const analysisPrompt = `You are an expert Saudi architecture analyst. Provide a comprehensive analysis of the following architecture description:

${text}

${context ? `Additional context: ${context}` : ''}

Please analyze and provide detailed insights on:

1. **Architectural Style**: Identify the primary style and influences
2. **Design Elements**: Key architectural features and design principles
3. **Materials & Construction**: Suggested materials and construction methods
4. **Cultural Context**: Cultural elements and Saudi architectural considerations
5. **Climate Adaptation**: How the design adapts to Saudi climate
6. **Functionality**: Practical aspects of the design
7. **Innovation**: Modern or innovative elements
8. **Challenges**: Potential construction or design challenges
9. **Recommendations**: Specific suggestions for improvement
10. **Cost Considerations**: Budget implications and cost factors

Provide your analysis in a structured JSON format with detailed, actionable insights specific to Saudi architecture and construction practices.`;

        const completion = await openai.chat.completions.create({
            model: 'gpt-4',
            messages: [
                {
                    role: 'system',
                    content: 'You are an expert Saudi architecture analyst with deep knowledge of local building practices, materials, and cultural considerations.'
                },
                {
                    role: 'user',
                    content: analysisPrompt
                }
            ],
            max_tokens: 2000,
            temperature: 0.7
        });

        const analysis = completion.choices[0].message.content;

        console.log(`✅ Text analysis completed`);

        res.json({
            success: true,
            data: {
                analysis: analysis,
                text: text,
                context: context,
                insights: extractInsights(analysis),
                recommendations: extractRecommendations(analysis),
                timestamp: new Date().toISOString()
            },
            timestamp: new Date().toISOString()
        });

    } catch (error) {
        console.error('Text analysis error:', error);
        next(error);
    }
});

// POST /api/analysis/cost
// Cost analysis and estimation
router.post('/cost', async (req, res, next) => {
    try {
        // Validate input
        const { error, value } = costAnalysisSchema.validate(req.body);
        if (error) {
            const validationError = new Error('Validation failed');
            validationError.name = 'ValidationError';
            validationError.details = error.details;
            return next(validationError);
        }

        const { projectDetails, location, budget, materials } = value;

        console.log(`💰 Analyzing costs for: ${projectDetails.projectName || 'project'}`);

        const costPrompt = `As a Saudi construction cost expert, analyze the following project details and provide comprehensive cost insights:

Project Details:
${JSON.stringify(projectDetails, null, 2)}
Location: ${location}
${budget ? `Budget: SAR ${budget}` : ''}
${materials ? `Preferred Materials: ${materials.join(', ')}` : ''}

Please provide detailed analysis on:

1. **Cost Breakdown**: Detailed cost estimation by category (foundation, structure, exterior, interior, finishes, etc.)
2. **Material Costs**: Local Saudi material prices and alternatives
3. **Labor Costs**: Saudi labor rates and time estimates
4. **Market Factors**: Current Saudi construction market conditions
5. **Regional Variations**: Cost differences between Saudi cities
6. **Quality Tiers**: Budget, mid-range, and luxury options
7. **Hidden Costs**: Often overlooked expenses
8. **Cost Optimization**: Money-saving opportunities
9. **Timeline Impact**: How different choices affect construction timeline
10. **ROI Analysis**: Value addition and resale considerations

Use current Saudi market rates and provide costs in SAR. Consider local regulations, material availability, and skilled labor requirements.`;

        const completion = await openai.chat.completions.create({
            model: 'gpt-4',
            messages: [
                {
                    role: 'system',
                    content: 'You are a Saudi construction cost estimation expert with current market knowledge.'
                },
                {
                    role: 'user',
                    content: costPrompt
                }
            ],
            max_tokens: 2000,
            temperature: 0.5
        });

        const costAnalysis = completion.choices[0].message.content;

        console.log(`✅ Cost analysis completed`);

        res.json({
            success: true,
            data: {
                costAnalysis: costAnalysis,
                projectDetails,
                location,
                budget,
                materials,
                insights: extractCostInsights(costAnalysis),
                timestamp: new Date().toISOString()
            },
            timestamp: new Date().toISOString()
        });

    } catch (error) {
        console.error('Cost analysis error:', error);
        next(error);
    }
});

// POST /api/analysis/sustainability
// Sustainability analysis and recommendations
router.post('/sustainability', async (req, res, next) => {
    try {
        // Validate input
        const { error, value } = sustainabilitySchema.validate(req.body);
        if (error) {
            const validationError = new Error('Validation failed');
            validationError.name = 'ValidationError';
            validationError.details = error.details;
            return next(validationError);
        }

        const { projectData, climate, energyGoals } = value;

        console.log(`🌱 Analyzing sustainability for: ${projectData.projectName || 'project'}`);

        const sustainabilityPrompt = `As a Saudi sustainable architecture expert, analyze the following project for environmental impact and sustainability:

Project Data:
${JSON.stringify(projectData, null, 2)}
Climate: ${climate}
${energyGoals ? `Energy Goals: ${energyGoals.join(', ')}` : ''}

Please provide comprehensive sustainability analysis covering:

1. **Energy Efficiency**: Current and potential energy performance
2. **Water Conservation**: Water usage and conservation opportunities
3. **Material Sustainability**: Environmental impact of materials
4. **Waste Reduction**: Construction waste minimization strategies
5. **Climate Adaptation**: Passive cooling and natural ventilation
6. **Renewable Energy**: Solar and alternative energy options
7. **Indoor Air Quality**: Ventilation and air quality considerations
8. **Green Building Standards**: LEED and local green building compliance
9. **Life Cycle Assessment**: Long-term environmental impact
10. **Certification Opportunities**: Available green building certifications

Focus on Saudi climate conditions and local sustainability practices. Provide specific, actionable recommendations with potential cost savings and environmental benefits.`;

        const completion = await openai.chat.completions.create({
            model: 'gpt-4',
            messages: [
                {
                    role: 'system',
                    content: 'You are an expert in sustainable architecture with deep knowledge of Saudi environmental conditions and green building practices.'
                },
                {
                    role: 'user',
                    content: sustainabilityPrompt
                }
            ],
            max_tokens: 2000,
            temperature: 0.7
        });

        const sustainabilityAnalysis = completion.choices[0].message.content;

        console.log(`✅ Sustainability analysis completed`);

        res.json({
            success: true,
            data: {
                sustainabilityAnalysis: sustainabilityAnalysis,
                projectData,
                climate,
                energyGoals,
                score: calculateSustainabilityScore(sustainabilityAnalysis),
                recommendations: extractSustainabilityRecommendations(sustainabilityAnalysis),
                timestamp: new Date().toISOString()
            },
            timestamp: new Date().toISOString()
        });

    } catch (error) {
        console.error('Sustainability analysis error:', error);
        next(error);
    }
});

// POST /api/analysis/compliance
// Building code compliance analysis
router.post('/compliance', async (req, res, next) => {
    try {
        const { projectData, location, buildingType } = req.body;

        console.log(`📋 Analyzing compliance for: ${projectData.projectName || 'project'}`);

        const compliancePrompt = `As a Saudi building code expert, analyze the following project for compliance with local regulations:

Project Data:
${JSON.stringify(projectData, null, 2)}
Location: ${location}
Building Type: ${buildingType || 'Residential'}

Please analyze compliance with:

1. **Saudi Building Codes**: National and local building regulations
2. **Zoning Requirements**: Land use and zoning compliance
3. **Safety Standards**: Fire safety, structural safety, accessibility
4. **Environmental Regulations**: Environmental impact and mitigation requirements
5. **Permit Requirements**: Necessary permits and approval processes
6. **Design Standards**: Architectural and engineering standards
7. **Material Specifications**: Approved materials and quality standards
8. **Energy Codes**: Energy efficiency and insulation requirements
9. **Accessibility**: Universal design and accessibility compliance
10. **Documentation**: Required plans, calculations, and certifications

Provide specific compliance requirements, potential issues, and recommendations for ensuring full regulatory approval in Saudi Arabia.`;

        const completion = await openai.chat.completions.create({
            model: 'gpt-4',
            messages: [
                {
                    role: 'system',
                    content: 'You are an expert in Saudi building codes and construction regulations.'
                },
                {
                    role: 'user',
                    content: compliancePrompt
                }
            ],
            max_tokens: 2000,
            temperature: 0.3
        });

        const complianceAnalysis = completion.choices[0].message.content;

        console.log(`✅ Compliance analysis completed`);

        res.json({
            success: true,
            data: {
                complianceAnalysis: complianceAnalysis,
                projectData,
                location,
                buildingType,
                requirements: extractComplianceRequirements(complianceAnalysis),
                issues: extractComplianceIssues(complianceAnalysis),
                recommendations: extractComplianceRecommendations(complianceAnalysis),
                timestamp: new Date().toISOString()
            },
            timestamp: new Date().toISOString()
        });

    } catch (error) {
        console.error('Compliance analysis error:', error);
        next(error);
    }
});

// Helper Functions
function extractInsights(analysis) {
    const insights = [];
    if (analysis.toLowerCase().includes('modern')) insights.push('Modern architectural elements detected');
    if (analysis.toLowerCase().includes('traditional')) insights.push('Traditional design elements present');
    if (analysis.toLowerCase().includes('sustainable')) insights.push('Sustainable features identified');
    return insights;
}

function extractRecommendations(analysis) {
    const recommendations = [];
    if (analysis.toLowerCase().includes('cost')) recommendations.push('Consider cost optimization strategies');
    if (analysis.toLowerCase().includes('energy')) recommendations.push('Improve energy efficiency');
    return recommendations;
}

function extractCostInsights(analysis) {
    const insights = [];
    if (analysis.toLowerCase().includes('high')) insights.push('Premium materials and finishes');
    if (analysis.toLowerCase().includes('labor')) insights.push('Skilled labor requirements');
    return insights;
}

function calculateSustainabilityScore(analysis) {
    // Simple scoring based on keywords
    let score = 0.5; // Base score
    if (analysis.toLowerCase().includes('solar')) score += 0.2;
    if (analysis.toLowerCase().includes('energy')) score += 0.15;
    if (analysis.toLowerCase().includes('water')) score += 0.1;
    if (analysis.toLowerCase().includes('materials')) score += 0.05;
    return Math.min(score, 1.0);
}

function extractSustainabilityRecommendations(analysis) {
    const recommendations = [];
    if (analysis.toLowerCase().includes('solar')) recommendations.push('Install solar panels');
    if (analysis.toLowerCase().includes('insulation')) recommendations.push('Improve insulation');
    return recommendations;
}

function extractComplianceRequirements(analysis) {
    const requirements = [];
    if (analysis.toLowerCase().includes('permit')) requirements.push('Building permit required');
    if (analysis.toLowerCase().includes('inspection')) requirements.push('Regular inspections needed');
    return requirements;
}

function extractComplianceIssues(analysis) {
    const issues = [];
    if (analysis.toLowerCase().includes('non-compliant')) issues.push('Non-compliant elements identified');
    return issues;
}

function extractComplianceRecommendations(analysis) {
    const recommendations = [];
    if (analysis.toLowerCase().includes('permit')) recommendations.push('Obtain necessary permits');
    return recommendations;
}

module.exports = router;
