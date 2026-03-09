<div align="center">

# Mamaconnect

**A full-stack pregnancy companion app for mothers and midwives**

*Flutter · FastAPI · Supabase*

---

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=flat-square&logo=dart&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-0.111-009688?style=flat-square&logo=fastapi&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-2.x-3ECF8E?style=flat-square&logo=supabase&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.11+-3776AB?style=flat-square&logo=python&logoColor=white)

</div>

---

## Overview

Mamaconnect is a mobile pregnancy companion designed for expectant mothers in Algeria and the wider MENA region. It pairs a Flutter mobile app with a FastAPI + Supabase backend to give mothers real-time health monitoring, a personalised 40-week pregnancy timeline, access to midwives, and evidence-based health guidance — all in one place.

The app also includes a **Midwife Dashboard** for healthcare providers to monitor their clients remotely, manage appointments, and send advice through an in-app chat.

---

## Features

### For Mothers

| Feature | Description |
|---|---|
| **Pregnancy Timeline** | Full 40-week visual timeline with week-by-week baby milestones, maternal body changes, and tips. Interleaved appointment and vaccination reminders with booking and alert buttons. |
| **Live Monitor** | Real-time heart rate, SpO₂, temperature, movement and kick counter via Bluetooth wearable belt. Animated heartbeat waveform. |
| **Log History** | Graphs, manual entry, and reading history for all sensor data. Weekly summaries with alert highlighting. |
| **Safe Medicines** | Searchable medicine database with safety levels (Safe / Caution / Unsafe). Drug safety checker supports brand names, generics, and French/Arabic names (Doliprane, Flagyl, etc.). |
| **Symptom Tracker** | Select from 16 categorised symptoms with severity slider. Returns matched diet, workout, and medicine recommendations. Includes AI assistant button. |
| **Recommended Diets** | Trimester-filtered recipes with nutrient tags (Iron-Rich, Omega-3, Protein). Premium content gating. |
| **Workout Plans** | Personalised workout recommendations based on goal and physical condition. Step-by-step instructions with safety warnings. |
| **Hospitals Nearby** | Searchable list of nearby hospitals sorted by distance with call and GPS directions. |
| **Midwives Directory** | Browse and book certified midwives. 3-step booking flow with payment. |
| **Vaccination Alerts** | Home screen banner showing upcoming required vaccines (Tdap, Flu, Booking Bloods) with due-week labels and dismissable cards. |
| **Profile + BMI** | Editable profile with live BMI calculator, blood type, allergies and medical history. |
| **Shop** | Three subscription bundle plans (Basic / Pro / Premium) with order form. |

### For Midwives

| Feature | Description |
|---|---|
| **Client Dashboard** | View all clients' latest sensor readings and health logs. |
| **Appointment Requests** | Accept or decline client booking requests. |
| **In-App Advice Chat** | Send personalised guidance and advice to clients directly in the app. |
| **Overview Statistics** | Activity feed, client counts, and summary metrics. |

--
## Tech Stack

### Mobile (Flutter)

```
lib/
├── constants/          # Colors, text styles, routes, spacing
├── models/             # User model
├── services/           # API service (HTTP client), AuthProvider (Provider)
├── widgets/            # Reusable: CustomTextField, PrimaryButton, FeatureCard
└── screens/
    ├── splash/
    ├── auth/           # Sign in, register, forgot password (3-step OTP + strength meter)
    ├── onboarding/
    ├── home/           # Wave header, vaccination alerts, feature grid
    ├── timeline/       # Full 40-week timeline with appointments and vaccines
    ├── bluetooth/      # Device pairing (4 animated states)
    ├── monitor/        # Live sensor dashboard
    ├── graphs/         # Charts and weekly data
    ├── alerts/         # Severity-filtered alerts with unread badges
    ├── logs/           # Reading history, manual entry
    ├── medicines/      # Medicine list + drug safety checker
    ├── diet/           # Recipes with trimester filters
    ├── workouts/       # Personalised workout plans
    ├── symptoms/       # Symptom tracker + AI recommendations
    ├── midwives/       # Directory + profile + booking
    ├── contact/        # 3-step booking + payment
    ├── profile/        # Editable profile + BMI
    ├── shop/           # Subscription plans
    ├── midwife_dashboard/
    └── hospitals/      # Nearby hospitals with GPS
```

**Key packages:**

| Package | Version | Purpose |
|---|---|---|
| `provider` | ^6.1.1 | State management |
| `http` | ^1.1.0 | API calls |
| `shared_preferences` | ^2.2.2 | Token persistence |
| `google_fonts` | ^6.1.0 | Typography (Poppins) |
| `google_sign_in` | ^6.1.6 | OAuth login |
| `url_launcher` | ^6.2.5 | Maps + phone calls |
| `percent_indicator` | ^4.2.3 | Progress rings |
| `flutter_svg` | ^2.0.9 | Vector assets |
| `intl` | ^0.18.1 | Date formatting |

---

### Backend (FastAPI + Supabase)

```
mamaconnect_backend/
├── app/
│   ├── main.py              # FastAPI app, CORS, router registration
│   ├── core/
│   │   ├── config.py        # .env config via pydantic-settings
│   │   ├── supabase.py      # Anon client (RLS) + admin client (service role)
│   │   └── security.py      # bcrypt hashing, JWT create/decode, auth deps
│   ├── routers/
│   │   ├── auth.py          # Register, login, Google OAuth, profile
│   │   ├── monitor.py       # Sensor readings, kicks, contractions, settings
│   │   ├── alerts.py        # Alert list, mark read, mark all read
│   │   └── midwife.py       # Client list, requests, messages
│   └── schemas/
│       └── auth.py          # Pydantic request/response models
├── schema.sql               # All tables + RLS policies
├── requirements.txt
└── .env.example
```

**Key packages:** `fastapi`, `uvicorn`, `supabase-py`, `python-jose`, `passlib[bcrypt]`, `pydantic-settings`, `httpx`

---

## Database Schema (Supabase)

| Table | Description |
|---|---|
| `users` | id, full_name, email, password_hash, role (client/midwife), phone, birthday, illnesses, allergies, pregnancy_weeks, weight_kg, height_cm, blood_type |
| `user_settings` | update_interval_hours, notifications_enabled |
| `sensor_readings` | heart_rate, temperature, spo2, movement, timestamp |
| `kick_logs` | timestamp, notes |
| `contractions` | duration_seconds, interval_seconds, intensity |
| `alerts` | title, description, severity (critical/warning/info), is_read |
| `midwife_clients` | midwife_id, client_id, status (pending/accepted/declined) |
| `messages` | sender_id, receiver_id, text, is_read |

All tables have **Row-Level Security (RLS)** enabled. The FastAPI service role bypasses RLS for trusted server-side operations.

**Auto-alert thresholds** (triggered on every sensor reading save):

| Condition | Severity |
|---|---|
| Heart rate > 160 bpm | Critical |
| Temperature > 37.5 °C | Warning |
| SpO₂ < 95% | Critical |

---

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.0
- Dart SDK ≥ 3.0
- Python 3.11+
- A [Supabase](https://supabase.com) project

---

### 1. Supabase Setup

1. Create a new project at [supabase.com](https://supabase.com)
2. Go to **SQL Editor** and paste the contents of `mamaconnect_backend/schema.sql`
3. Click **Run** to create all tables and policies
4. Copy your three keys from **Settings → API**:
   - `Project URL`
   - `anon` public key
   - `service_role` secret key

---

### 2. Backend Setup

```bash
cd backend

# Create and activate virtual environment
python -m venv venv
source venv/bin/activate          # Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Configure environment
cp .env.example .env
```

Edit `.env`:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
JWT_SECRET=your-secret-key          # generate: openssl rand -hex 32
JWT_ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=10080   # 7 days
```

Start the server:

```bash
uvicorn app.main:app --reload --port 8000
```

API docs available at: **http://localhost:8000/docs**

---

### 3. Flutter App Setup

```bash
cd mamaconnect

# Install dependencies
flutter pub get

# Run the app
flutter run
```

#### Connect to Backend

Open `lib/services/api_service.dart` and update `baseUrl`:

```dart
// Android emulator
static const String baseUrl = 'http://10.0.2.2:8000';

// iOS simulator
static const String baseUrl = 'http://localhost:8000';

// Physical device (same WiFi network)
static const String baseUrl = 'http://192.168.x.x:8000';

// Production
static const String baseUrl = 'https://your-api.com';
```

---

## Authentication Flow

```
User registers / logs in
        ↓
FastAPI verifies credentials
        ↓
Issues JWT (sub = user_id, role = client | midwife)
        ↓
Flutter saves token in SharedPreferences
        ↓
Every request: Authorization: Bearer <token>
        ↓
get_current_user() dependency decodes JWT → injects {id, role}
        ↓
Role guards: require_midwife() / require_client()
```

**Google OAuth:** Flutter sends Google ID token → FastAPI verifies with Google tokeninfo endpoint → find-or-create user → issue JWT.

---

## Deployment

### Backend — Railway (recommended)

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login and deploy
railway login
railway init
railway up
```

Set environment variables in the Railway dashboard (same keys as `.env`).

**Alternatives:** Render, Fly.io, any VPS with Python support.

### App — Play Store / App Store

```bash
# Android release build
flutter build apk --release
flutter build appbundle --release

# iOS release build
flutter build ios --release
```

---

## Roadmap

- [ ] Weight tracker with growth graph
- [ ] Tummy/fundal height tracker
- [ ] Blood pressure monitor screen
- [ ] Exportable health PDF report
- [ ] Full AI chatbot screen
- [ ] Push notifications (FCM)
- [ ] Arabic / French localisation
- [ ] Offline mode with local SQLite cache
- [ ] Bluetooth belt SDK integration

---

## Project Structure Summary

```
mamaconnect/                   ← Flutter app
├── lib/
│   ├── constants/
│   ├── models/
│   ├── services/
│   ├── widgets/
│   └── screens/            ← 20+ screens
├── assets/
│   ├── images/
│   └── fonts/
└── pubspec.yaml

backend/            ← FastAPI backend
├── app/
│   ├── core/
│   ├── routers/
│   └── schemas/
├── schema.sql
├── requirements.txt
└── .env.example
```

---

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m 'Add your feature'`
4. Push to the branch: `git push origin feature/your-feature`
5. Open a Pull Request

---

## License

This project is proprietary and built for the MamaConnect hackathon. All rights reserved.

---

<div align="center">
Built with care for mothers everywhere
</div>