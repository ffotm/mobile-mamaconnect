# app/schemas/auth.py
from pydantic import BaseModel, EmailStr
from typing import Optional
from enum import Enum


class UserRole(str, Enum):
    client = "client"
    midwife = "midwife"


# ── Request bodies ────────────────────────────────────────────────────────────

class RegisterRequest(BaseModel):
    full_name: str
    email: EmailStr
    password: str
    role: UserRole = UserRole.client

    model_config = {
        "json_schema_extra": {
            "example": {
                "full_name": "Yasmine Bensalem",
                "email": "yasmine@example.com",
                "password": "secret123",
                "role": "client"
            }
        }
    }


class LoginRequest(BaseModel):
    email: EmailStr
    password: str


class GoogleAuthRequest(BaseModel):
    id_token: str  # Google ID token from the client


# ── Response bodies ───────────────────────────────────────────────────────────

class UserOut(BaseModel):
    id: str
    full_name: str
    email: str
    role: UserRole
    birthday: Optional[str] = None
    illnesses: Optional[str] = None
    allergies: Optional[str] = None
    time_of_pregnancy: Optional[str] = None
    weight_kg: Optional[float] = None
    height_cm: Optional[float] = None
    blood_type: Optional[str] = None
    phone: Optional[str] = None


class AuthResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserOut


# ── Update profile ────────────────────────────────────────────────────────────

class UpdateProfileRequest(BaseModel):
    full_name: Optional[str] = None
    birthday: Optional[str] = None
    illnesses: Optional[str] = None
    allergies: Optional[str] = None
    time_of_pregnancy: Optional[str] = None
    weight_kg: Optional[float] = None
    height_cm: Optional[float] = None
    blood_type: Optional[str] = None
    phone: Optional[str] = None