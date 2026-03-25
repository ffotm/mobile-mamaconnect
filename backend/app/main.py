from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.routers import auth, monitor, midwife, alerts

app = FastAPI(
    title="MamaConnect Mobile Backend",
    description="Mock-first backend for Flutter app development with optional Supabase sync.",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/", tags=["Health"])
async def root() -> dict:
    return {
        "message": "Backend is running",
        "mode": "mock-first",
        "docs": "/docs",
    }


@app.get("/health", tags=["Health"])
async def health() -> dict:
    return {"status": "healthy"}


app.include_router(auth.router)
app.include_router(monitor.router)
app.include_router(midwife.router)
app.include_router(alerts.router)