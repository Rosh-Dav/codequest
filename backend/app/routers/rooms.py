from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from app.models.room import Room
from app.models.user import User
from app.services.room_service import room_service
from app.routers.auth import get_current_user

router = APIRouter()


class CreateRoomRequest(BaseModel):
    """Create room request"""
    mode: str
    max_players: int = 6


class JoinRoomRequest(BaseModel):
    """Join room request"""
    room_code: str


@router.post("/create", response_model=Room, status_code=status.HTTP_201_CREATED)
async def create_room(
    request: CreateRoomRequest,
    current_user: User = Depends(get_current_user)
):
    """Create a new game room"""
    try:
        room = await room_service.create_room(
            host_id=current_user.user_id,
            host_name=current_user.username,
            mode=request.mode,
            max_players=request.max_players
        )
        return room
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/{room_code}/join", response_model=Room)
async def join_room(
    room_code: str,
    current_user: User = Depends(get_current_user)
):
    """Join an existing room"""
    try:
        room = await room_service.join_room(
            room_code=room_code,
            player_id=current_user.user_id,
            player_name=current_user.username
        )
        return room
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/{room_code}/leave")
async def leave_room(
    room_code: str,
    current_user: User = Depends(get_current_user)
):
    """Leave a room"""
    try:
        room = await room_service.leave_room(room_code, current_user.user_id)
        return {"message": "Left room successfully", "room": room}
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/{room_code}/start", response_model=dict)
async def start_game(
    room_code: str,
    current_user: User = Depends(get_current_user)
):
    """Start the game (host only)"""
    try:
        room = await room_service.start_game(room_code, current_user.user_id)
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


@router.get("/{room_code}", response_model=Room)
async def get_room(
    room_code: str,
    current_user: User = Depends(get_current_user)
):
    """Get room details"""
    room = await room_service.get_room(room_code)
    
    if room is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Room not found"
        )
    
    return room
