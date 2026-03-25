from datetime import datetime, timezone
from typing import Any

from fastapi import APIRouter
from pydantic import BaseModel

from app.store import store

router = APIRouter(tags=["Monitoring"])


class BeltDataPayload(BaseModel):
	user_id: int | str
	description: str
	value: float
	timestamp: str | None = None


class BluetoothConnectPayload(BaseModel):
	device_id: str


@router.get("/monitoring/belt")
async def get_belt_status() -> dict[str, Any]:
	return {
		"connected": True,
		"device": "MamaBand v1 (dummy)",
		"heartbeat": 142,
		"temperature": 36.8,
		"signal": "good",
	}


@router.post("/monitoring/belt/data")
async def add_belt_data(payload: BeltDataPayload) -> dict[str, Any]:
	item = payload.model_dump()
	item["timestamp"] = item.get("timestamp") or datetime.now(timezone.utc).isoformat()
	store.monitoring_logs.append(item)
	return {"message": "Monitoring data received", "data": item}


@router.get("/monitoring/belt/logs")
async def belt_logs() -> dict[str, Any]:
	return {"logs": store.monitoring_logs[-50:]}


@router.get("/bluetooth/status")
async def bluetooth_status() -> dict[str, Any]:
	return {
		"enabled": True,
		"connected": True,
		"connected_device": {
			"id": "dummy-belt-01",
			"name": "Mama Belt Demo",
			"battery": 87,
		},
	}


@router.get("/bluetooth/devices")
async def bluetooth_devices() -> dict[str, Any]:
	return {
		"devices": [
			{"id": "dummy-belt-01", "name": "Mama Belt Demo", "rssi": -48},
			{"id": "dummy-belt-02", "name": "Mama Belt Spare", "rssi": -61},
			{"id": "dummy-oximeter-01", "name": "Pulse Oximeter", "rssi": -71},
		]
	}


@router.post("/bluetooth/connect")
async def bluetooth_connect(payload: BluetoothConnectPayload) -> dict[str, Any]:
	return {
		"message": "Connected",
		"device": {
			"id": payload.device_id,
			"name": "Dummy Device",
			"connected_at": datetime.now(timezone.utc).isoformat(),
		},
	}
