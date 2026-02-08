from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import socketio
from app.config import settings

# Create FastAPI app
app = FastAPI(
    title="CodeQuest Multiplayer API",
    description="Real-time multiplayer quiz game backend",
    version="1.0.0",
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Create Socket.IO server
sio = socketio.AsyncServer(
    async_mode="asgi",
    cors_allowed_origins=settings.cors_origins,
)

# Wrap with ASGI app
socket_app = socketio.ASGIApp(sio, app)


@app.get("/")
async def root():
    """Health check endpoint"""
    return {
        "status": "online",
        "service": "CodeQuest Multiplayer API",
        "version": "1.0.0"
    }


@app.get("/health")
async def health_check():
    """Detailed health check"""
    return {
        "status": "healthy",
        "environment": settings.environment,
        "features": {
            "authentication": True,
            "rooms": True,
            "quiz": True,
            "realtime": True
        }
    }


# Import routers
from app.routers import auth, rooms, rooms_test
app.include_router(auth.router, prefix="/api/auth", tags=["auth"])
app.include_router(rooms.router, prefix="/api/rooms", tags=["rooms"])
app.include_router(rooms_test.router, prefix="/api/test/rooms", tags=["test-rooms"])

# Quiz router will be added in next phase
# from app.routers import quiz
# app.include_router(quiz.router, prefix="/api/quiz", tags=["quiz"])

# Import socket handlers
from app.sockets import game_events
