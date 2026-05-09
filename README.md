# ArchAI Planner

ArchAI Planner is a starter MVP for an AI-powered iPhone architecture planning app. It helps users capture early project requirements, generate architectural design suggestions, review saved concepts, and ask an AI assistant architecture questions.

## Current Rork build

This workspace is configured as a native iOS Swift app in Rork. The product structure mirrors the requested Expo MVP: welcome/auth, dashboard, create design, generated results, AI chat, gallery, profile, Supabase persistence scaffold, and secure AI backend endpoint scaffold.

## Features

- Luxury dark interface with gold and white accents
- Welcome, login, and signup flow
- Home dashboard with saved design projects
- Create Design form for land size, floors, bedrooms, majlis options, garden, pool, style, and requirements
- Generated AI-style architectural output:
  - Space distribution
  - Suggested room layout
  - Entrance ideas
  - Design style description
  - Practical improvement suggestions
- AI architecture chat assistant screen
- Gallery of saved concepts with blueprint-style cards
- Profile screen
- Supabase REST client scaffold for saving projects
- AI service scaffold for backend OpenAI endpoints

## Environment variables

Create a `.env` file from `.env.example` and fill in your real values.

```bash
cp .env.example .env
```

For production, keep your OpenAI API key on a backend only. The mobile app should call backend endpoints such as:

- `POST /generate-architecture`
- `POST /architecture-chat`

## Supabase table suggestion

Create a `projects` table with columns similar to:

- `id uuid primary key`
- `user_id uuid references auth.users(id)`
- `title text`
- `style text`
- `land_size text`
- `floors text`
- `bedrooms text`
- `result jsonb`
- `created_at timestamptz default now()`

Enable Row Level Security and add policies so users can only read/write their own projects.

## Running the app in Rork

Open the iOS preview in Rork. The app is ready for the native iPhone simulator preview.

## Expo Go note

The requested Expo/React Native structure is included as a product requirement, but this Rork workspace was initialized as native iOS, so the runnable implementation here is Swift. If you want, the same screens and service boundaries can be ported to a fresh Expo project with `expo-router`, `@supabase/supabase-js`, and API routes.
