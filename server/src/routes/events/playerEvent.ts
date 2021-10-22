import { Socket } from "socket.io";
import { Player } from "../../application/models/player";
import { Event } from "../event";

class PlayerEvent implements Event<Player> {
  name: string = "room";
  client: Socket;
  data: Player;
  constructor(client: Socket, data: Player) {
    this.client = client;
    this.data = data;
  }
}

export { PlayerEvent };
