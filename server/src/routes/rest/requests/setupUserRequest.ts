import { SocketMetadata } from "./socketMetadata";

interface SetupUserRequestData extends SocketMetadata {
  uid: string | null;
}

export { SetupUserRequestData };
