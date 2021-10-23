import { Socket } from "socket.io";
import { container } from "tsyringe";
import { Room } from "../models/room";
import { PlayerRepositoryImpl } from "../repositories/playerRepository";
import {
  RoomRepository,
  RoomRepositoryImpl,
} from "../repositories/roomRepository";

const createRoom = async (uid: string): Promise<Room> => {
  const repository: RoomRepository = container.resolve(RoomRepositoryImpl);
  const room = await repository.createRoom("Room");
  const playerRepository = container.resolve(PlayerRepositoryImpl);
  const player = await playerRepository.findWithUid(uid);
  room.players.push(player);
  await repository.updateRoom(room);
  return room;
};

const getVacantRooms = async (): Promise<Room[]> => {
  const repository: RoomRepository = container.resolve(RoomRepositoryImpl);
  const rooms = await repository.getAllRoom();
  const vacant = rooms.filter((r) => r.state === "Vacant");
  return vacant;
};

const joinRoom = async (
  socket: Socket,
  newcomer: string,
  roomCode: string | null
): Promise<Room> => {
  const repository: RoomRepository = container.resolve(RoomRepositoryImpl);
  let room: Room;
  const vacants = await getVacantRooms();
  if (!vacants || vacants.length == 0) {
    throw new Error("No vacants");
  }
  console.log("vacants", vacants);
  if (roomCode == null) {
    room = vacants[0];
  } else {
    room = await repository.getRoomWithCode(roomCode);
  }
  console.log("room", room);
  socket.join(room.id);
  const playerRepository = container.resolve(PlayerRepositoryImpl);
  const player = await playerRepository.findWithUid(newcomer);
  room.players = [player];
  await repository.updateRoom(room);
  return room;
};

const getRoomWithId = async (roomId: string): Promise<Room> => {
  const repository: RoomRepository = container.resolve(RoomRepositoryImpl);
  const room = await repository.getRoomWithId(roomId);
  return room;
};

const getRoomWithUid = async (uid: string): Promise<Room> => {
  const repository: RoomRepository = container.resolve(RoomRepositoryImpl);
  const allRoom = await repository.getAllRoom();
  const room = allRoom.find(
    (r) => r.players.findIndex((p) => p.id === uid) != -1
  );
  if (!room) {
    throw new Error();
  }
  return room;
};

export { createRoom, joinRoom, getRoomWithId, getRoomWithUid };
