import { SocketMetadata } from "./socketMetadata";

interface CreateRoomRequestData extends SocketMetadata {
  uid: string;
}

export { CreateRoomRequestData };
