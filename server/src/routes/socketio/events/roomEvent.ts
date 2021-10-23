import { Socket } from "socket.io";
import { Room } from "../../../application/models/room";
import { Event } from "../event";

class RoomEvent implements Event<Room> {
  name: string = "room";
  client: Socket;
  data: Room;
  constructor(client: Socket, data: Room) {
    this.client = client;
    this.data = data;
  }
}

export { RoomEvent };
