from datetime import date
from typing import Any

from fastapi import APIRouter, Depends, HTTPException, Response
from pydantic import BaseModel, EmailStr

from app.routers.security import get_current_user
from app.schemas.auth import AuthResponse, GoogleAuthRequest, LoginRequest, RegisterRequest, UserOut
from app.store import store

router = APIRouter(tags=["Mobile Auth"])


class ProfilePatch(BaseModel):
	birthday: str | None = None
	illnesses: str | None = None
	allergies: str | None = None
	time_of_pregnancy: str | None = None


class WeightPayload(BaseModel):
	weight: float
	date: str


class KickPayload(BaseModel):
	timestamp: str


class ContractionPayload(BaseModel):
	duration_seconds: int
	interval_seconds: int
	timestamp: str


@router.post("/auth/register", response_model=AuthResponse)
async def register(payload: RegisterRequest) -> dict[str, Any]:
	if store.find_user_by_email(payload.email):
		raise HTTPException(status_code=400, detail="Email already registered")

	user = store.create_user(
		full_name=payload.full_name,
		email=payload.email,
		password=payload.password,
		role=payload.role.value,
	)
	token = store.issue_token(user["id"])
	return {"access_token": token, "token_type": "bearer", "user": user}


@router.post("/auth/login", response_model=AuthResponse)
async def login(payload: LoginRequest) -> dict[str, Any]:
	user = store.find_user_by_email(payload.email)
	if not user or not store.verify_password(user["id"], payload.password):
		raise HTTPException(status_code=401, detail="Invalid email or password")

	token = store.issue_token(user["id"])
	return {"access_token": token, "token_type": "bearer", "user": user}


@router.post("/auth/google", response_model=AuthResponse)
async def google_auth(payload: GoogleAuthRequest) -> dict[str, Any]:
	if not payload.id_token:
		raise HTTPException(status_code=400, detail="Missing id_token")

	synthetic_email = f"google_{payload.id_token[:8]}@mamaconnnect.local".replace(" ", "")
	user = store.find_user_by_email(synthetic_email)
	if not user:
		user = store.create_user(
			full_name="Google User",
			email=synthetic_email,
			password="google-oauth",
			role="client",
		)

	token = store.issue_token(user["id"])
	return {"access_token": token, "token_type": "bearer", "user": user}


@router.get("/users/me", response_model=UserOut)
async def get_me(current_user: dict = Depends(get_current_user)) -> dict[str, Any]:
	return current_user


@router.patch("/users/me", response_model=UserOut)
async def patch_me(
	payload: ProfilePatch,
	current_user: dict = Depends(get_current_user),
) -> dict[str, Any]:
	patch = payload.model_dump(exclude_none=True)
	updated = store.update_user(current_user["id"], patch)
	return updated


@router.get("/pregnancy/status")
async def pregnancy_status(current_user: dict = Depends(get_current_user)) -> dict[str, Any]:
	stage = current_user.get("time_of_pregnancy") or "24 weeks"
	return {
		"status": "stable",
		"week": stage,
		"next_checkup": str(date.today()),
		"tips": [
			"Stay hydrated",
			"Track movements daily",
			"Contact your midwife if symptoms worsen",
		],
	}


@router.get("/reports/pdf")
async def reports_pdf(current_user: dict = Depends(get_current_user)) -> Response:
	text = (
		"MamaConnect Health Report\n"
		f"User: {current_user.get('full_name')}\n"
		f"Email: {current_user.get('email')}\n"
		f"Pregnancy: {current_user.get('time_of_pregnancy') or 'N/A'}\n"
	)
	return Response(
		content=text.encode("utf-8"),
		media_type="application/pdf",
		headers={"Content-Disposition": "attachment; filename=health-report.pdf"},
	)


@router.post("/weight")
async def add_weight(
	payload: WeightPayload,
	current_user: dict = Depends(get_current_user),
) -> dict[str, Any]:
	record = store.add_weight(current_user["id"], payload.weight, payload.date)
	return {"message": "Weight logged", "record": record}


@router.get("/weight")
async def get_weight(current_user: dict = Depends(get_current_user)) -> dict[str, Any]:
	return {"records": store.list_weight(current_user["id"])}


@router.post("/kicks")
async def log_kick(
	payload: KickPayload,
	current_user: dict = Depends(get_current_user),
) -> dict[str, Any]:
	entry = store.add_kick(current_user["id"], payload.timestamp)
	return {"message": "Kick recorded", "entry": entry}


@router.post("/contractions")
async def log_contraction(
	payload: ContractionPayload,
	current_user: dict = Depends(get_current_user),
) -> dict[str, Any]:
	entry = store.add_contraction(current_user["id"], payload.model_dump())
	return {"message": "Contraction recorded", "entry": entry}


@router.post("/auth/forgot-password")
async def forgot_password(body: dict[str, EmailStr]) -> dict[str, str]:
	return {"message": "Reset flow mocked. Use normal login for now."}
