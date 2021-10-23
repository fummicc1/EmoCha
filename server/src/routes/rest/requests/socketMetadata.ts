import { Socket } from "socket.io";

export interface SocketMetadata {
  socketId: string;
  allSockets: Map<string, Socket>;
}
