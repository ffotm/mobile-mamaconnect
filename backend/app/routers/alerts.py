from datetime import datetime, timezone
from typing import Any

from fastapi import APIRouter

router = APIRouter(tags=["Content & Admin"])


@router.get("/alerts")
async def get_alerts() -> dict[str, Any]:
	return {
		"alerts": [
			{
				"id": "al-1",
				"level": "info",
				"message": "Dummy alert stream active",
				"timestamp": datetime.now(timezone.utc).isoformat(),
			}
		]
	}


@router.get("/articles/")
async def articles_list() -> dict[str, Any]:
	return {
		"items": [
			{"id": 1, "title": "Healthy Pregnancy Basics"},
			{"id": 2, "title": "How to Track Baby Kicks"},
		]
	}


@router.get("/articles/faqs")
async def articles_faqs() -> dict[str, Any]:
	return {
		"faqs": [
			{"q": "How much water should I drink?", "a": "Usually 2L/day unless advised otherwise."}
		]
	}


@router.get("/articles/search")
async def articles_search(q: str = "") -> dict[str, Any]:
	return {"query": q, "results": [{"id": 1, "title": "Result for " + q}] if q else []}


@router.get("/profile/")
async def profile_get() -> dict[str, Any]:
	return {"name": "Demo Mama", "email": "mama@example.com", "role": "client"}


@router.put("/profile/")
async def profile_update(payload: dict[str, Any]) -> dict[str, Any]:
	return {"message": "Profile updated", "profile": payload}


@router.get("/admin/dashboard")
async def admin_dashboard() -> dict[str, Any]:
	return {"users": 120, "midwives": 18, "active_subscriptions": 56}


@router.get("/admin/users")
async def admin_users() -> dict[str, Any]:
	return {"users": [{"id": 1, "name": "Demo Mama", "role": "client"}]}


@router.get("/admin/articles")
async def admin_articles() -> dict[str, Any]:
	return {"articles": [{"id": 1, "title": "Healthy Pregnancy Basics"}]}


@router.get("/admin/settings")
async def admin_settings() -> dict[str, Any]:
	return {"maintenance": False, "dummy_mode": True}


@router.get("/admin/analytics/users")
async def admin_analytics_users() -> dict[str, Any]:
	return {"daily_active": 43, "new_signups": 7}


@router.get("/admin/audit-logs")
async def admin_audit_logs() -> dict[str, Any]:
	return {
		"logs": [
			{
				"id": "log-1",
				"action": "dummy_access",
				"at": datetime.now(timezone.utc).isoformat(),
			}
		]
	}
