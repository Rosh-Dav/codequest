from typing import List
from pydantic import BaseModel, Field


class QuizQuestion(BaseModel):
    """Quiz question model"""
    id: str
    question: str
    options: List[str] = Field(..., min_length=2, max_length=6)
    correct_answer: int = Field(..., ge=0)
    difficulty: str
    category: str
    
    def is_correct(self, answer_index: int) -> bool:
        """Check if answer is correct"""
        return answer_index == self.correct_answer
    
    class Config:
        json_schema_extra = {
            "example": {
                "id": "q1",
                "question": "What is the output of print(2 ** 3)?",
                "options": ["6", "8", "9", "12"],
                "correct_answer": 1,
                "difficulty": "medium",
                "category": "Python"
            }
        }
