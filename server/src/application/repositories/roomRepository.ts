import { v4 } from 'uuid';

interface RoomRepository {
    createRoom(name: string): Promise<void>;
    updateRoom(id: string): Promise<void>;
    getRoom(id: string): Promise<Room>;
    deleteRoom(id: string): Promise<void>;
}

class RoomRepositoryImpl implements RoomRepository {

    rooms: Room[] = []

    async createRoom(name: string): Promise<void> {
        const room: Room = {
            id: v4(),
            name: name,
            players: [],
            chat: {
                id: v4(),
                messages: []
            }
        };
        this.rooms.push(room);
    }
    async updateRoom(id: string): Promise<void> {

    }
    async getRoom(id: string): Promise<Room> {
        const room = this.rooms.find((r) => r.id === id);
        if (!room) {
            throw new Error();
        }
        return room;
    }
    async deleteRoom(id: string): Promise<void> {

    }
}

export { RoomRepository, RoomRepositoryImpl }