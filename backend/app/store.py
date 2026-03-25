from __future__ import annotations

import os
import uuid
from datetime import datetime, timezone
from typing import Any


class AppStore:
    def __init__(self) -> None:
        self.users: dict[str, dict[str, Any]] = {}
        self.passwords: dict[str, str] = {}
        self.tokens: dict[str, str] = {}
        self.weight_records: dict[str, list[dict[str, Any]]] = {}
        self.kicks: dict[str, list[dict[str, Any]]] = {}
        self.contractions: dict[str, list[dict[str, Any]]] = {}
        self.monitoring_logs: list[dict[str, Any]] = []
        self._seed_demo_users()
        self._supabase = self._init_supabase()

    def _seed_demo_users(self) -> None:
        demo_client_id = "demo-client-1"
        demo_midwife_id = "demo-midwife-1"

        self.users[demo_client_id] = {
            "id": demo_client_id,
            "full_name": "Demo Mama",
            "email": "mama@example.com",
            "role": "client",
            "birthday": "12/08/1996",
            "illnesses": "None",
            "allergies": "None",
            "time_of_pregnancy": "24 weeks",
        }
        self.passwords[demo_client_id] = "123456"

        self.users[demo_midwife_id] = {
            "id": demo_midwife_id,
            "full_name": "Demo Midwife",
            "email": "midwife@example.com",
            "role": "midwife",
        }
        self.passwords[demo_midwife_id] = "123456"

    def _init_supabase(self):
        url = os.getenv("SUPABASE_URL")
        key = os.getenv("SUPABASE_ANON_KEY") or os.getenv("SUPABASE_SERVICE_ROLE_KEY")
        if not url or not key:
            return None

        try:
            from supabase import create_client  # type: ignore

            return create_client(url, key)
        except Exception:
            return None

    @property
    def supabase_enabled(self) -> bool:
        return self._supabase is not None

    def issue_token(self, user_id: str) -> str:
        token = f"local-{uuid.uuid4()}"
        self.tokens[token] = user_id
        return token

    def get_user_by_token(self, token: str) -> dict[str, Any] | None:
        user_id = self.tokens.get(token)
        if not user_id:
            return None
        return self.users.get(user_id)

    def find_user_by_email(self, email: str) -> dict[str, Any] | None:
        normalized = email.strip().lower()
        for user in self.users.values():
            if user["email"].lower() == normalized:
                return user
        return None

    def create_user(self, full_name: str, email: str, password: str, role: str) -> dict[str, Any]:
        user_id = f"local-{uuid.uuid4()}"
        user = {
            "id": user_id,
            "full_name": full_name,
            "email": email.strip().lower(),
            "role": role,
            "birthday": None,
            "illnesses": None,
            "allergies": None,
            "time_of_pregnancy": None,
        }
        self.users[user_id] = user
        self.passwords[user_id] = password
        self._try_supabase_insert_user(user, password)
        return user

    def verify_password(self, user_id: str, password: str) -> bool:
        return self.passwords.get(user_id) == password

    def update_user(self, user_id: str, patch: dict[str, Any]) -> dict[str, Any]:
        user = self.users[user_id]
        user.update(patch)
        self._try_supabase_update_user(user_id, patch)
        return user

    def add_weight(self, user_id: str, weight: float, date: str) -> dict[str, Any]:
        record = {
            "id": str(uuid.uuid4()),
            "weight": weight,
            "date": date,
            "created_at": datetime.now(timezone.utc).isoformat(),
        }
        self.weight_records.setdefault(user_id, []).append(record)
        self._try_supabase_insert("weights", {"user_id": user_id, **record})
        return record

    def list_weight(self, user_id: str) -> list[dict[str, Any]]:
        records = self.weight_records.get(user_id, [])
        return sorted(records, key=lambda item: item.get("date", ""))

    def add_kick(self, user_id: str, timestamp: str) -> dict[str, Any]:
        entry = {
            "id": str(uuid.uuid4()),
            "timestamp": timestamp,
            "created_at": datetime.now(timezone.utc).isoformat(),
        }
        self.kicks.setdefault(user_id, []).append(entry)
        self._try_supabase_insert("kicks", {"user_id": user_id, **entry})
        return entry

    def add_contraction(self, user_id: str, payload: dict[str, Any]) -> dict[str, Any]:
        entry = {
            "id": str(uuid.uuid4()),
            **payload,
            "created_at": datetime.now(timezone.utc).isoformat(),
        }
        self.contractions.setdefault(user_id, []).append(entry)
        self._try_supabase_insert("contractions", {"user_id": user_id, **entry})
        return entry

    def _try_supabase_insert_user(self, user: dict[str, Any], password: str) -> None:
        if not self._supabase:
            return
        self._safe_supabase_call(
            "users",
            {
                "id": user["id"],
                "full_name": user["full_name"],
                "email": user["email"],
                "password": password,
                "role": user["role"],
                "birthday": user.get("birthday"),
                "illnesses": user.get("illnesses"),
                "allergies": user.get("allergies"),
                "time_of_pregnancy": user.get("time_of_pregnancy"),
            },
            op="insert",
        )

    def _try_supabase_update_user(self, user_id: str, patch: dict[str, Any]) -> None:
        if not self._supabase:
            return
        try:
            self._supabase.table("users").update(patch).eq("id", user_id).execute()
        except Exception:
            return

    def _try_supabase_insert(self, table: str, payload: dict[str, Any]) -> None:
        if not self._supabase:
            return
        self._safe_supabase_call(table, payload, op="insert")

    def _safe_supabase_call(self, table: str, payload: dict[str, Any], op: str = "insert") -> None:
        try:
            if op == "insert":
                self._supabase.table(table).insert(payload).execute()
        except Exception:
            return


store = AppStore()