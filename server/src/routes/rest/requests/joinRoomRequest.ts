import { SocketMetadata } from "./socketMetadata";

interface JoinRoomRequestData extends SocketMetadata {
  uid: string;
  roomCode: string | null;
}

export { JoinRoomRequestData };
