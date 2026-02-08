from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from app.models.user import UserCreate, UserLogin, User, Token
from app.services.auth_service import auth_service
from app.utils.security import decode_access_token
import firebase_admin
from firebase_admin import auth as firebase_auth, credentials
from app.config import settings
import os

router = APIRouter()
security = HTTPBearer()

# Initialize Firebase Admin SDK (only once)
firebase_initialized = False
try:
    firebase_admin.get_app()
    firebase_initialized = True
    print("✅ Firebase Admin SDK already initialized")
except ValueError:
    # App not initialized, try to initialize it
    try:
        if os.path.exists(settings.firebase_credentials_path):
            cred = credentials.Certificate(settings.firebase_credentials_path)
            firebase_admin.initialize_app(cred)
            firebase_initialized = True
            print("✅ Firebase Admin SDK initialized successfully")
        else:
            print(f"⚠️  Firebase credentials file not found at: {settings.firebase_credentials_path}")
            print("⚠️  Firebase authentication will not work")
    except Exception as e:
        print(f"⚠️  Failed to initialize Firebase Admin SDK: {e}")
        print("⚠️  Firebase authentication will not work")


async def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security)) -> User:
    """Get current authenticated user from Firebase ID token"""
    token = credentials.credentials
    
    if not firebase_initialized:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Firebase authentication is not configured. Please contact administrator.",
        )
    
    try:
        # Verify Firebase ID token
        decoded_token = firebase_auth.verify_id_token(token)
        user_id = decoded_token['uid']
        email = decoded_token.get('email', 'user@codequest.com')
        name = decoded_token.get('name') or decoded_token.get('email', 'Player').split('@')[0]
        
        # Get or create user in Firestore
        user = await auth_service.get_or_create_firebase_user(
            user_id=user_id,
            email=email,
            username=name
        )
        return user
        
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Invalid Firebase token: {str(e)}",
            headers={"WWW-Authenticate": "Bearer"},
        )


@router.post("/register", response_model=dict, status_code=status.HTTP_201_CREATED)
async def register(user_data: UserCreate):
    """Register a new user (legacy endpoint - use Firebase Auth instead)"""
    try:
        user, token = await auth_service.register_user(user_data)
        return {
            "user_id": user.user_id,
            "username": user.username,
            "email": user.email,
            "token": token,
            "token_type": "bearer"
        }
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/login", response_model=dict)
async def login(credentials: UserLogin):
    """Login a user (legacy endpoint - use Firebase Auth instead)"""
    try:
        user, token = await auth_service.login_user(
            credentials.email,
            credentials.password
        )
        return {
            "user_id": user.user_id,
            "username": user.username,
            "email": user.email,
            "token": token,
            "token_type": "bearer"
        }
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=str(e)
        )


@router.get("/me", response_model=User)
async def get_current_user_info(current_user: User = Depends(get_current_user)):
    """Get current user information"""
    return current_user
