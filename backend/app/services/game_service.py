from typing import Dict, List, Optional
from datetime import datetime
from app.database.firestore import firestore_client
from app.models.question import QuizQuestion
from app.services.quiz_service import quiz_service


class GameService:
    """Game logic service"""
    
    def __init__(self):
        self.db = firestore_client.db
        self.games_ref = firestore_client.games
        self.active_games: Dict[str, dict] = {}
    
    async def create_game(self, room_id: str, mode: str) -> dict:
        """Create a new game"""
        # Fetch questions
        questions = await quiz_service.fetch_questions(mode, count=10)
        
        game_id = f"game_{room_id}"
        game_data = {
            "game_id": game_id,
            "room_id": room_id,
            "questions": [q.model_dump() for q in questions],
            "current_question_index": 0,
            "player_answers": {},
            "final_scores": {},
            "winner": None,
            "created_at": datetime.utcnow().isoformat()
        }
        
        # Save to Firestore
        self.games_ref.document(game_id).set(game_data)
        
        # Store in memory for quick access
        self.active_games[game_id] = {
            **game_data,
            "questions": questions  # Keep as objects in memory
        }
        
        return game_data
    
    def get_current_question(self, game_id: str) -> Optional[QuizQuestion]:
        """Get current question for a game"""
        game = self.active_games.get(game_id)
        if not game:
            return None
        
        idx = game["current_question_index"]
        if idx >= len(game["questions"]):
            return None
        
        return game["questions"][idx]
    
    def submit_answer(
        self,
        game_id: str,
        player_id: str,
        question_id: str,
        answer_index: int,
        time_taken: float
    ) -> dict:
        """Submit an answer and calculate score"""
        game = self.active_games.get(game_id)
        if not game:
            raise ValueError("Game not found")
        
        question = self.get_current_question(game_id)
        if not question or question.id != question_id:
            raise ValueError("Invalid question")
        
        is_correct = question.is_correct(answer_index)
        
        # Calculate score based on time
        points = 0
        if is_correct:
            if time_taken <= 5:
                points = 100
            elif time_taken <= 10:
                points = 70
            else:
                points = 40
        
        # Store answer
        if game_id not in game["player_answers"]:
            game["player_answers"][game_id] = {}
        if player_id not in game["player_answers"][game_id]:
            game["player_answers"][game_id][player_id] = {}
        
        game["player_answers"][game_id][player_id][question_id] = {
            "answer": answer_index,
            "time_taken": time_taken,
            "is_correct": is_correct,
            "points": points
        }
        
        return {
            "is_correct": is_correct,
            "points": points,
            "correct_answer": question.correct_answer
        }
    
    def next_question(self, game_id: str) -> bool:
        """Move to next question. Returns True if more questions, False if game ended"""
        game = self.active_games.get(game_id)
        if not game:
            return False
        
        game["current_question_index"] += 1
        
        # Check if game ended
        if game["current_question_index"] >= len(game["questions"]):
            self._end_game(game_id)
            return False
        
        return True
    
    def _end_game(self, game_id: str):
        """End the game and calculate final scores"""
        game = self.active_games.get(game_id)
        if not game:
            return
        
        # Calculate final scores
        final_scores = {}
        for player_id, answers in game.get("player_answers", {}).get(game_id, {}).items():
            total_score = sum(a["points"] for a in answers.values())
            final_scores[player_id] = total_score
        
        # Find winner
        winner = max(final_scores, key=final_scores.get) if final_scores else None
        
        game["final_scores"] = final_scores
        game["winner"] = winner
        
        # Update Firestore
        self.games_ref.document(game_id).update({
            "final_scores": final_scores,
            "winner": winner
        })
    
    def get_scores(self, game_id: str) -> Dict[str, int]:
        """Get current scores for all players"""
        game = self.active_games.get(game_id)
        if not game:
            return {}
        
        scores = {}
        for player_id, answers in game.get("player_answers", {}).get(game_id, {}).items():
            scores[player_id] = sum(a["points"] for a in answers.values())
        
        return scores


# Singleton instance
game_service = GameService()
