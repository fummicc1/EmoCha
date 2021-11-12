import { container } from "tsyringe";
import { Room } from "../../application/models/room";
import { PlayerRepositoryImpl } from "../../application/repositories/playerRepository";
import { setupUser } from "../../application/services/playerService";
import { createRoom, joinRoom } from "../../application/services/roomService";
import { RoomEvent } from "../socketio/events/roomEvent";
import { JoinRoomRequestData } from "./requests/joinRoomRequest";
import { CreateRoomRequestData } from "./requests/createRoomRequest";
import { SetupUserRequestData } from "./requests/setupUserRequest";
import { PlayerEvent } from "../socketio/events/playerEvent";

const onSetupUserRequest = async (data: SetupUserRequestData) => {
  const socketId = data.socketId;
  const uid = data.uid;
  try {
    const user = await setupUser(uid, socketId);
    const socket = data.allSockets.get(socketId);
    if (socket == null) {
      return;
    }
    const event = new PlayerEvent(socket, user);
    socket?.emit(event.name, event.data);
  } catch (err) {
    console.error(err);
  }
};

const onJoinRoomRequest = async (data: JoinRoomRequestData) => {
  const socketId = data.socketId;
  const socket = data.allSockets.get(socketId);
  if (!socket) return;
  const uid = data.uid;
  try {
    const room: Room = await joinRoom(socket, uid, data.roomCode);
    const sendEvent = new RoomEvent(socket, room);
    socket.to(room.id).emit(sendEvent.name, sendEvent.data);
  } catch (err) {
    console.error(err);
  }
};

const onCreateRoomRequest = async (data: CreateRoomRequestData) => {
  const socketId = data.socketId;
  const socket = data.allSockets.get(socketId);
  if (!socket) return;
  try {
    const room = await createRoom(data.uid);
    const sendEvent = new RoomEvent(socket, room);
    socket.to(room.id).emit(sendEvent.name, sendEvent.data);
  } catch (err) {
    console.error(err);
  }
};

export { onSetupUserRequest, onCreateRoomRequest, onJoinRoomRequest };
