from fastapi import APIRouter, HTTPException, status
from pydantic import BaseModel
from app.models.room import Room
from app.services.room_service import room_service

router = APIRouter()


class CreateRoomRequest(BaseModel):
    """Create room request"""
    mode: str
    max_players: int = 6
    username: str = "TestPlayer"  # For testing without auth


class JoinRoomRequest(BaseModel):
    """Join room request"""
    room_code: str
    username: str = "TestPlayer"  # For testing without auth


@router.post("/create", response_model=Room, status_code=status.HTTP_201_CREATED)
async def create_room_test(request: CreateRoomRequest):
    """Create a new game room (TEST - NO AUTH)"""
    try:
        # Generate a test user ID
        import time
        user_id = f"test_user_{int(time.time() * 1000)}"
        
        room = await room_service.create_room(
            host_id=user_id,
            host_name=request.username,
            mode=request.mode,
            max_players=request.max_players
        )
        return room
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/join", response_model=Room)
async def join_room_test(request: JoinRoomRequest):
    """Join an existing room (TEST - NO AUTH)"""
    try:
        # Generate a test user ID
        import time
        user_id = f"test_user_{int(time.time() * 1000)}"
        
        room = await room_service.join_room(
            room_code=request.room_code,
            player_id=user_id,
            player_name=request.username
        )
        return room
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/leave")
async def leave_room_test(room_code: str, user_id: str):
    """Leave a room (TEST - NO AUTH)"""
    try:
        room = await room_service.leave_room(room_code, user_id)
        return {"message": "Left room successfully", "room": room}
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/start", response_model=dict)
async def start_game_test(room_code: str, user_id: str):
    """Start the game (TEST - NO AUTH)"""
    try:
        room = await room_service.start_game(room_code, user_id)
        return {
            "message": "Game started",
            "room": room,
            "game_id": f"game_{room_code}"
        }
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
