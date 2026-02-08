import firebase_admin
from firebase_admin import credentials, firestore
from app.config import settings
import os


class FirestoreClient:
    """Firestore database client"""
    
    _instance = None
    _db = None
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance
    
    def __init__(self):
        if self._db is None:
            self._initialize()
    
    def _initialize(self):
        """Initialize Firebase Admin SDK"""
        try:
            # Check if already initialized
            firebase_admin.get_app()
        except ValueError:
            # Initialize if not already done
            cred_path = settings.firebase_credentials_path
            
            if os.path.exists(cred_path):
                cred = credentials.Certificate(cred_path)
                firebase_admin.initialize_app(cred)
            else:
                # For development without credentials
                print(f"Warning: Firebase credentials not found at {cred_path}")
                print("Using default credentials (may fail if not configured)")
                firebase_admin.initialize_app()
        
        self._db = firestore.client()
    
    @property
    def db(self):
        """Get Firestore client"""
        if self._db is None:
            self._initialize()
        return self._db
    
    # Collection references
    @property
    def users(self):
        """Users collection"""
        return self.db.collection('users')
    
    @property
    def rooms(self):
        """Rooms collection"""
        return self.db.collection('rooms')
    
    @property
    def games(self):
        """Games collection"""
        return self.db.collection('games')


# Singleton instance
firestore_client = FirestoreClient()
