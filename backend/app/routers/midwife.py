from datetime import date, datetime, timedelta, timezone
from typing import Any

from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter(tags=["Midwife & Client"])


class BookingCreatePayload(BaseModel):
	midwife_id: int
	appointment_date: datetime
	notes: str | None = None


class SubscribePayload(BaseModel):
	plan_id: int
	payment_method: str


class ChatSessionPayload(BaseModel):
	user_id: int


class ChatMessagePayload(BaseModel):
	session_id: int
	message: str


@router.get("/dashboard/pregnancy-info")
async def dashboard_pregnancy_info() -> dict[str, Any]:
	return {
		"week": 24,
		"baby_size": "Corn",
		"next_appointment": (date.today() + timedelta(days=10)).isoformat(),
		"risk_level": "low",
	}


@router.get("/subscription/plans")
async def subscription_plans() -> dict[str, Any]:
	return {
		"plans": [
			{"id": 1, "name": "Basic", "price": 0, "interval": "month"},
			{"id": 2, "name": "Premium", "price": 9.99, "interval": "month"},
			{"id": 3, "name": "Pro", "price": 79.0, "interval": "year"},
		]
	}


@router.get("/subscription/plans/{plan_id}")
async def subscription_plan_details(plan_id: int) -> dict[str, Any]:
	return {
		"id": plan_id,
		"name": "Premium" if plan_id == 2 else "Basic",
		"features": ["AI chat", "Monitoring insights", "Midwife support"],
	}


@router.post("/subscription/subscribe")
async def subscription_subscribe(payload: SubscribePayload) -> dict[str, Any]:
	return {
		"message": "Subscription activated (dummy)",
		"plan_id": payload.plan_id,
		"payment_method": payload.payment_method,
	}


@router.get("/subscription/current")
async def subscription_current() -> dict[str, Any]:
	return {"active": True, "plan": {"id": 2, "name": "Premium"}}


@router.post("/subscription/cancel")
async def subscription_cancel() -> dict[str, Any]:
	return {"message": "Subscription canceled (dummy)"}


@router.get("/subscription/history")
async def subscription_history() -> dict[str, Any]:
	return {
		"history": [
			{
				"id": "subh-1",
				"plan": "Premium",
				"status": "active",
				"started_at": datetime.now(timezone.utc).isoformat(),
			}
		]
	}


@router.get("/booking/midwives")
async def booking_midwives() -> dict[str, Any]:
	return {
		"midwives": [
			{"id": 1, "name": "Amina Benali", "rating": 4.8},
			{"id": 2, "name": "Sara Othman", "rating": 4.7},
		]
	}


@router.post("/booking/create")
async def booking_create(payload: BookingCreatePayload) -> dict[str, Any]:
	return {
		"message": "Booking created (dummy)",
		"booking": {
			"id": 1001,
			"midwife_id": payload.midwife_id,
			"appointment_date": payload.appointment_date.isoformat(),
			"notes": payload.notes,
			"status": "confirmed",
		},
	}


@router.get("/booking/my-bookings")
async def booking_my_bookings() -> dict[str, Any]:
	return {
		"bookings": [
			{
				"id": 1001,
				"midwife": "Amina Benali",
				"appointment_date": (datetime.now(timezone.utc) + timedelta(days=7)).isoformat(),
				"status": "confirmed",
			}
		]
	}


@router.get("/booking/{booking_id}")
async def booking_details(booking_id: int) -> dict[str, Any]:
	return {
		"id": booking_id,
		"midwife": "Amina Benali",
		"appointment_date": (datetime.now(timezone.utc) + timedelta(days=7)).isoformat(),
		"status": "confirmed",
	}


@router.put("/booking/{booking_id}/cancel")
async def booking_cancel(booking_id: int) -> dict[str, Any]:
	return {"message": "Booking canceled", "booking_id": booking_id, "status": "canceled"}


@router.get("/booking/midwife/availability/{midwife_id}")
async def booking_midwife_availability(midwife_id: int, date: str) -> dict[str, Any]:
	return {
		"midwife_id": midwife_id,
		"date": date,
		"slots": ["09:00", "10:00", "14:00", "16:00"],
	}


@router.post("/chat/session")
async def chat_create_session(payload: ChatSessionPayload) -> dict[str, Any]:
	return {"session_id": payload.user_id * 100 + 1, "status": "created"}


@router.post("/chat/")
async def chat_message(payload: ChatMessagePayload) -> dict[str, Any]:
	return {
		"session_id": payload.session_id,
		"reply": "Thanks for sharing. Keep monitoring and stay hydrated.",
	}


@router.get("/chat/session/{session_id}")
async def chat_history(session_id: int) -> dict[str, Any]:
	return {
		"session_id": session_id,
		"messages": [
			{"from": "user", "text": "I feel tired today."},
			{"from": "bot", "text": "Rest and drink water. Contact your midwife if needed."},
		],
	}


@router.get("/midwife/dashboard")
async def midwife_dashboard() -> dict[str, Any]:
	return {"clients_count": 12, "appointments_today": 4, "alerts": 2}


@router.get("/midwife/clients")
async def midwife_clients() -> dict[str, Any]:
	return {
		"clients": [
			{"id": 1, "name": "Client A", "pregnancy_week": 24},
			{"id": 2, "name": "Client B", "pregnancy_week": 30},
		]
	}


@router.get("/midwife/profile")
async def midwife_profile() -> dict[str, Any]:
	return {"id": 1, "name": "Demo Midwife", "specialty": "Prenatal monitoring"}


@router.put("/midwife/profile")
async def update_midwife_profile(payload: dict[str, Any]) -> dict[str, Any]:
	return {"message": "Profile updated", "profile": payload}


@router.get("/midwife/bookings")
async def midwife_bookings() -> dict[str, Any]:
	return {"bookings": [{"id": 1001, "client": "Client A", "status": "confirmed"}]}


@router.post("/midwife/license")
async def submit_midwife_license(payload: dict[str, Any]) -> dict[str, Any]:
	return {"message": "License submitted (dummy)", "payload": payload}


@router.get("/midwife/directory")
async def midwife_directory() -> dict[str, Any]:
	return {"midwives": [{"id": 1, "name": "Amina Benali"}, {"id": 2, "name": "Sara Othman"}]}


@router.get("/midwife/directory/{midwife_id}")
async def midwife_directory_item(midwife_id: int) -> dict[str, Any]:
	return {"id": midwife_id, "name": "Demo Midwife", "experience_years": 7}


@router.get("/midwife/availability")
async def midwife_availability() -> dict[str, Any]:
	return {"slots": ["09:00", "11:00", "13:00", "15:00"]}
