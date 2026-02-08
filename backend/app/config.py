import os
from typing import List
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """Application settings"""
    
    # Firebase
    firebase_credentials_path: str = "./serviceAccountKey.json"
    
    # JWT
    jwt_secret_key: str = "dev-secret-key-change-in-production"
    jwt_algorithm: str = "HS256"
    jwt_expiration_hours: int = 24
    
    # Quiz API
    quiz_api_url: str = "https://opentdb.com/api.php"
    
    # CORS - Allow all origins for development
    cors_origins: List[str] = ["*"]
    
    # Environment
    environment: str = "development"
    log_level: str = "INFO"
    
    # Server
    host: str = "0.0.0.0"
    port: int = 8000


settings = Settings()
