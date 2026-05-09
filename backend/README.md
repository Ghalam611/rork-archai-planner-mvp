# 🚀 ArchAI Planner Backend

Production-ready Node.js backend API for the ArchAI Planner iOS app with real AI integration.

## 🏗️ Architecture

```
┌──────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   iOS App         │    │   Backend API    │    │   OpenAI API    │
│                 │◄──►│                 │◄──►│                 │
│   HTTP Requests    │    │  Node.js Server  │    │  GPT-4 Vision   │
│   JSON Responses   │    │  Express Routes   │    │  Chat Completions│
│   Supabase Sync   │    │  AI Integration  │    │  DALL-E 3       │
│   Real-time Data   │    │  Error Handling  │    │  Image Gen       │
└──────────────────┘    └──────────────────┘    └─────────────────┘
```

## 📁 Project Structure

```
backend/
├── package.json              # Dependencies and scripts
├── server.js                # Main Express server
├── .env.example             # Environment variables template
├── routes/                  # API route handlers
│   ├── architecture.js       # Architecture generation
│   ├── chat.js              # AI chat assistant
│   ├── projects.js           # Project CRUD operations
│   ├── images.js            # Image generation & analysis
│   └── analysis.js           # Advanced analysis tools
├── README.md                # This file
└── DEPLOYMENT.md           # Deployment guides
```

## 🚀 Quick Start

### Prerequisites
- Node.js 18.0+
- npm 8.0+
- OpenAI API key
- Supabase project

### Installation
```bash
cd backend
npm install
```

### Configuration
```bash
cp .env.example .env
# Edit .env with your actual API keys
```

### Development
```bash
npm run dev
# Server runs on http://localhost:3000
```

### Production
```bash
npm start
# Server runs on http://localhost:3000
```

## 🔑 API Endpoints

### Architecture Generation
- `POST /api/architecture/generate` - Generate complete architecture design
- `POST /api/architecture/analyze-text` - Analyze architecture description
- `POST /api/architecture/analyze-image` - Analyze architecture image

### AI Chat Assistant
- `POST /api/chat/architecture` - Chat with AI architecture assistant
- `POST /api/chat/quick-advice` - Get quick architecture advice
- `POST /api/chat/style-recommendations` - Get style recommendations
- `POST /api/chat/material-advice` - Get material recommendations

### Project Management
- `GET /api/projects` - List projects with pagination and filtering
- `GET /api/projects/:id` - Get single project
- `POST /api/projects` - Create new project
- `PUT /api/projects/:id` - Update existing project
- `DELETE /api/projects/:id` - Delete project
- `GET /api/projects/stats` - Get project statistics
- `GET /api/projects/export/:id` - Export project data

### Image Generation & Analysis
- `POST /api/images/generate` - Generate architectural images
- `POST /api/images/analyze` - Analyze uploaded architecture image
- `POST /api/images/variation` - Create image variations
- `POST /api/images/edit` - Edit architectural images
- `GET /api/images/styles` - Get available styles
- `GET /api/images/generate-prompts` - Get predefined prompts

### Advanced Analysis
- `POST /api/analysis/text` - Deep text analysis
- `POST /api/analysis/cost` - Cost analysis and estimation
- `POST /api/analysis/sustainability` - Sustainability analysis
- `POST /api/analysis/compliance` - Building code compliance

## 🔧 Features

### AI Integration
- **OpenAI GPT-4**: Advanced architecture analysis and generation
- **DALL-E 3**: High-quality architectural image generation
- **Vision API**: Image analysis for architecture insights
- **Saudi Architecture Expertise**: Specialized prompts for Saudi styles
- **Cultural Context**: Deep understanding of local architecture

### Data Management
- **Supabase Integration**: Real-time database operations
- **Project CRUD**: Complete project lifecycle management
- **Data Validation**: Joi-based input validation
- **Error Handling**: Comprehensive error responses
- **Pagination**: Efficient data retrieval

### Security & Performance
- **Rate Limiting**: Configurable request limits
- **CORS Support**: Cross-origin request handling
- **Helmet Security**: Security headers and policies
- **Compression**: Response compression for performance
- **Request Logging**: Morgan-based request logging

### Development Tools
- **Hot Reloading**: Nodemon for development
- **Environment Variables**: Secure configuration management
- **Health Checks**: Service monitoring endpoints
- **API Documentation**: Comprehensive endpoint documentation

## 📊 API Usage Examples

### Generate Architecture Design
```bash
curl -X POST http://localhost:3000/api/architecture/generate \
  -H "Content-Type: application/json" \
  -d '{
    "projectName": "Modern Saudi Villa",
    "clientName": "Al Saud Family",
    "location": "Riyadh, Saudi Arabia",
    "plotSize": 2000,
    "totalArea": 850,
    "floors": 2,
    "style": "Modern Saudi",
    "requirements": "Include smart home features"
  }'
```

### Chat with AI Assistant
```bash
curl -X POST http://localhost:3000/api/chat/architecture \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      {
        "role": "user",
        "content": "What are the key features of Modern Saudi architecture?"
      }
    ]
  }'
```

### Generate Architectural Image
```bash
curl -X POST http://localhost:3000/api/images/generate \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Modern Saudi villa with glass facades",
    "style": "Modern Saudi",
    "imageType": "exterior",
    "quality": "hd"
  }'
```

## 🚀 Deployment

### Environment Variables
Required for production:
- `OPENAI_API_KEY` - OpenAI API key
- `SUPABASE_URL` - Supabase project URL
- `SUPABASE_SERVICE_ROLE_KEY` - Supabase service role key
- `NODE_ENV=production`

### Vercel Deployment (Recommended)
```bash
npm install -g vercel
vercel --prod
```

### Netlify Deployment
```bash
npm install -g netlify-cli
netlify deploy --prod --functions=api
```

### Railway Deployment
```bash
npm install -g @railway/cli
railway login
railway deploy
```

## 🔍 Monitoring & Debugging

### Health Check
```bash
curl http://localhost:3000/health
```

### API Testing
```bash
# Test all endpoints
npm test
```

### Error Handling
- Structured error responses with HTTP status codes
- Detailed error logging for debugging
- Graceful degradation for missing API keys
- Rate limiting with informative responses

## 📱 iOS Integration

### Base URL Configuration
Update your iOS app's `APIConfig.swift` to point to your deployed backend:

```swift
static var rorkFunctionsURL: String {
    #if DEBUG
    return "http://localhost:3000/api"
    #else
    return "https://your-backend-url.com/api"
    #endif
}
```

### API Key Security
- Never expose API keys in client-side code
- Use backend functions to proxy OpenAI calls
- Implement proper authentication and authorization
- Monitor API usage and costs

## 🔒 Security Best Practices

### API Keys
- Store in environment variables only
- Rotate keys regularly
- Monitor usage and costs
- Use different keys for development/production

### Data Protection
- Input validation on all endpoints
- SQL injection prevention with parameterized queries
- Rate limiting to prevent abuse
- HTTPS-only in production

### CORS Configuration
- Configure allowed origins appropriately
- Use secure headers for API requests
- Implement proper authentication flows

## 📈 Performance Optimization

### Response Times
- Request compression enabled
- Efficient database queries
- Response caching where appropriate
- Optimized AI prompt engineering

### Scalability
- Stateless API design
- Database connection pooling
- Load balancing ready
- Horizontal scaling support

## 🛠️ Development

### Adding New Endpoints
1. Create route file in `routes/` directory
2. Define validation schemas with Joi
3. Implement error handling
4. Add comprehensive logging
5. Update API documentation

### Testing
```bash
# Run tests
npm test

# Run specific test file
npm test -- tests/architecture.test.js
```

### Local Development
```bash
# Start with hot reloading
npm run dev

# Start with debugging
DEBUG=true npm start
```

## 📄 Documentation

### API Documentation
Comprehensive API documentation is automatically generated and available at:
- Development: http://localhost:3000/api-docs
- Production: https://your-backend-url.com/api-docs

### Code Documentation
- Inline code comments for all functions
- JSDoc style documentation
- Type definitions for better IDE support
- Example usage in README

## 🎯 Production Considerations

### Monitoring
- Set up application monitoring (Sentry, DataDog, etc.)
- Monitor API usage and costs
- Track performance metrics
- Set up alerting for errors

### Scaling
- Use load balancers for high traffic
- Implement database connection pooling
- Consider serverless functions for auto-scaling
- Monitor resource utilization

### Backup & Recovery
- Regular database backups
- API key rotation procedures
- Disaster recovery planning
- Data export capabilities

## 🤝 Support

### Common Issues
1. **API Key Errors**: Verify OpenAI key format and permissions
2. **Database Connection**: Check Supabase URL and credentials
3. **CORS Issues**: Verify allowed origins in development
4. **Rate Limiting**: Adjust limits based on your needs
5. **Memory Issues**: Monitor Node.js memory usage

### Getting Help
- Check server logs for detailed error messages
- Verify environment variable configuration
- Test individual endpoints with curl or Postman
- Review API documentation for proper usage
- Monitor OpenAI API usage dashboard

## 📄 License

MIT License - Free for commercial and private use

---

**Backend is now production-ready for real AI architecture assistant functionality!** 🏗️✨
