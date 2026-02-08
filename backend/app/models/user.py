from pydantic import BaseModel, EmailStr, Field


class UserCreate(BaseModel):
    """User registration model"""
    username: str = Field(..., min_length=3, max_length=20)
    email: EmailStr
    password: str = Field(..., min_length=8)


class UserLogin(BaseModel):
    """User login model"""
    email: EmailStr
    password: str


class User(BaseModel):
    """User model"""
    user_id: str
    username: str
    email: str
    created_at: str
    stats: dict = {
        "games_played": 0,
        "games_won": 0,
        "total_score": 0,
        "average_score": 0
    }


class Token(BaseModel):
    """JWT token model"""
    access_token: str
    token_type: str = "bearer"


class TokenData(BaseModel):
    """Token payload data"""
    user_id: str
    username: str
