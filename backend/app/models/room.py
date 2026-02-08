from typing import List, Optional
from pydantic import BaseModel, Field
from datetime import datetime


class Player(BaseModel):
    """Player model"""
    id: str
    name: str
    score: int = 0
    is_ready: bool = False
    is_host: bool = False


class Room(BaseModel):
    """Room model"""
    id: str = Field(..., description="6-character room code")
    host_id: str
    mode: str = Field(..., description="easy, medium, or hard")
    status: str = Field(default="waiting", description="waiting, active, or finished")
    players: List[Player] = []
    max_players: int = 6
    created_at: datetime = Field(default_factory=datetime.utcnow)
    started_at: Optional[datetime] = None
    finished_at: Optional[datetime] = None
    
    @property
    def can_start(self) -> bool:
        """Check if game can start"""
        return len(self.players) >= 2 and self.status == "waiting"
    
    class Config:
        json_schema_extra = {
            "example": {
                "id": "A9F3X2",
                "host_id": "user123",
                "mode": "medium",
                "status": "waiting",
                "players": [],
                "max_players": 6
            }
        }
