from typing import Dict, Optional
from pydantic import BaseModel
from enum import Enum


class GameStatus(str, Enum):
    """Game status enum"""
    WAITING = "waiting"
    STARTING = "starting"
    IN_PROGRESS = "inProgress"
    QUESTION_TRANSITION = "questionTransition"
    ENDED = "ended"


class GameState(BaseModel):
    """Game state model"""
    status: GameStatus = GameStatus.WAITING
    current_question_index: int = 0
    total_questions: int = 10
    time_remaining: int = 15
    player_scores: Dict[str, int] = {}
    has_answered: bool = False
    selected_answer: Optional[int] = None
    
    @property
    def is_active(self) -> bool:
        """Check if game is active"""
        return self.status == GameStatus.IN_PROGRESS
    
    @property
    def is_ended(self) -> bool:
        """Check if game has ended"""
        return self.status == GameStatus.ENDED
    
    @property
    def can_answer(self) -> bool:
        """Check if player can answer"""
        return self.is_active and not self.has_answered and self.time_remaining > 0
