# MamaConnect Mobile Backend

This backend lives inside the Flutter project and is tailored to the API contract used by `lib/services/api_service.dart`.

## What it provides

- Exact endpoints used by the mobile app:
  - `POST /auth/register`
  - `POST /auth/login`
  - `POST /auth/google`
  - `GET /users/me`
  - `PATCH /users/me`
  - `GET /pregnancy/status`
  - `GET /reports/pdf`
  - `POST /weight`, `GET /weight`
  - `POST /kicks`
  - `POST /contractions`
- Dummy endpoints for missing features (Bluetooth, monitoring, booking, midwife/admin/content).
- Mock-first behavior (works without DB/tables).
- Optional Supabase insert/update attempts when env vars are present.

## Run locally

```bash
cd front/mobile-mamaconnect/backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Open docs at:
- http://127.0.0.1:8000/docs

## Demo credentials

- Client: `mama@example.com` / `123456`
- Midwife: `midwife@example.com` / `123456`

## Optional Supabase

Set these env vars to enable best-effort Supabase sync:

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY` or `SUPABASE_SERVICE_ROLE_KEY`

If tables do not exist yet, the API still works using in-memory mock data.
