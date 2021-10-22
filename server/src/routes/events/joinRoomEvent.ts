import { Socket } from "socket.io";
import { Event } from "../event";

interface JoinRoomEventData {
  uid: string;
  roomCode: string | null;
}

class JoinRoomEvent implements Event<JoinRoomEventData> {
  name: string = "join-room";
  client: Socket;
  data: JoinRoomEventData;
  constructor(client: Socket, data: JoinRoomEventData) {
    this.client = client;
    this.data = data;
  }
}

export { JoinRoomEvent, JoinRoomEventData };
