import random
import string
from typing import List, Optional
from datetime import datetime
from app.database.firestore import firestore_client
from app.models.room import Room, Player


class RoomService:
    """Room management service"""
    
    def __init__(self):
        self.db = firestore_client.db
        self.rooms_ref = firestore_client.rooms
    
    def _generate_room_code(self) -> str:
        """Generate a unique 6-character room code"""
        while True:
            code = ''.join(random.choices(string.ascii_uppercase + string.digits, k=6))
            # Check if code already exists
            existing = self.rooms_ref.document(code).get()
            if not existing.exists:
                return code
    
    async def create_room(
        self,
        host_id: str,
        host_name: str,
        mode: str,
        max_players: int = 6
    ) -> Room:
        """Create a new game room"""
        room_code = self._generate_room_code()
        
        host_player = Player(
            id=host_id,
            name=host_name,
            score=0,
            is_ready=False,
            is_host=True
        )
        
        room = Room(
            id=room_code,
            host_id=host_id,
            mode=mode,
            status="waiting",
            players=[host_player],
            max_players=max_players,
            created_at=datetime.utcnow()
        )
        
        # Save to Firestore
        room_dict = room.model_dump(mode='json')
        room_dict['created_at'] = room.created_at.isoformat()
        self.rooms_ref.document(room_code).set(room_dict)
        
        return room
    
    async def get_room(self, room_code: str) -> Optional[Room]:
        """Get room by code"""
        room_ref = self.rooms_ref.document(room_code)
        room_doc = room_ref.get()
        
        if not room_doc.exists:
            return None
        
        room_data = room_doc.to_dict()
        # Convert datetime strings back to datetime objects
        room_data['created_at'] = datetime.fromisoformat(room_data['created_at'])
        if room_data.get('started_at'):
            room_data['started_at'] = datetime.fromisoformat(room_data['started_at'])
        if room_data.get('finished_at'):
            room_data['finished_at'] = datetime.fromisoformat(room_data['finished_at'])
        
        return Room(**room_data)
    
    async def join_room(
        self,
        room_code: str,
        player_id: str,
        player_name: str
    ) -> Room:
        """Join an existing room"""
        room = await self.get_room(room_code)
        
        if room is None:
            raise ValueError("Room not found")
        
        if room.status != "waiting":
            raise ValueError("Room is not accepting players")
        
        if len(room.players) >= room.max_players:
            raise ValueError("Room is full")
        
        # Check if player already in room
        if any(p.id == player_id for p in room.players):
            raise ValueError("Player already in room")
        
        # Add player
        new_player = Player(
            id=player_id,
            name=player_name,
            score=0,
            is_ready=False,
            is_host=False
        )
        room.players.append(new_player)
        
        # Update Firestore
        room_dict = room.model_dump(mode='json')
        room_dict['created_at'] = room.created_at.isoformat()
        self.rooms_ref.document(room_code).update({"players": room_dict['players']})
        
        return room
    
    async def leave_room(self, room_code: str, player_id: str) -> Optional[Room]:
        """Leave a room"""
        room = await self.get_room(room_code)
        
        if room is None:
            raise ValueError("Room not found")
        
        # Remove player
        room.players = [p for p in room.players if p.id != player_id]
        
        # If room is empty, delete it
        if len(room.players) == 0:
            self.rooms_ref.document(room_code).delete()
            return None
        
        # If host left, assign new host
        if not any(p.is_host for p in room.players):
            room.players[0].is_host = True
            room.host_id = room.players[0].id
        
        # Update Firestore
        room_dict = room.model_dump(mode='json')
        room_dict['created_at'] = room.created_at.isoformat()
        self.rooms_ref.document(room_code).set(room_dict)
        
        return room
    
    async def start_game(self, room_code: str, host_id: str) -> Room:
        """Start the game (host only)"""
        room = await self.get_room(room_code)
        
        if room is None:
            raise ValueError("Room not found")
        
        if room.host_id != host_id:
            raise ValueError("Only the host can start the game")
        
        if not room.can_start:
            raise ValueError("Cannot start game (need at least 2 players)")
        
        room.status = "active"
        room.started_at = datetime.utcnow()
        
        # Update Firestore
        room_dict = room.model_dump(mode='json')
        room_dict['created_at'] = room.created_at.isoformat()
        room_dict['started_at'] = room.started_at.isoformat()
        self.rooms_ref.document(room_code).update({
            "status": "active",
            "started_at": room_dict['started_at']
        })
        
        return room


# Singleton instance
room_service = RoomService()
