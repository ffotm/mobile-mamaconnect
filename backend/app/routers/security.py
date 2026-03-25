from fastapi import Depends, HTTPException
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

from app.store import store

security = HTTPBearer(auto_error=False)


def get_current_user(
	credentials: HTTPAuthorizationCredentials | None = Depends(security),
) -> dict:
	if credentials is None:
		raise HTTPException(status_code=401, detail="Missing authorization token")

	token = credentials.credentials
	user = store.get_user_by_token(token)
	if not user:
		raise HTTPException(status_code=401, detail="Invalid or expired token")

	return user
