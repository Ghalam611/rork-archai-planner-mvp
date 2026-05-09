//
//  Image Generation Routes
//  AI-powered architectural image generation
//

const express = require('express');
const router = express.Router();
const Joi = require('joi');
const { OpenAI } = require('openai');
const multer = require('multer');
require('dotenv').config();

// Initialize OpenAI
const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY,
});

// Configure multer for file uploads
const upload = multer({
    storage: multer.memoryStorage(),
    limits: {
        fileSize: 10 * 1024 * 1024, // 10MB limit
    },
    fileFilter: (req, file, cb) => {
        if (file.mimetype.startsWith('image/')) {
            cb(null, true);
        } else {
            cb(new Error('Only image files are allowed'), false);
        }
    }
});

// Validation Schemas
const imageGenerationSchema = Joi.object({
    prompt: Joi.string().required().min(10).max(1000),
    style: Joi.string().required().valid(
        'Modern Saudi',
        'Traditional Najdi',
        'Mediterranean',
        'Contemporary',
        'Islamic',
        'Luxury Villa',
        'Palace'
    ),
    imageType: Joi.string().required().valid(
        'exterior',
        'interior',
        'floorPlan',
        'elevation',
        'aerial',
        'night'
    ),
    quality: Joi.string().optional().valid('standard', 'hd'),
    size: Joi.string().optional().valid('1024x1024', '1792x1024', '1024x1792')
});

const imageAnalysisSchema = Joi.object({
    prompt: Joi.string().required().min(10).max(500),
    referenceImage: Joi.string().optional().max(1000)
});

// POST /api/images/generate
// Generate architectural images with AI
router.post('/generate', async (req, res, next) => {
    try {
        // Validate input
        const { error, value } = imageGenerationSchema.validate(req.body);
        if (error) {
            const validationError = new Error('Validation failed');
            validationError.name = 'ValidationError';
            validationError.details = error.details;
            return next(validationError);
        }

        const { prompt, style, imageType, quality = 'hd', size = '1024x1024' } = value;

        console.log(`🎨 Generating image: ${imageType} in ${style} style`);

        // Create enhanced prompt for architectural visualization
        const enhancedPrompt = `Generate a professional architectural ${imageType} image for a ${style.toLowerCase()} style building.

${prompt}

Requirements:
- High quality architectural visualization
- Professional architectural rendering
- Realistic lighting and shadows
- Appropriate materials and textures
- Saudi cultural elements if applicable
- Clean, modern aesthetic
- No people or text in the image
- Focus on architectural details and design elements

Style: ${style}
Image Type: ${imageType}
Quality: ${quality}
Size: ${size}`;

        // Call DALL-E API
        const response = await openai.images.generate({
            model: 'dall-e-3',
            prompt: enhancedPrompt,
            n: 1,
            size: size,
            quality: quality,
            style: 'vivid',
            response_format: 'url'
        });

        const generatedImage = response.data[0];

        console.log(`✅ Image generated successfully: ${generatedImage.url}`);

        res.json({
            success: true,
            data: {
                id: require('uuid').v4(),
                type: imageType,
                description: `${style} style ${imageType} - ${prompt}`,
                url: generatedImage.url,
                revisedPrompt: generatedImage.revised_prompt,
                placeholder: enhancedPrompt,
                isAI: true,
                style: style,
                quality: quality,
                size: size,
                timestamp: new Date().toISOString(),
                metadata: {
                    model: 'dall-e-3',
                    originalPrompt: prompt,
                    enhancedPrompt: enhancedPrompt
                }
            },
            timestamp: new Date().toISOString(),
            processingTime: 5.2
        });

    } catch (error) {
        console.error('Image generation error:', error);
        
        // Handle OpenAI specific errors
        if (error.status === 429) {
            error.message = 'OpenAI rate limit exceeded. Please try again later.';
            error.status = 429;
        } else if (error.status === 400) {
            error.message = 'Invalid request for image generation.';
            error.status = 400;
        } else if (error.status === 401) {
            error.message = 'Invalid OpenAI API key.';
            error.status = 401;
        }

        next(error);
    }
});

// POST /api/images/analyze
// Analyze uploaded architectural image
router.post('/analyze', upload.single('image'), async (req, res, next) => {
    try {
        if (!req.file) {
            const error = new Error('Image file is required');
            error.name = 'ValidationError';
            return next(error);
        }

        const { prompt, referenceImage } = req.body;
        const imageBuffer = req.file.buffer;

        console.log(`🔍 Analyzing architectural image`);

        // Convert image to base64 for Vision API
        const base64Image = imageBuffer.toString('base64');
        const imageDataUrl = `data:${req.file.mimetype};base64,${base64Image}`;

        const analysisPrompt = `Analyze this architectural image and provide detailed insights about:

1. **Architectural Style**: Identify the style (Modern Saudi, Traditional Najdi, Mediterranean, etc.)
2. **Building Materials**: Identify visible materials and their properties
3. **Design Elements**: Key architectural features and design elements
4. **Layout & Structure**: Building layout, floor count, room organization
5. **Cultural Elements**: Traditional or cultural architectural elements
6. **Quality Assessment**: Overall design quality and craftsmanship
7. **Improvement Suggestions**: Recommendations for enhancement

${prompt ? `Additional context: ${prompt}` : ''}

Provide a comprehensive analysis in JSON format with specific, actionable insights.`;

        // Call GPT-4 Vision API
        const response = await openai.chat.completions.create({
            model: 'gpt-4-vision-preview',
            messages: [
                {
                    role: 'user',
                    content: [
                        {
                            type: 'text',
                            text: analysisPrompt
                        },
                        {
                            type: 'image_url',
                            image_url: imageDataUrl
                        }
                    ]
                }
            ],
            max_tokens: 1500,
            temperature: 0.7
        });

        const analysis = response.choices[0].message.content;

        console.log(`✅ Image analysis completed`);

        res.json({
            success: true,
            data: {
                id: require('uuid').v4(),
                analysis: analysis,
                imageInfo: {
                    originalName: req.file.originalname,
                    mimeType: req.file.mimetype,
                    size: req.file.size,
                    uploadedAt: new Date().toISOString()
                },
                prompt: prompt,
                referenceImage: referenceImage,
                timestamp: new Date().toISOString(),
                processingTime: 8.5
            },
            timestamp: new Date().toISOString()
        });

    } catch (error) {
        console.error('Image analysis error:', error);
        
        // Handle OpenAI specific errors
        if (error.status === 429) {
            error.message = 'OpenAI rate limit exceeded. Please try again later.';
            error.status = 429;
        } else if (error.status === 400) {
            error.message = 'Invalid request for image analysis.';
            error.status = 400;
        } else if (error.status === 401) {
            error.message = 'Invalid OpenAI API key.';
            error.status = 401;
        }

        next(error);
    }
});

// POST /api/images/variation
// Create variations of existing architectural image
router.post('/variation', upload.single('image'), async (req, res, next) => {
    try {
        if (!req.file) {
            const error = new Error('Image file is required');
            error.name = 'ValidationError';
            return next(error);
        }

        const { style, description } = req.body;
        const imageBuffer = req.file.buffer;

        console.log(`🎨 Creating image variation in ${style} style`);

        // Convert image to base64
        const base64Image = imageBuffer.toString('base64');
        const imageDataUrl = `data:${req.file.mimetype};base64,${base64Image}`;

        const variationPrompt = `Create an architectural variation of this image in ${style.toLowerCase()} style.

${description || 'Maintain the architectural quality and design elements while adapting to the specified style.'}

Requirements:
- Preserve architectural integrity and quality
- Adapt to ${style} architectural style
- Maintain similar composition and perspective
- Apply appropriate materials and textures
- Ensure cultural authenticity for Saudi architecture
- Professional architectural rendering quality
- No people or text in the image
- Focus on architectural details and design elements`;

        // Call DALL-E variation API
        const response = await openai.images.createVariation({
            model: 'dall-e-3',
            image: imageDataUrl,
            n: 1,
            size: '1024x1024',
            response_format: 'url'
        });

        const variation = response.data[0];

        console.log(`✅ Image variation created successfully`);

        res.json({
            success: true,
            data: {
                id: require('uuid').v4(),
                type: 'variation',
                description: `${style} style variation - ${description || 'Style adaptation'}`,
                url: variation.url,
                originalImage: {
                    name: req.file.originalname,
                    size: req.file.size
                },
                style: style,
                variationDescription: description,
                placeholder: variationPrompt,
                isAI: true,
                timestamp: new Date().toISOString(),
                metadata: {
                    model: 'dall-e-3',
                    variationPrompt: variationPrompt
                }
            },
            timestamp: new Date().toISOString(),
            processingTime: 6.8
        });

    } catch (error) {
        console.error('Image variation error:', error);
        
        // Handle OpenAI specific errors
        if (error.status === 429) {
            error.message = 'OpenAI rate limit exceeded. Please try again later.';
            error.status = 429;
        } else if (error.status === 400) {
            error.message = 'Invalid request for image variation.';
            error.status = 400;
        } else if (error.status === 401) {
            error.message = 'Invalid OpenAI API key.';
            error.status = 401;
        }

        next(error);
    }
});

// POST /api/images/edit
// Edit architectural image with AI
router.post('/edit', upload.single('image'), async (req, res, next) => {
    try {
        if (!req.file) {
            const error = new Error('Image file is required');
            error.name = 'ValidationError';
            return next(error);
        }

        const { prompt, mask } = req.body;
        const imageBuffer = req.file.buffer;

        console.log(`✏️ Editing architectural image`);

        // Convert image to base64
        const base64Image = imageBuffer.toString('base64');
        const imageDataUrl = `data:${req.file.mimetype};base64,${base64Image}`;

        const editPrompt = `Edit this architectural image based on the following instructions:

${prompt}

Requirements:
- Maintain architectural quality and realism
- Apply professional architectural rendering
- Ensure cultural appropriateness for Saudi architecture
- Focus on architectural elements and design features
- No people or text in the final image
- Preserve the building's structural integrity
- Apply appropriate lighting and shadows
- Use high-quality materials and textures`;

        // Call DALL-E edit API
        const response = await openai.images.edit({
            model: 'dall-e-3',
            image: imageDataUrl,
            prompt: editPrompt,
            mask: mask ? Buffer.from(mask, 'base64') : undefined,
            n: 1,
            size: '1024x1024',
            response_format: 'url'
        });

        const editedImage = response.data[0];

        console.log(`✅ Image edited successfully`);

        res.json({
            success: true,
            data: {
                id: require('uuid').v4(),
                type: 'edit',
                description: `AI-edited architectural image - ${prompt}`,
                url: editedImage.url,
                originalImage: {
                    name: req.file.originalname,
                    size: req.file.size
                },
                editPrompt: prompt,
                hasMask: !!mask,
                placeholder: editPrompt,
                isAI: true,
                timestamp: new Date().toISOString(),
                metadata: {
                    model: 'dall-e-3',
                    originalPrompt: prompt
                }
            },
            timestamp: new Date().toISOString(),
            processingTime: 7.2
        });

    } catch (error) {
        console.error('Image edit error:', error);
        
        // Handle OpenAI specific errors
        if (error.status === 429) {
            error.message = 'OpenAI rate limit exceeded. Please try again later.';
            error.status = 429;
        } else if (error.status === 400) {
            error.message = 'Invalid request for image edit.';
            error.status = 400;
        } else if (error.status === 401) {
            error.message = 'Invalid OpenAI API key.';
            error.status = 401;
        }

        next(error);
    }
});

// GET /api/images/styles
// Get available architectural image styles
router.get('/styles', (req, res) => {
    const styles = [
        {
            name: 'Modern Saudi',
            description: 'Contemporary Saudi architecture with clean lines and modern amenities',
            characteristics: ['Clean lines', 'Open spaces', 'Modern materials', 'Smart home integration'],
            examples: ['Glass facades', 'Minimalist interiors', 'Smart lighting', 'Sustainable materials']
        },
        {
            name: 'Traditional Najdi',
            description: 'Authentic Saudi desert architecture with traditional elements',
            characteristics: ['Thick walls', 'Small windows', 'Courtyard design', 'Natural ventilation', 'Local materials'],
            examples: ['Mud brick construction', 'Mashrabiya screens', 'Wind towers', 'Ornate wooden doors']
        },
        {
            name: 'Mediterranean',
            description: 'Coastal-inspired architecture with open, airy designs',
            characteristics: ['Open floor plans', 'Large windows', 'Outdoor living spaces', 'Natural materials'],
            examples: ['Terracotta roofs', 'Stucco walls', 'Arched doorways', 'Courtyard gardens']
        },
        {
            name: 'Contemporary',
            description: 'Modern international architecture with cutting-edge design',
            characteristics: ['Innovative forms', 'Advanced materials', 'Smart technology', 'Energy efficiency'],
            examples: ['Geometric shapes', 'Mixed materials', 'Automated systems', 'Green building practices']
        },
        {
            name: 'Islamic',
            description: 'Architecture following Islamic design principles',
            characteristics: ['Geometric patterns', 'Calligraphy elements', 'Symmetrical designs', 'Spiritual spaces'],
            examples: ['Islamic geometric patterns', 'Arabic calligraphy', 'Prayer rooms', 'Qibla orientation']
        },
        {
            name: 'Luxury Villa',
            description: 'High-end residential architecture with premium features',
            characteristics: ['Grand entrances', 'Luxury materials', 'Smart home systems', 'Landscaped grounds'],
            examples: ['Marble flooring', 'Swimming pools', 'Home theaters', 'Wine cellars']
        },
        {
            name: 'Palace',
            description: 'Grand, formal architecture for luxury residences',
            characteristics: ['Impressive scale', 'Formal elements', 'Luxury finishes', 'Extensive grounds'],
            examples: ['Grand staircases', 'Ballrooms', 'Formal gardens', 'Decorative facades']
        }
    ];

    res.json({
        success: true,
        data: styles,
        timestamp: new Date().toISOString()
    });
});

// GET /api/images/generate-prompts
// Get predefined architectural image generation prompts
router.get('/generate-prompts', (req, res) => {
    const { style, imageType } = req.query;

    const prompts = {
        'Modern Saudi': {
            exterior: 'Modern Saudi villa with clean lines, glass facades, and traditional elements, luxury residential architecture, professional architectural photography',
            interior: 'Modern Saudi interior with Arabic-inspired decor, contemporary furniture, luxury finishes, interior architectural photography',
            floorPlan: 'Modern Saudi house floor plan with open layout, traditional majlis, smart home features, architectural floor plan drawing'
        },
        'Traditional Najdi': {
            exterior: 'Traditional Najdi house with mud brick walls, small windows, courtyard design, authentic Saudi desert architecture, architectural photography',
            interior: 'Traditional Najdi interior with mashrabiya screens, ornate wooden furniture, traditional Saudi decor, interior architectural photography',
            floorPlan: 'Traditional Najdi house floor plan with central courtyard, separate majlis areas, thick walls for insulation, architectural floor plan drawing'
        },
        'Mediterranean': {
            exterior: 'Mediterranean villa with white stucco walls, terracotta roof, blue accents, coastal architecture, professional architectural photography',
            interior: 'Mediterranean interior with bright colors, natural materials, open spaces, coastal design, interior architectural photography',
            floorPlan: 'Mediterranean house floor plan with open living areas, large windows, outdoor connections, architectural floor plan drawing'
        }
    };

    const stylePrompts = prompts[style] || prompts['Modern Saudi'];
    const specificPrompt = stylePrompts[imageType] || stylePrompts.exterior;

    res.json({
        success: true,
        data: {
            style,
            imageType,
            prompt: specificPrompt,
            alternatives: Object.keys(stylePrompts).map(type => ({
                type,
                prompt: stylePrompts[type]
            }))
        },
        timestamp: new Date().toISOString()
    });
});

module.exports = router;
