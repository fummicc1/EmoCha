import { Socket } from "socket.io";
import { Event } from './events';

interface MatchingEventData {
    uid: string;
}

class MatchingEvent implements Event<MatchingEventData> {
    name: string;
    client: Socket;
    data: MatchingEventData;

    constructor(name: string, client: Socket, data: MatchingEventData) {
        this.name = name;
        this.client = client;
        this.data = data;
    }
}

export { MatchingEvent, MatchingEventData };