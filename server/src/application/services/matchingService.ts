import { container } from "tsyringe"
import { maxPlayerCount, RoomState } from "../models/room"
import { RoomRepository, RoomRepositoryImpl } from "../repositories/roomRepository"

const createRoom = (uid: string) => {
}

const joinRoom = (roomId: string, userId: string) => {
}

const roomState = async (roomId: string): Promise<RoomState> => {
    const repository: RoomRepository = container.resolve(RoomRepositoryImpl);
    const room = await repository.getRoom(roomId);
    const isFulfill = room.players.length == maxPlayerCount;
    return isFulfill ? 'Fulfill' : 'Vacant';
}

export { createRoom, joinRoom, roomState }