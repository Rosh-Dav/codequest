# CodeQuest Multiplayer Backend

Real-time multiplayer quiz game backend built with FastAPI, Firestore, and Socket.IO.

## Features

- 🔐 JWT Authentication
- 🎮 Real-time multiplayer rooms (2-6 players)
- ❓ Dynamic quiz questions with difficulty levels
- ⚡ WebSocket-based real-time communication
- 🏆 Time-based scoring system
- 📊 Game history and player stats

## Tech Stack

- **Framework**: FastAPI
- **Database**: Firebase Firestore
- **Real-time**: Socket.IO
- **Authentication**: JWT tokens
- **Language**: Python 3.10+

## Setup

### 1. Install Dependencies

```bash
cd backend
python -m venv venv
venv\Scripts\activate  # Windows
# or
source venv/bin/activate  # Linux/Mac

pip install -r requirements.txt
```

### 2. Configure Environment

Copy `.env.example` to `.env` and update values:

```bash
copy .env.example .env  # Windows
# or
cp .env.example .env  # Linux/Mac
```

Update `.env` with your configuration:
- Set `JWT_SECRET_KEY` to a secure random string
- Add Firebase credentials path

### 3. Firebase Setup

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select existing
3. Go to Project Settings → Service Accounts
4. Click "Generate New Private Key"
5. Save as `serviceAccountKey.json` in the `backend` directory

### 4. Run the Server

```bash
uvicorn app.main:socket_app --reload --host 0.0.0.0 --port 8000
```

The API will be available at `http://localhost:8000`

## API Documentation

Once running, visit:
- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

## Project Structure

```
backend/
├── app/
│   ├── main.py              # FastAPI app + Socket.IO
│   ├── config.py            # Configuration
│   ├── models/              # Pydantic models
│   ├── routers/             # API endpoints
│   ├── services/            # Business logic
│   ├── database/            # Firestore client
│   ├── sockets/             # Socket.IO handlers
│   └── utils/               # Utilities
├── tests/                   # Unit tests
├── requirements.txt         # Dependencies
├── .env.example            # Environment template
└── README.md               # This file
```

## API Endpoints

### Health Check
- `GET /` - Basic health check
- `GET /health` - Detailed health status

### Authentication (Coming Soon)
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `GET /api/auth/me` - Get current user

### Rooms (Coming Soon)
- `POST /api/rooms/create` - Create room
- `POST /api/rooms/{code}/join` - Join room
- `POST /api/rooms/{code}/leave` - Leave room
- `POST /api/rooms/{code}/start` - Start game
- `GET /api/rooms/{code}` - Get room details

### Quiz (Coming Soon)
- `GET /api/quiz/questions` - Fetch questions

## Socket.IO Events

### Client → Server
- `join_room` - Join a game room
- `leave_room` - Leave a game room
- `submit_answer` - Submit quiz answer

### Server → Client
- `player_joined` - Player joined room
- `player_left` - Player left room
- `game_started` - Game has started
- `question_sent` - New question
- `timer_update` - Timer countdown
- `answer_received` - Answer submitted
- `score_update` - Scores updated
- `game_finished` - Game ended

## Development

### Run Tests
```bash
pytest
```

### Code Style
```bash
black app/
flake8 app/
```

## Deployment

### Docker
```bash
docker build -t codequest-backend .
docker run -p 8000:8000 codequest-backend
```

### Cloud Run / Railway
See deployment guide in `docs/deployment.md`

## License

MIT
