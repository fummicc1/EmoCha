import { Socket } from "socket.io"
import { container } from "tsyringe"
import { maxPlayerCount, Room, RoomState } from "../models/room"
import { RoomRepository, RoomRepositoryImpl } from "../repositories/roomRepository"

const createRoom = (uid: string) => {
}

const getVacantRooms = async (): Promise<Room[]> => {
    const repository: RoomRepository = container.resolve(RoomRepositoryImpl);
    const rooms = await repository.getAllRoom();
    const vacant = rooms.filter((r) => r.state === 'Vacant');
    return vacant;
}

const joinRoom = async (socket: Socket, roomCode: string | null): Promise<void> => {

    const repository: RoomRepository = container.resolve(RoomRepositoryImpl);

    let room: Room;

    const vacants = await getVacantRooms();
    if (roomCode == null) {
        if (!vacants) {
            const roomName = 'Room'
            room = await repository.createRoom(roomName);
        } else {
            room = vacants[0];
        }    
    } else {
        room = await repository.getRoomWithCode(roomCode);
    }

    socket.join(room.id);

    room.players = [] // TODO: add player

    await repository.updateRoom(room);

    socket.broadcast.to(room.id);
}

const roomState = async (roomId: string): Promise<RoomState> => {
    const repository: RoomRepository = container.resolve(RoomRepositoryImpl);
    const room = await repository.getRoomWithId(roomId);
    const isFulfill = room.players.length == maxPlayerCount;
    return isFulfill ? 'Fulfill' : 'Vacant';
}

export { createRoom, joinRoom, roomState }