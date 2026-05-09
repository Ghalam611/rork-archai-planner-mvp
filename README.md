# ArchAI Planner

ArchAI Planner is a production-ready AI-powered iPhone architecture planning app that generates stunning architectural designs with real AI integration. It helps users capture project requirements, generate architectural designs, review saved concepts, and chat with an AI architecture assistant.

## Production Features

- **Real AI Integration**: OpenAI GPT-4 for architecture analysis and design generation
- **Saudi Architecture Styles**: Modern Saudi, Traditional Najdi, Mediterranean, and more
- **Supabase Backend**: Real-time project storage and synchronization
- **Comprehensive Error Handling**: Graceful fallback to demo mode
- **Luxury UI**: Premium dark interface with Saudi gold accents
- **Complete Architecture Workflow**: From requirements to detailed results
- **Project Management**: Save, share, and manage AI-generated projects
- **Cultural Adaptation**: Saudi-specific architectural elements and materials

## Quick Setup

### Prerequisites
- Xcode 15.0+
- iOS 17.0+
- OpenAI API Key
- Supabase Project

### 1. Clone and Install
```bash
git clone <repository-url>
cd rork-archai-planner-mvp
```

### 2. Configure API Keys

Create a `.env` file from `.env.example`:

```bash
cp .env.example .env
```

Add your API credentials:

```env
# OpenAI API Configuration
OPENAI_API_KEY=your-openai-api-key-here

# Supabase Configuration
SUPABASE_URL=your-supabase-project-url
SUPABASE_ANON_KEY=your-supabase-anon-key

# Backend Functions (Optional)
RORK_FUNCTIONS_URL=your-rork-functions-url
```

### 3. API Key Setup Guide

#### OpenAI API Key
1. Go to [OpenAI Platform](https://platform.openai.com/)
2. Sign up or log in
3. Navigate to API Keys section
4. Create new API key
5. Copy and add to `.env` file as `OPENAI_API_KEY`

#### Supabase Setup
1. Go to [Supabase Dashboard](https://supabase.com/)
2. Create new project
3. Go to Settings > API
4. Copy Project URL and anon key
5. Add to `.env` file as `SUPABASE_URL` and `SUPABASE_ANON_KEY`

#### Database Setup
Create a `projects` table in Supabase SQL Editor:

```sql
CREATE TABLE projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id),
    project_name TEXT NOT NULL,
    client_name TEXT,
    location TEXT NOT NULL,
    plot_size DECIMAL,
    total_area DECIMAL,
    floors INTEGER,
    style TEXT NOT NULL,
    summary JSONB,
    rooms JSONB,
    materials JSONB,
    budget JSONB,
    images JSONB,
    timestamp TIMESTAMPTZ DEFAULT NOW(),
    ai_confidence DECIMAL,
    processing_time DECIMAL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;

-- Create policy for users to manage their own projects
CREATE POLICY "Users can manage their own projects" ON projects
    FOR ALL USING (auth.uid() = user_id);
```

### 4. Backend Functions (Optional)

If you want to deploy secure backend functions instead of calling OpenAI directly:

```javascript
// Example Netlify Function: generate-architecture.js
exports.handler = async (event) => {
    const { prompt } = JSON.parse(event.body);
    
    const response = await fetch('https://api.openai.com/v1/chat/completions', {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`,
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            model: 'gpt-4',
            messages: [
                { role: 'system', content: 'You are an expert architect...' },
                { role: 'user', content: prompt }
            ]
        })
    });
    
    return {
        statusCode: 200,
        body: await response.text()
    };
};
```

## Architecture

### Real API Integration
- **AIService**: Handles OpenAI API calls with retry logic
- **SupabaseService**: Manages project storage and real-time sync
- **Fallback System**: Gracefully degrades to demo mode when API keys missing

### Key Components
- **AI Generation**: Real-time architecture design generation
- **Project Cards**: Rich project previews with AI confidence scores
- **Detailed Results**: Multi-tab result views (Overview, Rooms, Materials, Budget, Images)
- **Saudi Styles**: Cultural architecture elements and local materials
- **Error Handling**: Comprehensive loading states and error recovery

## Running the App

### Development Mode
1. Open `ArchAIPlanner.xcodeproj` in Xcode
2. Select your target simulator or device
3. Press Run (⌘+R)

### Demo Mode
The app automatically falls back to demo mode when:
- API keys are missing
- Network is unavailable
- Backend services are down

Demo mode includes:
- Sample AI-generated projects
- Mock architecture analysis
- Simulated chat responses
- Full UI functionality

## Features

### AI Architecture Generation
- **Text Analysis**: Analyze architecture descriptions
- **Style Suggestions**: Saudi-inspired architectural styles
- **Room Layouts**: Intelligent room distribution
- **Material Recommendations**: Local and sustainable materials
- **Budget Estimation**: Detailed cost breakdowns
- **Image Generation**: AI-generated architectural visualizations

### Project Management
- **Real-time Sync**: Supabase-powered synchronization
- **Offline Support**: Local caching with sync when online
- **Search & Filter**: Find projects by style, location, or name
- **Export/Import**: Share projects between devices

### Cultural Adaptation
- **Saudi Architecture**: Traditional Najdi and Modern Saudi styles
- **Local Materials**: Region-specific material recommendations
- **Climate Adaptation**: Designs optimized for Saudi climate
- **Cultural Elements**: Islamic architectural patterns and features

## Security

- **API Key Protection**: Keys loaded from environment variables
- **No Hardcoded Secrets**: All sensitive data externalized
- **Supabase RLS**: Row-level security for user data
- **HTTPS Only**: All API calls use secure connections

## Development

### Adding New Architecture Styles
1. Add new case to `ArchitectureStyle` enum
2. Update `accentColor` and other properties
3. Add style-specific prompts in AI service
4. Update UI components to handle new style

### Extending AI Capabilities
1. Add new endpoints to `AIService`
2. Update request/response models
3. Implement retry logic for new endpoints
4. Add error handling for new features

## License

This project is licensed under the MIT License.

## Support

For setup issues or questions:
1. Check API key configuration
2. Verify Supabase setup
3. Review error logs in Xcode console
4. Ensure network connectivity

## Deployment

### App Store
1. Configure production API keys
2. Set up Supabase production project
3. Update bundle identifier
4. Archive and upload to App Store Connect

### Backend Deployment
Deploy backend functions to:
- Netlify Functions
- Vercel
- AWS Lambda
- Railway
- Or any serverless platform
