import { Socket } from "socket.io";
import { Event } from "../event";

interface CreateRoomEventData {
  uid: string;
}

class CreateRoomEvent implements Event<CreateRoomEventData> {
  name: string = "create-room";
  client: Socket;
  data: CreateRoomEventData;
  constructor(client: Socket, data: CreateRoomEventData) {
    this.client = client;
    this.data = data;
  }
}

export { CreateRoomEvent, CreateRoomEventData };
