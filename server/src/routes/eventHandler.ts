import { Room } from "../application/models/room";
import { setupUser } from "../application/services/playerService";
import { createRoom, joinRoom } from "../application/services/roomService";
import { CreateRoomEvent, CreateRoomEventData } from "./events/createRoomEvent";
import { JoinRoomEvent, JoinRoomEventData } from "./events/joinRoomEvent";
import { PlayerEvent } from "./events/playerEvent";
import { RoomEvent } from "./events/roomEvent";
import { SetupUserEvent, SetupUserEventData } from "./events/setupUserEvent";

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

const onJoinRoomEvent = async (event: JoinRoomEvent) => {
  const socket = event.client;
  const data: JoinRoomEventData = event.data;
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
