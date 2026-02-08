from typing import Optional
from datetime import datetime
from app.database.firestore import firestore_client
from app.models.user import UserCreate, User
from app.utils.security import get_password_hash, verify_password, create_access_token


class AuthService:
    """Authentication service"""
    
    def __init__(self):
        self.db = firestore_client.db
        self.users_ref = firestore_client.users
    
    async def register_user(self, user_data: UserCreate) -> tuple[User, str]:
        """Register a new user"""
        # Check if username exists
        username_query = self.users_ref.where("username", "==", user_data.username).limit(1).get()
        if len(list(username_query)) > 0:
            raise ValueError("Username already exists")
        
        # Check if email exists
        email_query = self.users_ref.where("email", "==", user_data.email).limit(1).get()
        if len(list(email_query)) > 0:
            raise ValueError("Email already exists")
        
        # Create user document
        user_ref = self.users_ref.document()
        user_id = user_ref.id
        
        user_doc = {
            "user_id": user_id,
            "username": user_data.username,
            "email": user_data.email,
            "password_hash": get_password_hash(user_data.password),
            "created_at": datetime.utcnow().isoformat(),
            "stats": {
                "games_played": 0,
                "games_won": 0,
                "total_score": 0,
                "average_score": 0
            }
        }
        
        user_ref.set(user_doc)
        
        # Create user object (without password hash)
        user = User(
            user_id=user_id,
            username=user_data.username,
            email=user_data.email,
            created_at=user_doc["created_at"],
            stats=user_doc["stats"]
        )
        
        # Generate JWT token
        token = create_access_token(
            data={"sub": user_id, "username": user_data.username}
        )
        
        return user, token
    
    async def login_user(self, email: str, password: str) -> tuple[User, str]:
        """Login a user"""
        # Find user by email
        email_query = self.users_ref.where("email", "==", email).limit(1).get()
        users = list(email_query)
        
        if len(users) == 0:
            raise ValueError("Invalid email or password")
        
        user_doc = users[0].to_dict()
        
        # Verify password
        if not verify_password(password, user_doc["password_hash"]):
            raise ValueError("Invalid email or password")
        
        # Create user object
        user = User(
            user_id=user_doc["user_id"],
            username=user_doc["username"],
            email=user_doc["email"],
            created_at=user_doc["created_at"],
            stats=user_doc.get("stats", {})
        )
        
        # Generate JWT token
        token = create_access_token(
            data={"sub": user.user_id, "username": user.username}
        )
        
        return user, token
    
    async def get_user_by_id(self, user_id: str) -> Optional[User]:
        """Get user by ID"""
        user_ref = self.users_ref.document(user_id)
        user_doc = user_ref.get()
        
        if not user_doc.exists:
            return None
        
        user_data = user_doc.to_dict()
        return User(
            user_id=user_data["user_id"],
            username=user_data["username"],
            email=user_data["email"],
            created_at=user_data["created_at"],
            stats=user_data.get("stats", {})
        )
    
    async def get_or_create_firebase_user(
        self,
        user_id: str,
        email: str,
        username: str
    ) -> User:
        """Get existing user or create from Firebase auth data"""
        # Try to get existing user
        user = await self.get_user_by_id(user_id)
        
        if user is None:
            # Create new user from Firebase data
            user_doc = {
                "user_id": user_id,
                "username": username,
                "email": email,
                "created_at": datetime.utcnow().isoformat(),
                "stats": {
                    "games_played": 0,
                    "games_won": 0,
                    "total_score": 0,
                    "average_score": 0
                }
            }
            
            # Save to Firestore
            self.users_ref.document(user_id).set(user_doc)
            
            # Create user object
            user = User(
                user_id=user_id,
                username=username,
                email=email,
                created_at=user_doc["created_at"],
                stats=user_doc["stats"]
            )
        
        return user


# Singleton instance
auth_service = AuthService()
