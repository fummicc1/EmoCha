import { injectable, singleton } from "tsyringe";
import { v4 } from "uuid";
import { generateRandomId } from "../../utils/randomId";
import { Room } from "../models/room";

interface RoomRepository {
  createRoom(name: string): Promise<Room>;
  updateRoom(room: Room): Promise<void>;
  getAllRoom(): Promise<Room[]>;
  getRoomWithId(id: string): Promise<Room>;
  getRoomWithCode(code: string): Promise<Room>;
  deleteRoom(id: string): Promise<void>;
}

@singleton()
class RoomRepositoryImpl implements RoomRepository {
  rooms: Room[] = [];

  async createRoom(name: string): Promise<Room> {
    const room: Room = {
      id: v4(),
      name: name,
      code: generateRandomId(6),
      players: [],
      chat: {
        id: v4(),
        messages: [],
      },
      state: "Vacant",
    };
    this.rooms.push(room);
    return room;
  }
  async updateRoom(room: Room): Promise<void> {}

  async getAllRoom(): Promise<Room[]> {
    return this.rooms;
  }

  async getRoomWithId(id: string): Promise<Room> {
    const room = this.rooms.find((r) => r.id === id);
    if (!room) {
      throw new Error();
    }
    return room;
  }
  async getRoomWithCode(code: string): Promise<Room> {
    const room = this.rooms.find((r) => r.code === code);
    if (!room) {
      throw new Error();
    }
    return room;
  }
  async deleteRoom(id: string): Promise<void> {}
}

export { RoomRepository, RoomRepositoryImpl };
