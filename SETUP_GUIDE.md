# 🚀 API Configuration Setup Guide

This guide will help you set up all the necessary API keys and services to run ArchAI Planner with full AI functionality.

## 📋 Prerequisites

- [OpenAI Account](https://platform.openai.com/)
- [Supabase Account](https://supabase.com/)
- Xcode 15.0+
- iOS 17.0+

## 🔑 API Keys Setup

### Step 1: OpenAI API Key

1. **Create/Open OpenAI Account**
   - Go to [OpenAI Platform](https://platform.openai.com/)
   - Sign up or log in
   - Verify your email if new account

2. **Generate API Key**
   - Navigate to **API Keys** section
   - Click **"Create new secret key"**
   - Give it a descriptive name (e.g., "ArchAI Planner")
   - Copy the key immediately (you won't see it again)

3. **Add to Environment**
   ```env
   OPENAI_API_KEY=sk-your-actual-openai-api-key-here
   ```

### Step 2: Supabase Configuration

1. **Create Supabase Project**
   - Go to [Supabase Dashboard](https://supabase.com/)
   - Click **"New Project"**
   - Choose organization or create new one
   - Set project name (e.g., "archai-planner")
   - Set database password
   - Choose region (closest to your users)
   - Click **"Create new project"**

2. **Get API Credentials**
   - Wait for project to be ready (1-2 minutes)
   - Go to **Settings > API**
   - Copy **Project URL**
   - Copy **anon public** key

3. **Add to Environment**
   ```env
   SUPABASE_URL=https://your-project-id.supabase.co
   SUPABASE_ANON_KEY=your-supabase-anon-key-here
   ```

### Step 3: Database Setup

1. **Create Projects Table**
   - Go to **SQL Editor** in Supabase
   - Run this SQL query:

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

2. **Enable Authentication** (Optional)
   - Go to **Authentication > Settings**
   - Enable email/password providers
   - Configure redirect URLs for your app

### Step 4: Backend Functions (Optional)

If you want to deploy secure backend functions instead of calling OpenAI directly:

1. **Deploy Backend Function**
   ```javascript
   // Example Netlify Function: netlify/functions/generate-architecture.js
   const { Configuration, OpenAIApi } = require("openai");

   const configuration = new Configuration({
       apiKey: process.env.OPENAI_API_KEY,
   });

   const openai = new OpenAIApi(configuration);

   exports.handler = async (event) => {
       try {
           const { prompt } = JSON.parse(event.body);
           
           const completion = await openai.createChatCompletion({
               model: "gpt-4",
               messages: [
                   {
                       role: "system",
                       content: "You are an expert Saudi architect specializing in modern and traditional architecture..."
                   },
                   {
                       role: "user",
                       content: `Generate architecture design for: ${prompt.projectName}, ${prompt.location}, ${prompt.style} style`
                   }
               ],
               max_tokens: 2000,
               temperature: 0.7
           });

           return {
               statusCode: 200,
               body: JSON.stringify(completion.data.choices[0].message)
           };
       } catch (error) {
           return {
               statusCode: 500,
               body: JSON.stringify({ error: error.message })
           };
       }
   };
   ```

2. **Add Backend URL to Environment**
   ```env
   RORK_FUNCTIONS_URL=https://your-functions-url.netlify.app
   ```

## 📁 Environment File Setup

### Create .env File
1. Copy the example file:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` with your actual keys:
   ```env
   # OpenAI API Configuration
   OPENAI_API_KEY=sk-your-actual-openai-api-key-here

   # Supabase Configuration
   SUPABASE_URL=https://your-project-id.supabase.co
   SUPABASE_ANON_KEY=your-supabase-anon-key-here

   # Backend Functions (Optional)
   RORK_FUNCTIONS_URL=https://your-functions-url.netlify.app
   ```

### Security Notes
- **NEVER commit `.env` to version control**
- **Add `.env` to `.gitignore`**
- **Use different keys for development and production**
- **Rotate API keys regularly**

## 🧪 Testing Configuration

### Verify API Keys
1. **Test OpenAI Key**
   ```bash
   curl -X POST https://api.openai.com/v1/chat/completions \
     -H "Authorization: Bearer YOUR_OPENAI_KEY" \
     -H "Content-Type: application/json" \
     -d '{
       "model": "gpt-4",
       "messages": [{"role": "user", "content": "Hello"}],
       "max_tokens": 5
     }'
   ```

2. **Test Supabase Connection**
   ```bash
   curl -X GET https://your-project-id.supabase.co/rest/v1/projects \
     -H "apikey: YOUR_SUPABASE_ANON_KEY" \
     -H "Authorization: Bearer YOUR_SUPABASE_ANON_KEY"
   ```

### Run App in Different Modes

#### Demo Mode (No API Keys)
- App automatically falls back to demo mode
- Shows sample AI-generated projects
- Mock chat responses
- Full UI functionality

#### Real Mode (With API Keys)
- Real AI architecture generation
- Actual Supabase project storage
- Live chat with AI assistant
- Real-time synchronization

## 🔧 Troubleshooting

### Common Issues

#### 1. "Invalid API Key" Error
- **Check**: OpenAI key starts with `sk-`
- **Check**: No extra spaces or quotes
- **Solution**: Regenerate API key from OpenAI dashboard

#### 2. "Supabase Connection Failed" Error
- **Check**: Project URL format (`https://project-id.supabase.co`)
- **Check**: Anon key is correct
- **Solution**: Verify project exists in Supabase dashboard

#### 3. "Demo Mode Active" Message
- **Check**: All environment variables are set
- **Check**: `.env` file is in project root
- **Solution**: Restart Xcode after changing `.env`

#### 4. "Database Schema Error"
- **Check**: SQL was executed successfully
- **Check**: Row Level Security is enabled
- **Solution**: Recreate table with provided SQL

### Debug Mode

Enable debug logging in Xcode:
1. Go to **Product > Scheme > Edit Scheme**
2. Select **Run > Arguments**
3. Add environment variables:
   - `OPENAI_API_KEY` = your-key
   - `SUPABASE_URL` = your-url
   - `SUPABASE_ANON_KEY` = your-key

## 🚀 Production Deployment

### App Store Configuration
1. **Production API Keys**
   - Generate new OpenAI key for production
   - Create separate Supabase project for production
   - Update environment variables in build process

2. **Build Configuration**
   - Use Xcode build configurations
   - Set different `.env` files per configuration
   - Ensure API keys are not included in app bundle

### Security Best Practices
- **Use backend functions** instead of direct OpenAI calls
- **Implement rate limiting** on your backend
- **Monitor API usage** and costs
- **Use HTTPS** for all API calls
- **Validate user input** before sending to AI

## 📞 Support

### Getting Help
If you encounter issues:

1. **Check Console Logs**
   - Open Xcode Console
   - Look for API error messages
   - Check network requests

2. **Verify Configuration**
   - Run through this checklist
   - Test each API key individually
   - Check environment variable loading

3. **Community Support**
   - Check GitHub Issues
   - Review documentation
   - Join Discord/Slack communities

### Quick Checklist
- [ ] OpenAI API key starts with `sk-`
- [ ] Supabase URL format is correct
- [ ] Supabase anon key is valid
- [ ] Database table exists
- [ ] Row Level Security enabled
- [ ] `.env` file in project root
- [ ] No API keys in source code
- [ ] HTTPS endpoints only
- [ ] Error handling implemented
- [ ] Demo mode fallback working

## 🎉 Success!

Once you've completed these steps:
1. Open `ArchAIPlanner.xcodeproj` in Xcode
2. Build and run on simulator
3. Test AI generation with real APIs
4. Verify project saving to Supabase
5. Enjoy your fully functional AI architecture assistant!

Your app is now ready for production use with real AI integration! 🏗️✨
