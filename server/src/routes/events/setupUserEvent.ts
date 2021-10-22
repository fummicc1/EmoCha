import { Socket } from "socket.io";
import { Event } from "../event";

interface SetupUserEventData {
  uid: string | null;
}

class SetupUserEvent implements Event<SetupUserEventData> {
  name: string = "setup-user";
  client: Socket;
  data: SetupUserEventData;
  constructor(client: Socket, data: SetupUserEventData) {
    this.client = client;
    this.data = data;
  }
}

export { SetupUserEvent, SetupUserEventData };
