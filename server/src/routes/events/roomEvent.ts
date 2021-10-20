import { Socket } from "socket.io";
import { Room } from "../../application/models/room";
import { Event } from "../event";

interface RoomEvent extends Event<Room> { 
    client: Socket
}

export { RoomEvent }