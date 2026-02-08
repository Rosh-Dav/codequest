import asyncio
from app.main import sio
from app.services.room_service import room_service
from app.services.game_service import game_service
from app.utils.security import decode_access_token

# Store active connections
active_connections = {}


@sio.event
async def connect(sid, environ):
    """Handle client connection"""
    print(f"Client connected: {sid}")


@sio.event
async def disconnect(sid):
    """Handle client disconnection"""
    print(f"Client disconnected: {sid}")
    
    # Remove from active connections
    if sid in active_connections:
        room_code = active_connections[sid].get("room_code")
        player_id = active_connections[sid].get("player_id")
        
        if room_code and player_id:
            try:
                # Leave room
                await room_service.leave_room(room_code, player_id)
                # Notify others
                await sio.emit("player_left", {"player_id": player_id}, room=room_code)
            except Exception as e:
                print(f"Error handling disconnect: {e}")
        
        del active_connections[sid]


@sio.event
async def join_room(sid, data):
    """Handle player joining a room"""
    try:
        room_code = data.get("room_id")
        token = data.get("token")
        
        # Verify Firebase token
        try:
            from firebase_admin import auth as firebase_auth
            decoded_token = firebase_auth.verify_id_token(token)
            user_id = decoded_token['uid']
            username = decoded_token.get('name') or decoded_token.get('email', 'Player').split('@')[0]
        except Exception as e:
            print(f"Token verification failed: {e}")
            await sio.emit("error", {"message": f"Invalid token: {str(e)}"}, room=sid)
            return
        
        # Get room
        room = await room_service.get_room(room_code)
        if not room:
            await sio.emit("error", {"message": "Room not found"}, room=sid)
            return
        
        # Join Socket.IO room
        sio.enter_room(sid, room_code)
        
        # Store connection
        active_connections[sid] = {
            "room_code": room_code,
            "player_id": user_id,
            "username": username
        }
        
        # Find player in room
        player = next((p for p in room.players if p.id == user_id), None)
        
        if player:
            # Notify others
            await sio.emit(
                "player_joined",
                {"player": player.model_dump()},
                room=room_code,
                skip_sid=sid
            )
        
        await sio.emit("join_success", {"room": room.model_dump()}, room=sid)
        
    except Exception as e:
        print(f"Error in join_room: {e}")
        await sio.emit("error", {"message": str(e)}, room=sid)


@sio.event
async def leave_room(sid, data):
    """Handle player leaving a room"""
    try:
        if sid not in active_connections:
            return
        
        room_code = active_connections[sid].get("room_code")
        player_id = active_connections[sid].get("player_id")
        
        if room_code and player_id:
            # Leave room
            await room_service.leave_room(room_code, player_id)
            
            # Leave Socket.IO room
            sio.leave_room(sid, room_code)
            
            # Notify others
            await sio.emit("player_left", {"player_id": player_id}, room=room_code)
            
            del active_connections[sid]
        
    except Exception as e:
        print(f"Error in leave_room: {e}")


@sio.event
async def submit_answer(sid, data):
    """Handle answer submission"""
    try:
        game_id = data.get("game_id")
        question_id = data.get("question_id")
        answer_index = data.get("answer")
        time_taken = data.get("time_taken", 15.0)
        
        if sid not in active_connections:
            return
        
        player_id = active_connections[sid].get("player_id")
        room_code = active_connections[sid].get("room_code")
        
        # Submit answer
        result = game_service.submit_answer(
            game_id=game_id,
            player_id=player_id,
            question_id=question_id,
            answer_index=answer_index,
            time_taken=time_taken
        )
        
        # Notify player
        await sio.emit("answer_result", result, room=sid)
        
        # Notify room
        await sio.emit(
            "answer_received",
            {
                "player_id": player_id,
                "is_correct": result["is_correct"]
            },
            room=room_code
        )
        
        # Update scores
        scores = game_service.get_scores(game_id)
        await sio.emit("score_update", {"scores": scores}, room=room_code)
        
    except Exception as e:
        print(f"Error in submit_answer: {e}")
        await sio.emit("error", {"message": str(e)}, room=sid)


async def start_game_flow(room_code: str, game_id: str):
    """Start the game flow with questions and timers"""
    try:
        # Notify game started
        await sio.emit("game_started", {"game_id": game_id, "total_questions": 10}, room=room_code)
        
        # Send questions one by one
        for i in range(10):
            question = game_service.get_current_question(game_id)
            if not question:
                break
            
            # Send question (without correct answer)
            question_data = question.model_dump()
            del question_data["correct_answer"]  # Don't send correct answer to clients
            
            await sio.emit(
                "question_sent",
                {
                    "question_index": i,
                    "question": question_data,
                    "time_limit": 15
                },
                room=room_code
            )
            
            # Timer countdown
            for remaining in range(15, 0, -1):
                await asyncio.sleep(1)
                await sio.emit("timer_update", {"time_remaining": remaining}, room=room_code)
            
            # Move to next question
            has_more = game_service.next_question(game_id)
            if not has_more:
                break
            
            # Brief pause between questions
            await asyncio.sleep(2)
        
        # Game finished
        scores = game_service.get_scores(game_id)
        winner = max(scores, key=scores.get) if scores else None
        
        await sio.emit(
            "game_finished",
            {
                "final_scores": scores,
                "winner": winner
            },
            room=room_code
        )
        
    except Exception as e:
        print(f"Error in game flow: {e}")
