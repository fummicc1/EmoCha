import { Server, Socket } from "socket.io"

interface Event<Data> {
    name: string;
    client: Socket | Server;
    data: Data
}

export { Event }