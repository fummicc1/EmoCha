import { SocketMetadata } from "./socketMetadata";

interface JoinRoomRequestData extends SocketMetadata {
  roomCode: string | null;
}

export { JoinRoomRequestData };
