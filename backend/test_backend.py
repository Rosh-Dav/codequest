"""
Simple test script to verify backend is working
Run this from the backend directory: python test_backend.py
"""
import requests

BASE_URL = "http://localhost:8000"

def test_health():
    """Test health endpoint"""
    try:
        response = requests.get(f"{BASE_URL}/health")
        if response.status_code == 200:
            print("✅ Backend is running!")
            print(f"   Response: {response.json()}")
            return True
        else:
            print(f"❌ Health check failed: {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Cannot connect to backend: {e}")
        print("\n💡 Make sure backend is running:")
        print("   cd backend")
        print("   uvicorn app.main:socket_app --reload")
        return False

def test_quiz():
    """Test quiz endpoint"""
    try:
        response = requests.get(f"{BASE_URL}/api/quiz/questions?mode=easy&count=5")
        if response.status_code == 200:
            questions = response.json()
            print(f"\n✅ Quiz API working!")
            print(f"   Got {len(questions)} questions")
            if questions:
                print(f"   Sample: {questions[0]['question'][:50]}...")
            return True
        else:
            print(f"\n❌ Quiz API failed: {response.status_code}")
            return False
    except Exception as e:
        print(f"\n❌ Quiz API error: {e}")
        return False

if __name__ == "__main__":
    print("🔍 Testing CodeQuest Backend\n")
    print("=" * 50)
    
    if test_health():
        test_quiz()
    
    print("\n" + "=" * 50)
    print("\n📝 Next steps:")
    print("1. If backend is running, hot restart Flutter (press R)")
    print("2. Navigate to Quest mode")
    print("3. Click CREATE ROOM")
    print("\n💡 Backend must be running from 'backend/' directory!")
