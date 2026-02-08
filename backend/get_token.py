import requests
import json

# Backend URL
BASE_URL = "http://localhost:8000"

def register_user():
    """Register a test user"""
    url = f"{BASE_URL}/api/auth/register"
    data = {
        "username": "testplayer",
        "email": "test@codequest.com",
        "password": "test123"
    }
    
    try:
        response = requests.post(url, json=data)
        if response.status_code == 201:
            result = response.json()
            print("✅ User registered successfully!")
            print(f"User ID: {result['user']['user_id']}")
            print(f"Username: {result['user']['username']}")
            print(f"Token: {result['access_token']}")
            return result
        else:
            print(f"❌ Registration failed: {response.text}")
            return None
    except Exception as e:
        print(f"❌ Error: {e}")
        return None

def login_user():
    """Login and get token"""
    url = f"{BASE_URL}/api/auth/login"
    data = {
        "email": "test@codequest.com",
        "password": "test123"
    }
    
    try:
        response = requests.post(url, json=data)
        if response.status_code == 200:
            result = response.json()
            print("✅ Login successful!")
            print(f"User ID: {result['user']['user_id']}")
            print(f"Username: {result['user']['username']}")
            print(f"Token: {result['access_token']}")
            print("\n📋 Copy this token for Flutter:")
            print(f"\nconst String TEST_TOKEN = '{result['access_token']}';\n")
            return result
        else:
            print(f"❌ Login failed: {response.text}")
            return None
    except Exception as e:
        print(f"❌ Error: {e}")
        return None

if __name__ == "__main__":
    print("🔐 CodeQuest Authentication Setup\n")
    
    # Try to register
    print("1️⃣ Attempting to register test user...")
    result = register_user()
    
    if result is None:
        # If registration fails (user might already exist), try login
        print("\n2️⃣ Registration failed, attempting login...")
        result = login_user()
    
    if result:
        print("\n✅ Authentication successful!")
        print(f"\n🎮 Use this token in your Flutter app:")
        print(f"Token: {result['access_token']}")
        print(f"User ID: {result['user']['user_id']}")
