import { Socket } from "socket.io";
import { Event } from '../event';

interface JoinRoomEventData {
    uid: string;
    roomName: string
}

interface JoinRoomEvent extends Event<JoinRoomEventData> {
    client: Socket
}

export { JoinRoomEvent, JoinRoomEventData };