import { container } from "tsyringe";
import { Room } from "../application/models/room";
import { PlayerRepositoryImpl } from "../application/repositories/playerRepository";
import { setupUser } from "../application/services/playerService";
import { createRoom, joinRoom } from "../application/services/roomService";
import { PlayerEvent } from "./events/playerEvent";
import { RoomEvent } from "./events/roomEvent";
import { SetupUserEvent, SetupUserEventData } from "./events/setupUserEvent";
import { JoinRoomRequestData } from "./requests/joinRoomRequest";

const onSetupUserEvent = async (event: SetupUserEvent) => {
  const socket = event.client;
  const data: SetupUserEventData = event.data;
  const uid = data.uid;
  try {
    const user = await setupUser(uid);
    const sendEvent = new PlayerEvent(socket, user);
    socket.send(sendEvent.name, sendEvent.data);
  } catch (err) {
    console.error(err);
  }
};

const onJoinRoomEvent = async (data: JoinRoomRequestData) => {
  const playerRepository = container.resolve(PlayerRepositoryImpl);
  const socketId = data.socketId;
  const socket = playerRepository;
  const uid = data.uid;
  try {
    const room: Room = await joinRoom(socket, uid, data.roomCode);
    const sendEvent = new RoomEvent(socket, room);
    socket.to(room.id).emit(sendEvent.name, sendEvent.data);
  } catch (err) {
    console.error(err);
  }
};

const onCreateRoomEvent = async (event: CreateRoomEvent) => {
  const socket = event.client;
  const data: CreateRoomEventData = event.data;
  try {
    await createRoom(data.uid);
  } catch (err) {
    console.error(err);
  }
};

export { onSetupUserEvent, onCreateRoomEvent, onJoinRoomEvent };
