import httpx
from typing import List
from app.models.question import QuizQuestion
from app.config import settings


class QuizService:
    """Quiz question service"""
    
    def __init__(self):
        self.api_url = settings.quiz_api_url
        self.cache = {}
    
    async def fetch_questions(
        self,
        mode: str,
        count: int = 10
    ) -> List[QuizQuestion]:
        """Fetch quiz questions from OpenTDB API"""
        
        # Map difficulty
        difficulty_map = {
            "easy": "easy",
            "medium": "medium",
            "hard": "hard"
        }
        difficulty = difficulty_map.get(mode, "medium")
        
        # Check cache
        cache_key = f"{difficulty}_{count}"
        if cache_key in self.cache:
            return self.cache[cache_key]
        
        try:
            async with httpx.AsyncClient() as client:
                response = await client.get(
                    self.api_url,
                    params={
                        "amount": count,
                        "difficulty": difficulty,
                        "type": "multiple",
                        "category": 18  # Computer Science category
                    },
                    timeout=10.0
                )
                response.raise_for_status()
                data = response.json()
            
            if data.get("response_code") != 0:
                # Fallback to default questions
                return self._get_fallback_questions(mode, count)
            
            questions = []
            for idx, item in enumerate(data.get("results", [])):
                # Combine correct and incorrect answers
                options = item["incorrect_answers"] + [item["correct_answer"]]
                # Shuffle would happen here, but for consistency we'll keep order
                # In production, shuffle on client side or here
                
                question = QuizQuestion(
                    id=f"q{idx + 1}",
                    question=item["question"],
                    options=options,
                    correct_answer=len(options) - 1,  # Last item is correct
                    difficulty=difficulty,
                    category=item.get("category", "Computer Science")
                )
                questions.append(question)
            
            # Cache the questions
            self.cache[cache_key] = questions
            return questions
            
        except Exception as e:
            print(f"Error fetching questions: {e}")
            return self._get_fallback_questions(mode, count)
    
    def _get_fallback_questions(self, mode: str, count: int) -> List[QuizQuestion]:
        """Fallback questions if API fails"""
        fallback = [
            QuizQuestion(
                id="q1",
                question="What is the output of print(2 ** 3) in Python?",
                options=["6", "8", "9", "12"],
                correct_answer=1,
                difficulty=mode,
                category="Python"
            ),
            QuizQuestion(
                id="q2",
                question="Which data structure uses LIFO (Last In First Out)?",
                options=["Queue", "Stack", "Array", "Tree"],
                correct_answer=1,
                difficulty=mode,
                category="Data Structures"
            ),
            QuizQuestion(
                id="q3",
                question="What does HTML stand for?",
                options=[
                    "Hyper Text Markup Language",
                    "High Tech Modern Language",
                    "Home Tool Markup Language",
                    "Hyperlinks and Text Markup Language"
                ],
                correct_answer=0,
                difficulty=mode,
                category="Web Development"
            ),
            QuizQuestion(
                id="q4",
                question="Which sorting algorithm has O(n log n) average time complexity?",
                options=["Bubble Sort", "Selection Sort", "Merge Sort", "Insertion Sort"],
                correct_answer=2,
                difficulty=mode,
                category="Algorithms"
            ),
            QuizQuestion(
                id="q5",
                question="What is the default port for HTTP?",
                options=["21", "22", "80", "443"],
                correct_answer=2,
                difficulty=mode,
                category="Networking"
            ),
            QuizQuestion(
                id="q6",
                question="In object-oriented programming, what is encapsulation?",
                options=[
                    "Hiding implementation details",
                    "Creating multiple instances",
                    "Inheriting from parent class",
                    "Overriding methods"
                ],
                correct_answer=0,
                difficulty=mode,
                category="OOP"
            ),
            QuizQuestion(
                id="q7",
                question="Which of these is NOT a JavaScript framework?",
                options=["React", "Vue", "Angular", "Django"],
                correct_answer=3,
                difficulty=mode,
                category="Web Development"
            ),
            QuizQuestion(
                id="q8",
                question="What does SQL stand for?",
                options=[
                    "Structured Query Language",
                    "Simple Question Language",
                    "Standard Query Logic",
                    "System Query Language"
                ],
                correct_answer=0,
                difficulty=mode,
                category="Databases"
            ),
            QuizQuestion(
                id="q9",
                question="Which of these is a NoSQL database?",
                options=["MySQL", "PostgreSQL", "MongoDB", "Oracle"],
                correct_answer=2,
                difficulty=mode,
                category="Databases"
            ),
            QuizQuestion(
                id="q10",
                question="What is the time complexity of binary search?",
                options=["O(1)", "O(log n)", "O(n)", "O(n log n)"],
                correct_answer=1,
                difficulty=mode,
                category="Algorithms"
            ),
        ]
        
        return fallback[:count]


# Singleton instance
quiz_service = QuizService()
